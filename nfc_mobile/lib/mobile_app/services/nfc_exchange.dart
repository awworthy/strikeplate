import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nfc_in_flutter/nfc_in_flutter.dart';

class RecordEditor {
  TextEditingController mediaTypeController;
  TextEditingController payloadController;

  RecordEditor() {
    mediaTypeController = TextEditingController();
    payloadController = TextEditingController();
  }
}
loadingScreen(context) {
  if (Platform.isAndroid) {
    showDialog(
      context: context,
      builder: (context) =>
        AlertDialog(
          title: const Text("Loading..."),
          actions: <Widget>[
            SpinKitFadingCube(
              size: 100,
              color: Colors.orangeAccent,
            ),
          ],
        ),
    );
  }
}

class NFCReader {
  bool _supportsNFC = false;
  bool _reading = false;
  StreamSubscription<NDEFMessage> _stream;
  List<RecordEditor> _records = [];
  BuildContext _context;

  NFCReader(BuildContext context) {
    this._context = context;
    NFC.isNDEFSupported
        .then((bool isSupported){
          this._supportsNFC = isSupported;
    });
  }

  get isReading {
    return _reading;
  }

  get supportsNFC {
    return _supportsNFC;
  }

  _stopReading() {
    _reading = false;
    _stream?.cancel();
    _stream = null;
  }

  String listen() {
    String payload;
    if (this._supportsNFC) {
      _reading = true;
      String payload;
      // Start reading using NFC.readNDEF()
      _stream = NFC.readNDEF(
      once: true,
      throwOnUserCancel: false,
      ).listen((NDEFMessage message) {
      payload = message.payload;
      }, onError: (e) {
      print(e);
      });
      _stopReading();
    }
    print ("Error: NFC not supported");
    return payload;
  }

  sendOnce(String payload) {
    if (this._supportsNFC) {
      _reading = true;
      List<NDEFRecord> records = _records.map((record) {
      return NDEFRecord.type(
      "text/plain",
      payload,
      );
      }).toList();
      NDEFMessage newMessage = NDEFMessage.withRecords(records);
      Stream<NDEFTag> stream = NFC.writeNDEF(newMessage, once: true);

      stream.listen((NDEFTag tag) {
      print("Tag written successfully");
      }, onError: (e) {
      print("Error writing to tag");
      print(e);
      });
      records = [];
    } else {
      print("Error: NFC not supported");
    }
  }
}