import 'package:flutter/material.dart';
import 'package:nfc_in_flutter/nfc_in_flutter.dart';
import 'package:nfc_mobile/shared/app_bar.dart';
import 'package:nfc_mobile/screens/home/home.dart';
import 'package:nfc_mobile/theme.dart';

void main() => runApp(NFCApp());

class NFCApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home()
    );
  }
}
