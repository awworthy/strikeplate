import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:nfc_mobile/demo_reader/hce_reader.dart';
import 'package:nfc_mobile/mobile_app/services/nfc_exchange.dart';
import 'package:nfc_mobile/mobile_app/services/storage.dart';
import 'package:nfc_mobile/mobile_app/shared_mobile/storage_provider.dart';

class InitReader extends StatelessWidget {
  Storage _storage;
  String _readerID;
  bool _loading = true;
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
/*
    if (_loading == true) {
      return loadingScreen(context);
    }
 */
    return HCEReader();
  }

  registerDevice() async {
    String fcmToken = await _fcm.getToken();

    // save device token to Firestore
    if (fcmToken != null) {
      CollectionReference readers = _db
          .collection('readers');

      readers.document(fcmToken).get().then((snapshot) async {
        if (!snapshot.exists) {
          await readers.document(fcmToken).setData({
            'buildingID': '',
            'roomID': '',
            'token': fcmToken,
            'created': FieldValue.serverTimestamp(),
          });
        }
      });

      print("Generating Reader ID");
      _readerID = fcmToken;
    }
  }
}
