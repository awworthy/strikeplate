import 'package:flutter/material.dart';
import 'package:nfc_mobile/mobile_app/services/storage.dart';

// InheritedWidget StorageProvider will be initialized high in the widget tree
// and provide a Storage class through getStorage()
class StorageProvider extends InheritedWidget {

  static StorageProvider of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<StorageProvider>());
  }

  StorageProvider({
    Key key,
    Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;

  Storage getStorage() {
    return Storage();
  }
}