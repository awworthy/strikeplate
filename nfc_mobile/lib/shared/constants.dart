import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
  fillColor: Colors.transparent,
  filled: true,
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey, width: 2)
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.orange, width: 2)
  ),
);

Color blueColor = Color(0xff1536f1);
Color purpleColor = Color(0xffbd16d2);

class User extends StatelessWidget {
  final String username;
  final String email;
  final int userID;
  final String institution;

  const User({Key key,
    this.username = 'Shea Odland',
    this.email = 'odlands@strikeplate.ca',
    this.userID = 1001,
    this.institution = 'MacEwan University'
  }) : super(key: key);

  // TODO: get user credentials from database
  // hardcode them for now

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

final user = User();