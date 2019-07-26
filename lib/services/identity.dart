import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:retroshare/model/identity.dart';
import 'package:retroshare/model/auth.dart';

Future<List<Identity>> getOwnIdentities() async {
  List<Identity> ownSignedIdsList = List<Identity>();

  final respSigned = await http
      .get('http://localhost:9092/rsIdentity/getOwnSignedIds', headers: {
    HttpHeaders.authorizationHeader:
        'Basic ' + base64.encode(utf8.encode('$authToken'))
  });

  if (respSigned.statusCode == 200) {
    ownSignedIdsList = List();
    json.decode(respSigned.body)['ids'].forEach((id) {
      if (id != null) ownSignedIdsList.add(Identity(id, true));
    });
  }

  List<Identity> ownPseudonymousIdsList = List<Identity>();
  final respPseudonymous = await http
      .get('http://localhost:9092/rsIdentity/getOwnPseudonimousIds', headers: {
    HttpHeaders.authorizationHeader:
        'Basic ' + base64.encode(utf8.encode('$authToken'))
  });

  if (respPseudonymous.statusCode == 200) {
    json.decode(respPseudonymous.body)['ids'].forEach((id) {
      if (id != null) ownPseudonymousIdsList.add(Identity(id, false));
    });
  }

  List<Identity> ownIdsList = ownSignedIdsList + ownPseudonymousIdsList;
  await loadOwnIdentitiesDetails(ownIdsList);

  return ownIdsList;
}

dynamic loadOwnIdentitiesDetails(List<Identity> ownIdsList) async {
  bool success = true;
  do {
    success = true;
    for (Identity id in ownIdsList) {
      final response = await http.post(
          'http://localhost:9092/rsIdentity/getIdDetails',
          body: json.encode({'id': id.mId}),
          headers: {
            HttpHeaders.authorizationHeader:
            'Basic ' + base64.encode(utf8.encode('$authToken'))
          });

      if (response.statusCode == 200) {
        if (!json.decode(response.body)['retval']) {
          success = false;
          break;
        }

        id.name = json.decode(response.body)['details']['mNickname'];
      }
    }
  } while(!success);
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
