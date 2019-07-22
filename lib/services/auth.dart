import 'dart:io';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:retroshare/model/auth.dart';

Future<bool> isAuthTokenValid() async {
  final response = await http
      .get('http://localhost:9092/jsonApiServer/getAuthorizedTokens', headers: {
    HttpHeaders.authorizationHeader:
        'Basic ' + base64.encode(utf8.encode('$authToken'))
  });

  if (response.statusCode == 200) {
    return true;
  } else
    return false;
}

Future<bool> checkExistingAuthTokens(String locationId, String password) async {
  final response = await http
      .get('http://localhost:9092/jsonApiServer/getAuthorizedTokens', headers: {
    HttpHeaders.authorizationHeader:
        'Basic ' + base64.encode(utf8.encode('$locationId:$password'))
  });

  if (response.statusCode == 200) {
    for (String token in json.decode(response.body)['retval']) {
      if (token == authToken) return true;
    }
    authorizeNewToken(locationId, password);
    return true;
  } else
    throw Exception('Failed to load response');
}

void authorizeNewToken(String locationId, String password) async {
  final response = await http.post(
      'http://localhost:9092/jsonApiServer/authorizeToken',
      body: json.encode({'token': '$authToken'}),
      headers: {
        HttpHeaders.authorizationHeader:
            'Basic ' + base64.encode(utf8.encode('$locationId:$password'))
      });

  if (response.statusCode == 200) {
    return;
  } else
    throw Exception('Failed to load response');
}
