import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nfc_mobile/demo_reader/hce_reader.dart';
import 'package:nfc_mobile/demo_reader/register_reader.dart';
import 'package:nfc_mobile/mobile_app/services/nfc_exchange.dart';
import 'package:nfc_mobile/mobile_app/services/storage.dart';
import 'package:nfc_mobile/mobile_app/shared_mobile/storage_provider.dart';

class InitReader extends StatefulWidget {
  @override
  _InitReaderState createState() => _InitReaderState();
}

class _InitReaderState extends State<InitReader> {
  Storage _storage;
  Future<String> _readerID;

  @override
  Widget build(BuildContext context) {
    _storage = StorageProvider.of(context).getStorage();
    _readerID = _storage.loadReader();

    return FutureBuilder<String>(
      future: _readerID,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        List<Widget> children;

        if (snapshot.hasData) {
          print("Reader ID loaded from storage: ${snapshot.data}");
          return HCEReader(snapshot.data);
        } else if (snapshot.hasError) {
          children = <Widget>[
            Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 60,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16, left: 20, right: 20),
              child: Text("Error: ${snapshot.error}"),
            )
          ];
        } else {
          return Register();
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
}
