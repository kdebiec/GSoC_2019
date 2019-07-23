import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:retroshare/model/identity.dart';
import 'package:retroshare/model/auth.dart';

Future<bool> getOwnIdentities() async {
  bool success = false;
  final respSigned = await http
      .get('http://localhost:9092/rsIdentity/getOwnSignedIds', headers: {
    HttpHeaders.authorizationHeader:
        'Basic ' + base64.encode(utf8.encode('$authToken'))
  });

  if (respSigned.statusCode == 200) {
    success = true;

    ownSignedIdsList = List();
    json.decode(respSigned.body)['ids'].forEach((id) {
      if (id != null) ownSignedIdsList.add(Identity(id));
    });
  }

  final respPseudonymous = await http
      .get('http://localhost:9092/rsIdentity/getOwnPseudonimousIds', headers: {
    HttpHeaders.authorizationHeader:
        'Basic ' + base64.encode(utf8.encode('$authToken'))
  });

  if (respPseudonymous.statusCode == 200) {
    success = true;

    ownPseudonymousIdsList = List();
    json.decode(respPseudonymous.body)['ids'].forEach((id) {
      if (id != null) ownPseudonymousIdsList.add(Identity(id));
    });
  }

  ownIdsList = ownSignedIdsList + ownPseudonymousIdsList;
  await loadOwnIdentitiesDetails();

  if(ownIdsList.isNotEmpty)
    currId = ownIdsList.first;

  return success;
}

dynamic loadOwnIdentitiesDetails() async {
  for (Identity id in ownIdsList) {
    final response = await http.post(
        'http://localhost:9092/rsIdentity/getIdDetails',
        body: json.encode({'id': id.mId}),
        headers: {
          HttpHeaders.authorizationHeader:
              'Basic ' + base64.encode(utf8.encode('$authToken'))
        });

    if (response.statusCode == 200)
      id.name = json.decode(response.body)['details']['mNickname'];
  }
}

Future<bool> createIdentity(Identity identity) async {
  final response = await http.post(
      'http://localhost:9092/rsIdentity/createIdentity',
      body: json.encode({'name': identity.name}),
      headers: {
        HttpHeaders.authorizationHeader:
            'Basic ' + base64.encode(utf8.encode('$authToken'))
      });

  if (response.statusCode == 200) {
    if (json.decode(response.body)['retval'])
      return true;
    else
      return false;
  } else
    throw Exception('Failed to load response');
}

Future<bool> deleteIdentity(Identity identity) async {
  final response = await http.post(
      'http://localhost:9092/rsIdentity/deleteIdentity',
      body: json.encode({'id': identity.mId}),
      headers: {
        HttpHeaders.authorizationHeader:
            'Basic ' + base64.encode(utf8.encode('$authToken'))
      });

  if (response.statusCode == 200) {
    if (json.decode(response.body)['retval'])
      return true;
    else
      return false;
  } else
    throw Exception('Failed to load response');
}
