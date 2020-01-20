import 'package:flutter/material.dart';
import 'package:nfc_in_flutter/nfc_in_flutter.dart';
import 'package:nfc_mobile/shared/app_bar.dart';
import 'package:nfc_mobile/screens/home/home.dart';

void main() => runApp(NFCApp());

class NFCApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blue[300],
        accentColor: Colors.purple[800],

        fontFamily: 'Now',

        textTheme: TextTheme(
          headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          title: TextStyle(fontSize: 36.0, fontWeight: FontWeight.w200),
          body1: TextStyle(fontSize: 14.0,),
        ),
      ),
      home: Home()
    );
  }
}
