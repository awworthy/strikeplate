import 'package:flutter/material.dart';
import 'package:nfc_in_flutter/nfc_in_flutter.dart';

void main() => runApp(NFCApp());

class NFCApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    // Use the following section for Home page 'globals' as we need them
    Color mainColor = Colors.deepPurple;

    return MaterialApp(
      home: Scaffold (
        appBar: AppBar(
          title: Text(
              'NFC Access Application',
            style: TextStyle(
              fontFamily: 'Quicksand',
            )
          ),
          centerTitle: true,
          backgroundColor: mainColor,
        ),
      )
    );
  }
}
