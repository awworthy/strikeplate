import 'package:flutter/material.dart';
import 'package:nfc_mobile/shared/constants.dart';

class MenuItem extends StatelessWidget {

  final IconData icon;
  final String title;

  // Constructor - pass the MenuItem the values we want.
  const MenuItem({Key key, this.icon, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        children: <Widget>[
          Icon(
            icon,
            color: mainFG,
            size: 25,
          ),
          SizedBox(width: 20,),
          Text(title,
          style: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 20,
            color: secondaryFG,
          ))
        ],
      ),
    );
  }
}
