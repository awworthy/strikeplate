import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nfc_mobile/demo_reader/message_handler.dart';

const _platform = const MethodChannel('hce');

class HCEReader extends StatefulWidget {
  @override
  _HCEReaderState createState() => _HCEReaderState();
}

class _HCEReaderState extends State<HCEReader> {

  String readerID;
  bool _hasRead = false;

  _HCEReaderState() : super() {
    _platform.setMethodCallHandler((call) async {
      bool read = call.arguments["success"];
      switch (call.method) {
        case "onHCEResult":
          setState(() {
            _hasRead = read;
          });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return DoorReader(_hasRead);
  }
}
