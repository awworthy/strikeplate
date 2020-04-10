import 'package:flutter/material.dart';
import 'package:nfc_mobile/mobile_app/services/auth.dart';
import 'package:nfc_mobile/shared/constants.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {

  final String title;
  final AuthService _auth = AuthService();
  CustomAppBar({this.title});


  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      title: Text(title),
      textTheme: TextTheme(
        headline6: TextStyle(fontSize: 36.0, fontWeight: FontWeight.w200, color: mainFG),
      ),
      centerTitle: true,
      backgroundColor: secondaryBG,
      iconTheme: new IconThemeData(color: mainFG),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
          child: Image.asset('assets/profile_gold.png'),
        ),
        // RaisedButton(onPressed: () async { await _auth.signOut();})
      ],
    );
  }
  @override
  Size get preferredSize => Size.fromHeight(50.0);
}

class LogoIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      child: GestureDetector(
        onTap: () {
          print('Logo Icon pressed');
        },
        child: Image(image: AssetImage('assets/profile_gold.png')),
      ),
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
    );
  }
}

