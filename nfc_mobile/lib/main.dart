import 'package:flutter/material.dart';
import 'package:nfc_mobile/screens/home_page.dart';
import 'package:nfc_mobile/screens/wrapper.dart';
import 'package:nfc_mobile/services/auth.dart';
import 'package:nfc_mobile/shared/constants.dart';
import 'package:provider/provider.dart';
import 'package:nfc_mobile/shared/user.dart';

void main() => runApp(NFCApp());

class NFCApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserClass>.value(
      value: AuthService().user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: sideBarColour,
          fontFamily: 'Now',
          textTheme: TextTheme(
            headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.w200),
            title: TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold, color: secondaryFG),
            body1: TextStyle(fontSize: 14.0, color: secondaryFG),
            subhead: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w200, color: secondaryFG)
          ),
        ),
        //home: AdminAddUser()
        //home: Loading()
        //home: HomePage(),
        home: Wrapper()
      ),
    );
  }
}
