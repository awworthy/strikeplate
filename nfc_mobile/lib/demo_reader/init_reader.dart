import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:nfc_mobile/demo_reader/hce_reader.dart';
import 'package:nfc_mobile/mobile_app/services/storage.dart';
import 'package:nfc_mobile/mobile_app/shared_mobile/storage_provider.dart';

class InitReader extends StatelessWidget {
  Storage _storage;
  String _readerID;
  final FirebaseMessaging _fcm = FirebaseMessaging();
  final Firestore _db = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    _storage = StorageProvider.of(context).getStorage();
    _storage.loadReader().then((value) {
      if (value == null) {
        registerDevice();
      } else {
        _readerID = value;
      }
    });
    return HCEReader();
  }

  registerDevice() async {
    String fcmToken = await _fcm.getToken();

    // save device token to Firestore
    if (fcmToken != null) {
      DocumentReference tokens = _db
          .collection('readers')
          .document()
          .collection('tokens')
          .document(fcmToken);

      await tokens.setData({
        'token': fcmToken,
        'created': FieldValue.serverTimestamp(),
      });
      _readerID = tokens.documentID;
    }
  }
}
