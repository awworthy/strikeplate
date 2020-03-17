import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:nfc_mobile/admin_app/shared_admin/app_bar.dart';
import 'package:nfc_mobile/mobile_app/services/nfc_exchange.dart';
import 'package:nfc_mobile/mobile_app/services/storage.dart';
import 'package:nfc_mobile/mobile_app/shared_mobile/drawer.dart';
import 'package:nfc_mobile/mobile_app/shared_mobile/storage_provider.dart';
import 'package:nfc_mobile/shared/constants.dart';

/// Listens for incoming signals from the server. Stateful.
class MessageHandler extends StatefulWidget {
  @override
  _MessageHandlerState createState() => _MessageHandlerState();
}

/// Acts on incoming signals from the server
class _MessageHandlerState extends State<MessageHandler> {
  final Firestore _db = Firestore.instance;
  // FCM = Firebase Cloud Messaging
  final FirebaseMessaging _fcm = FirebaseMessaging();
  NFCReader _nfcReader;
  String _validation;
  String _userID;
  int _selector;
  Storage _storage;
  String _readerID;

  /// Initialize the state of the message handler
  ///
  /// [onMessage] runs when the app is open and the app receives a signal from
  /// the server. Here it checks the content of the signal and saves a copy of
  /// the user's ID for proximity detection.
  @override
  void initState() async {
    _nfcReader = NFCReader(context);
    _selector = 1;
    String readerID = await _storage.loadReader();
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        _validation = message['notification']['validation'];
        _userID = message['notification']['userID'];

        // Check if user was validated for entry first
        if (_validation == 'OK') {
          // check if user is nearby using NFC!
          String cast = _nfcReader.listen();
          if (_userID == cast) {
            // user device has broadcast the correct user ID to reader
            setState(() {
              _selector = 2;
            });
            Timer(Duration(seconds: 3), () {
              setState(() {
                _selector = 1;
              });
            });
          } // else something funky is going on here...
        } else {
          setState(() {
            _selector = 3;
          });
          Timer(Duration(seconds: 3), () {
            setState(() {
              _selector = 1;
            });
          });
        }
        setIdle();
      }
    );
    setIdle();
  }

  setIdle() {
    _storage.loadReader().then((value) => {
      if (value == null) {


        // continue here


      }
    });
    if (readerID == null) {
      throw "ReaderNAError: Reader contains no readerID field";
    }
    while (true) {
      Timer(Duration(seconds: 3), () {
        setState(() {
          _nfcReader.send(readerID);
        });
      });
    }
  }

  /// Determines the device's token and registers it
  _saveDeviceToken() async {
    String fcmToken = await _fcm.getToken();

    // save device token to Firestore
    if (fcmToken != null) {
      var tokens = _db
          .collection('readers')
          .document()
          .collection('tokens')
          .document(fcmToken);

      await tokens.setData({
        'token': fcmToken,
        'created': FieldValue.serverTimestamp(),
      });
    }
  }

  /// Displays a demo page for the reader.
  ///
  /// The purpose of this is to display that a user has been successfully or
  /// unsuccessfully allowed entry into a room during a POC.
  /// ie. Lock turns green or red.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(title: 'Reader',),
        drawer: MakeDrawer(),
        body: Container(
          decoration: BoxDecoration(
            gradient: backgroundGradient,
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                      children: <Widget>[
                        Container(
                          height: 200,
                        ),
                        ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: 240.0),
                            child: getImage(_selector)
                        ),
                      ]
                  ),
                ]
            ),
          ),
        )
    );
  }
}

/// Return a different image depending on whether the door should be opened.
Image getImage(int selector) {
  switch (selector) {
    case 1: { return Image.asset('assets/lock_button_orange.png'); }
    case 2: { return Image.asset('assets/lock_button_green.png'); }
    case 3: { return Image.asset('assets/lock_button_red.png'); }
    default: return null;
  }
}