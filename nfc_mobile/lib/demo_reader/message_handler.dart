import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:nfc_mobile/admin_app/shared_admin/app_bar.dart';
import 'package:nfc_mobile/mobile_app/services/nfc_exchange.dart';
import 'package:nfc_mobile/mobile_app/shared_mobile/drawer.dart';
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

  /// Initialize the state of the message handler
  ///
  /// [onMessage] runs when the app is open and the app receives a signal from
  /// the server. Here it checks the content of the signal and saves a copy of
  /// the user's ID for proximity detection.
  @override
  void initState() {
    _nfcReader = NFCReader(context);
    _selector = 1;
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
            Future.delayed(Duration(seconds: 3)).then((_) {
              setState(() {
                _selector = 1;
              });
            });
          } // else something funky is going on here...
        } else {
          setState(() {
            _selector = 3;
          });
          Future.delayed(Duration(seconds: 3)).then((_) {
            setState(() {
              _selector = 1;
            });
          });
        }
      }
    );
  }

  /// Determines the device's token and registers it
  ///
  /// TODO: Change String ID so that it is working like the rest of the ID's on the Firestore database.
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

  _openDoor() {
    // Signal that the door should be opened

  }

  /// Displays a demo page for the reader.
  ///
  /// The purpose of this is to display that a user has been successfully or
  /// unsuccessfully allowed entry into a room during a POC.
  /// ie. Lock turns green or red.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(title: 'Strikeplate',),
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
                        Container(
                            height: 50
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