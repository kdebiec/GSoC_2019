import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tuple/tuple.dart';

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
          //success = false;
          break;
        }

        id.name = json.decode(response.body)['details']['mNickname'];
        id.avatar = json.decode(response.body)['details']['mAvatar']['mData'];
      }
    }
  } while (!success);
}

Future<Tuple2<bool, Identity>> getIdDetails(String id) async {
  final response = await http.post(
      'http://localhost:9092/rsIdentity/getIdDetails',
      body: json.encode({'id': id}),
      headers: {
        HttpHeaders.authorizationHeader:
            'Basic ' + base64.encode(utf8.encode('$authToken'))
      });

  if (response.statusCode == 200) {
    if (json.decode(response.body)['retval']) {
      Identity identity = Identity(id);
      identity.name = json.decode(response.body)['details']['mNickname'];
      identity.avatar =
          json.decode(response.body)['details']['mAvatar']['mData'];
      identity.signed =
          json.decode(response.body)['details']['mPgpId'] != '0000000000000000';
      return Tuple2<bool, Identity>(true, identity);
    } else
      return Tuple2<bool, Identity>(false, Identity(''));
  } else
    throw Exception('Failed to load response');
}

Future<Identity> createIdentity(Identity identity, int avatarSize) async {
  final response =
      await http.post('http://localhost:9092/rsIdentity/createIdentity',
          body: json.encode({
            'name': identity.name,
            //'avatar': {'mData': identity.avatar}
          }),
          headers: {
        HttpHeaders.authorizationHeader:
            'Basic ' + base64.encode(utf8.encode('$authToken'))
      });

  if (response.statusCode == 200) {
    if (json.decode(response.body)['retval'])
      return Identity(json.decode(response.body)['id'], identity.signed,
          identity.name, identity.avatar);
    else
      return Identity('');
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

// Identities that are not contacts do not have loaded avatars
dynamic getAllIdentities() async {
  final response = await http
      .get('http://localhost:9092/rsIdentity/getIdentitiesSummaries', headers: {
    HttpHeaders.authorizationHeader:
        'Basic ' + base64.encode(utf8.encode('$authToken'))
  });

  if (response.statusCode == 200) {
    List<String> ids = List();
    json.decode(response.body)['ids'].forEach((id) {
      ids.add(id['mGroupId']);
    });

    final response2 = await http.post(
      'http://localhost:9092/rsIdentity/getIdentitiesInfo',
      headers: {
        HttpHeaders.authorizationHeader:
            'Basic ' + base64.encode(utf8.encode('$authToken'))
      },
      body: json.encode({'ids': ids}),
    );

    List<Identity> notContactIds = List();
    List<Identity> contactIds = List();
    List<Identity> signedContactIds = List();

    if (response2.statusCode == 200) {
      var idsInfo = json.decode(response2.body)['idsInfo'];
      for (var i = 0; i < idsInfo.length; i++) {
        if (idsInfo[i]['mIsAContact']) {
          bool success = true;
          Identity id;
          do {
            Tuple2<bool, Identity> tuple =
                await getIdDetails(idsInfo[i]['mMeta']['mGroupId']);
            success = tuple.item1;
            id = tuple.item2;
          } while (!success);
          contactIds.add(id);
          if (id.signed) signedContactIds.add(id);
        } else
          notContactIds.add(Identity(
              idsInfo[i]['mMeta']['mGroupId'],
              idsInfo[i]['mPgpId'] != '0000000000000000',
              idsInfo[i]['mMeta']['mGroupName'],
              '',
              false));
      }

      notContactIds.sort((id1, id2) {
        return id1.name.compareTo(id2.name);
      });

      return Tuple3<List<Identity>, List<Identity>, List<Identity>>(
          signedContactIds, contactIds, notContactIds);
    }
  } else
    throw Exception('Failed to load response');
}

Future<bool> setContact(String id, bool makeContact) async {
  final response = await http.post(
    'http://localhost:9092/rsIdentity/setAsRegularContact',
    headers: {
      HttpHeaders.authorizationHeader:
          'Basic ' + base64.encode(utf8.encode('$authToken'))
    },
    body: json.encode({'id': id, 'isContact': makeContact}),
  );

  if (response.statusCode == 200) {
    return json.decode(response.body)['retval'];
  } else
    throw Exception('Failed to load response');
}
