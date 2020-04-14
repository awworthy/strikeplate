import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nfc_mobile/demo_reader/hce_reader.dart';
import 'package:nfc_mobile/mobile_app/services/nfc_exchange.dart';
import 'package:nfc_mobile/mobile_app/services/storage.dart';
import 'package:nfc_mobile/mobile_app/shared_mobile/storage_provider.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  Storage _storage;
  Future<String> _readerID;
  Future<int> _stored;
  String _futureID;
  final FirebaseMessaging _fcm = FirebaseMessaging();
  final Firestore _db = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    _storage = StorageProvider.of(context).getStorage();
    _readerID = registerDevice();
    _readerID.then((value) {
      _stored = _storage.saveReader(value);
      _futureID = value;
    });

    return FutureBuilder<int>(
      future: _stored,
      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
        List<Widget> children;

        if (snapshot.hasData) {
          return HCEReader(_futureID);
        } else if (snapshot.hasError) {
          children = <Widget>[
            Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 60,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text("Error: ${snapshot.error}"),
            )
          ];
        } else {
          children = <Widget>[
            SizedBox(
                child: SpinKitFadingCube(
                  size: 60,
                  color: Colors.orangeAccent,
                )),
            const Padding(
              padding: EdgeInsets.only(top: 25),
              child: Text('Loading...',
                style: TextStyle(
                  color: Colors.orangeAccent,
                  fontSize: 20.0,
                ),),
            )
          ];
        }
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: children,
            ),
          ),
        );
      },
    );
  }

  Future<String> registerDevice() async {
    String fcmToken = await _fcm.getToken();

    // save device token to Firestore
    if (fcmToken != null) {
      CollectionReference readers = _db.collection('readers');

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
    }
    return fcmToken;
  }
}
