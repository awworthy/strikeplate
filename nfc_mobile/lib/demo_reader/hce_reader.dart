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
  bool _authenticated = false;
  bool _validated = false;

  _HCEReaderState() : super() {
    _platform.setMethodCallHandler((call) async {
      bool auth = call.arguments["success"];
      switch (call.method) {
        case "onHCEResult":
          setState(() {
            _authenticated = auth;
          });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return ReaderMessageHandler();
  }
}
