import 'dart:async';
import 'dart:convert';
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
class DoorReader extends StatefulWidget {
  final bool _hasRead;
  const DoorReader(this._hasRead);

  @override
  _DoorReaderState createState() => _DoorReaderState();
}

/// Acts on incoming signals from the server
class _DoorReaderState extends State<DoorReader> {

  // FCM = Firebase Cloud Messaging
  final FirebaseMessaging _fcm = FirebaseMessaging();
  bool _supportsNFC = false;
  NFCReader _nfcReader;
  String _validation;
  String _userID;
  int _selector;

  /// Initialize the state of the message handler
  ///
  /// [onMessage] runs when the app is open and the app receives a signal from
  /// the server. Here it checks the content of the signal and saves a copy of
  /// the user's ID for proximity detection.
  @override
  void initState() {
    _nfcReader = NFCReader();
    _selector = 1;
    print("loading NFC Reader");
    NFC.isNDEFSupported
        .then((bool isSupported) {
      setState(() {
        _supportsNFC = isSupported;
      });
    });
    // Don't configure cloud messaging unless the HCE has been read by a phone
    print("Preparing to configure...");
    if (widget._hasRead) {
      print("Configuring Cloud Message Receiver...");
      _fcm.configure(
          onMessage: (Map<String, dynamic> message) async {
            setState(() {
              _validation = message['notification']['title'];
              _userID = message['notification']['body'];
              print("Message received");
              print("validation: $_validation");
              print("user: $_userID");
            });
          }
      );
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
      return Scaffold(
        body: Container(
          child: RaisedButton(
            child: const Text("Your device does not support NFC"),
            onPressed: null,
            color: Colors.yellowAccent,
          ),
        )
      );
    }

    // Check if user was validated for entry first
    if (_validation == 'OK') {
      // check if user is nearby using NFC!
      String cast = _userID;//nfcReader.listen(); //<<<<--------------testing purposes only
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
    print("Preparing Host Card Emulation...");
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