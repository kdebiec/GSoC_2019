import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:tuple/tuple.dart';

import 'package:retroshare/model/account.dart';
import 'package:retroshare/model/auth.dart';

dynamic checkLoggedIn() async {
  final response =
      await http.get('http://localhost:9092/rsLoginHelper/isLoggedIn');

  if (response.statusCode == 200)
    return json.decode(response.body)['retval'];
  else
    throw Exception('Failed to load response');
}

Future<bool> getLocations() async {
  final response =
      await http.get('http://localhost:9092/rsLoginHelper/getLocations');

  if (response.statusCode == 200) {
    print(response.body);

    accountsList = new List();
    json.decode(response.body)['locations'].forEach((location) {
      if (location != null)
        accountsList.add(Account(location['mLocationId'], location['mPgpId'],
            location['mLocationName'], location['mPpgName']));
    });

    return true;
  } else
    return false;
}

dynamic requestLogIn(Account selectedAccount, String password) async {
  var accountDetails = {
    'account': selectedAccount.locationId,
    'password': password
  };

  final response = await http.post(
      'http://localhost:9092/rsLoginHelper/attemptLogin',
      body: json.encode(accountDetails));

  if (response.statusCode == 200) {
    return json.decode(response.body)['retval'];
  } else {
    throw Exception('Failed to load response');
  }
}

dynamic requestAccountCreation(
    BuildContext context, String username, String password,
    [String nodeName = 'Mobile']) async {
  var accountDetails = {
    'location': {
      "mPpgName": username,
      "mLocationName": nodeName,
    },
    'password': password,
  };
  final response = await http.post(
      'http://localhost:9092/rsLoginHelper/createLocation',
      body: json.encode(accountDetails));

  if (response.statusCode == 200) {
    dynamic resp = json.decode(response.body)['location'];
    Account account = Account(resp['mLocationId'], resp['mPgpId'],
        resp['mLocationName'], resp['mPpgName']);

    return Tuple2<bool, Account>(json.decode(response.body)['retval'], account);
  } else {
    throw Exception('Failed to load response');
  }
}

Future<String> getOwnCert() async {
  final response = await http
      .get('http://localhost:9092/rsPeers/GetRetroshareInvite', headers: {
    HttpHeaders.authorizationHeader:
    'Basic ' + base64.encode(utf8.encode('$authToken'))
  });

  if (response.statusCode == 200) {
    return json.decode(response.body)['retval'];
  } else {
    throw Exception('Failed to load response');
  }
}

Future<bool> addCert(String cert) async {
  final response = await http
      .post('http://localhost:9092/rsPeers/acceptInvite', headers: {
    HttpHeaders.authorizationHeader:
    'Basic ' + base64.encode(utf8.encode('$authToken'))
  },
  body: {'invite': cert});

  if (response.statusCode == 200) {
    print(json.decode(response.body));
    return json.decode(response.body)['retval'];
  } else {
    throw Exception('Failed to load response');
  }
}
