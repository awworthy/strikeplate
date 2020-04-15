import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:nfc_in_flutter/nfc_in_flutter.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/platform_tags.dart';


/// Initialize an NFCReader object within a widget to obtain the widget's
/// context.
///   Context is used to enable NFCReader to display a loading screen
/// on Android devices as it operates.
class NFCReader {
  bool _supportsNFC = false;
  String result;
  /* IMPORTANT: Format of instruction as follows:
      00 A4 0400 07 F0010203040506 7F
        A4 = select instruction
        0400 and 07 = Parameters
        F0001234567890 = Applet ID of the reader
        7F = expected response length
   */
  static const String AID = "F0010203040506";
  static const String INSTRUCTION = "00A4040007" + AID + "7F";

  NFCReader() {
    NFC.isNDEFSupported
        .then((bool isSupported){
          this._supportsNFC = isSupported;
    });
  }

  get supportsNFC {
    return _supportsNFC;
  }

  Future<String> listen() async {
    await NfcManager.instance.startTagSession(onDiscovered: (NfcTag tag) {
      IsoDep isoDep = IsoDep.fromTag(tag);
      if (isoDep == null) {
        result = 'Error: IsoDep tag resolves to null';
        NfcManager.instance.stopSession();
        return;
      }
      Uint8List data = new Uint8List.fromList(INSTRUCTION.codeUnits);
      try {
        isoDep.transceive(data).then((value) {
          result = new String.fromCharCodes(value);
        });
      } catch (e) {
        result = e;
      }
      NfcManager.instance.stopSession();
      return;
    });
    return result;
  }
}