import 'package:flutter/material.dart';
import 'package:nfc_mobile/mobile_app/services/key_helper.dart';

/// As an [InheritedWidget] this class will provide its childs the objects it hold
///
/// By accessing [of] and providing a [BuildContext] we can access, for example, the [Config] instance.
/// Usage: `var provider = DependencyProvider.of(context);`
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