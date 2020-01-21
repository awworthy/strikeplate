import 'package:flutter/material.dart';
import 'package:nfc_mobile/screens/home/home.dart';
import 'package:nfc_mobile/sidebar/sidebar.dart';

class SideBarLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
        Home(),
        SideBar(),
        ],
      )
    );
  }
}
