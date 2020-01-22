import 'package:flutter/material.dart';
import 'package:nfc_mobile/sidebar/sidebar_layout.dart';

void main() => runApp(NFCApp());

class NFCApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Now',

        textTheme: TextTheme(
          headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          title: TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold, color: Theme.of(context).accentColor),
          body1: TextStyle(fontSize: 14.0,),
        ),
      ),
      //home: AdminAddUser()
      //home: Loading()
      home: SideBarLayout(),
    );
  }
}
