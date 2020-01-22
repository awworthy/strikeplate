import 'package:flutter/material.dart';
import 'package:nfc_in_flutter/nfc_in_flutter.dart';
import 'package:nfc_mobile/screens/admin/admin_adduser.dart';
import 'package:nfc_mobile/shared/app_bar.dart';
import 'package:nfc_mobile/screens/home/home.dart';
import 'package:nfc_mobile/shared/loading.dart';
import 'package:nfc_mobile/shared/constants.dart';
import 'package:nfc_mobile/sidebar/sidebar_layout.dart';

void main() => runApp(NFCApp());

class NFCApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Colors.white, //Color(0xFFEADEFA), << was here
        // canvasColor: Color(0xff1536f1),
        accentColor: Color(0xffbd16d2),

        fontFamily: 'Now',

        textTheme: TextTheme(
          headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          title: TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold, color: Theme.of(context).accentColor),
          body1: TextStyle(fontSize: 14.0,),
        ),
      ),
      //home: Home()
      home: AdminAddUser()
      //home: Loading()
      //home: SideBarLayout(), //Home() << was here
    );
  }
}
