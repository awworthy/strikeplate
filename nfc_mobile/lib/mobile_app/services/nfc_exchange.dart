import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nfc_in_flutter/nfc_in_flutter.dart';
import 'package:nfc_mobile/shared/constants.dart';


class NFCLoad extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: backgroundGradient
      ),
      child: Center(
        child: SpinKitFadingCube(
          size: 100,
          color: Colors.orangeAccent,
        ),
      ),
    );
  }
}

class NFCReader extends StatefulWidget {
  @override
  _NFCReaderState createState() => _NFCReaderState();
}

class _NFCReaderState extends State {
  bool _supportsNFC = false;
  bool _reading = false;
  StreamSubscription<NDEFMessage> _stream;

  @override
  void initState() {
    super.initState();
    // Check if the device supports NFC reading
    NFC.isNDEFSupported
        .then((bool isSupported) {
      setState(() {
        _supportsNFC = isSupported;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_supportsNFC) {
      return RaisedButton(
        child: const Text("You device does not support NFC"),
        onPressed: null,
      );
    }

    return RaisedButton(
        child: Text(_reading ? "Stop reading" : "Start reading"),
        onPressed: () {
          if (_reading) {
            _stream?.cancel();
            setState(() {
              _reading = false;
            });
          } else {
            setState(() {
              _reading = true;
              // Start reading using NFC.readNDEF()
              _stream = NFC.readNDEF(
                once: true,
                throwOnUserCancel: false,
              ).listen((NDEFMessage message) {
                print("read NDEF message: ${message.payload}");
              }, onError: (e) {
                print(e);
              });
            });
          }
        }
    );
  }
}