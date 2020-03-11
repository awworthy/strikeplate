import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

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

  /// Initialize the state of the message handler
  ///
  /// [onMessage] runs when the app is open and the app receives a signal from
  /// the server. Here it checks the content of the signal and saves a copy of
  /// the user's ID for proximity detection.
  @override
  void initState() {
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        String validation = message['notification']['validation'];
        String userID = message['notification']['userID'];

        // Check if user was validated for entry first
        if (validation == 'OK') {
          // check if user is nearby using NFC!
        }
      }
    );
  }

  /// Determines the device's token and registers it
  ///
  /// TODO: Change String ID so that it is working like the rest of the ID's
  /// TODO: on the Firestore database.
  _saveDeviceToken() async {
    String ID = '1234';
    String fcmToken = await _fcm.getToken();

    // save device token to Firestore
    if (fcmToken != null) {
      var tokens = _db
          .collection('readers')
          .document(ID)
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
    return Scaffold();
  }
}
