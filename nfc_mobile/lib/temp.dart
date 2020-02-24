import 'package:flutter/material.dart';
import 'package:nfc_mobile/mobile_app/services/auth.dart';
import 'package:nfc_mobile/mobile_app/services/rsa_provider.dart';
import 'package:nfc_mobile/mobile_app/services/storagetest.dart';
import 'package:nfc_mobile/shared/constants.dart';
import 'package:provider/provider.dart';
import 'package:nfc_mobile/shared/user.dart';

void main() {
  runApp(
      RSAProvider(
        child: NFCApp(),)
  );
}

class NFCApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            scaffoldBackgroundColor: sideBarColour,
            fontFamily: 'Now',
            textTheme: TextTheme(
                headline5: TextStyle(fontSize: 72.0, fontWeight: FontWeight.w200),
                headline6: TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold, color: secondaryFG),
                bodyText2: TextStyle(fontSize: 14.0, color: secondaryFG),
                subtitle1: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w200, color: secondaryFG)
            ),
          ),
          //home: AdminAddUser(),
          //home: Loading(),
          //home: HomePage(),
          home: StorageTest(),
      ),
    );
  }
}