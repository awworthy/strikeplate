//import 'dart:html';

import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {

  final String title;

  CustomAppBar({this.title});


  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      title: Text(title),
      centerTitle: true,
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 120, 10),
          child: Image.asset('assets/profile_clipped.png'),
        )
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(50.0);
}
