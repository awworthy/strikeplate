import 'package:flutter/material.dart';
import 'package:nfc_mobile/mobile_app/shared/app_bar.dart';
import 'package:nfc_mobile/mobile_app/shared/drawer.dart';

class Settings extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(title: 'Strikeplate',),
        drawer: MakeDrawer(),
        body: Container()
      );
  }
}
