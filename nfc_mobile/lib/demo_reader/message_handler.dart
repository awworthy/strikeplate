import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:nfc_in_flutter/nfc_in_flutter.dart';
import 'package:nfc_mobile/mobile_app/services/nfc_exchange.dart';
import 'package:nfc_mobile/mobile_app/services/storage.dart';
import 'package:nfc_mobile/mobile_app/shared_mobile/app_bar.dart';
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
  bool _supportsNFC = false;
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
  void initState() {
    _nfcReader = NFCReader(context);
    _selector = 1;
    NFC.isNDEFSupported
        .then((bool isSupported) {
      setState(() {
        _supportsNFC = isSupported;
      });
    });
    _fcm.configure(
        onMessage: (Map<String, dynamic> message) async {
          setState(() {
            _validation = message['notification']['validation'];
            _userID = message['notification']['userID'];
          });
        }
    );
  }

  /// Determines the device's token and registers it
  registerDevice() async {
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
      _readerID = tokens.documentID;
    }
  }

  /// Displays a demo page for the reader.
  ///
  /// The purpose of this is to display that a user has been successfully or
  /// unsuccessfully allowed entry into a room during a POC.
  /// ie. Lock turns green or red.
  @override
  Widget build(BuildContext context) {
    if (!_supportsNFC) {
      return RaisedButton(
        child: const Text("You device does not support NFC"),
        onPressed: null,
      );
    }
    if (_storage == null) {
      _storage = StorageProvider.of(context).getStorage();
    }
    _storage.loadReader().then((value) => _readerID = value);
    if (_readerID == null) {
      registerDevice();
      // throw "ReaderNAError: Reader contains no readerID field";
    }
    _nfcReader.send(_readerID);

    // Periodically broadcast device ID
    new Future.delayed(Duration(seconds: 4), () {
      setState(() {
        _nfcReader.send(_readerID);
        print("Reader ID: $_readerID");
      });
    });

    // Check if user was validated for entry first
    if (_validation == 'OK') {
      // check if user is nearby using NFC!
      String cast = _nfcReader.listen();
      if (_userID == cast) {
        // user device has broadcast the correct user ID to reader
        setState(() {
          _selector = 2;
        });
        Timer(Duration(seconds: 4), () {
          setState(() {
            _selector = 1;
            _validation = null;
            _userID = null;
          });
        });
      } // else something funky is going on here...
    } else if (_validation == "NO") {
      setState(() {
        _selector = 3;
      });
      Timer(Duration(seconds: 4), () {
        setState(() {
          _selector = 1;
          _validation = null;
          _userID = null;
        });
      });
    }
    return Scaffold(
        appBar: CustomAppBar(title: 'Reader',),
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
                            child: getImage(_selector),
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