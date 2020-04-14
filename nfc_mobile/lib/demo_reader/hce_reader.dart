import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nfc_mobile/demo_reader/message_handler.dart';
import 'package:nfc_mobile/mobile_app/services/storage.dart';
import 'package:nfc_mobile/mobile_app/shared_mobile/storage_provider.dart';

const _platform = const MethodChannel('hce');

class HCEReader extends StatefulWidget {
  final String _readerID;
  const HCEReader(this._readerID);

  @override
  _HCEReaderState createState() => _HCEReaderState();
}

class _HCEReaderState extends State<HCEReader> {

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
    Storage storage = StorageProvider.of(context).getStorage();
    storage.saveReader(widget._readerID);
    return DoorReader(_hasRead);
  }
}
