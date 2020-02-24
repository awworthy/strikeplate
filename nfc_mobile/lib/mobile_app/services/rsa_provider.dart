import 'package:flutter/material.dart';
import 'package:nfc_mobile/mobile_app/services/key_helper.dart';

// InheritedWidget RSAProvider is used as a top level widget so that any widgets
// further down in the tree can use it to obtain RSA asymmetric key cryptography
// functions from getKeyHelper()
class RSAProvider extends InheritedWidget {

  static RSAProvider of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<RSAProvider>());
  }

  RSAProvider({
    Key key,
    Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;

  KeyHelper getKeyHelper() {
    return KeyHelper();
  }
}