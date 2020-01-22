import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black, width: 1)
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.pink, width: 2)
  ),
);

// Primary Colors for general use go here
Color mainBG = Color(0xff050819);
Color secondaryBG = Color(0xff262537);
Color tertiaryBG = Color(0xff201e33);
Color sideBarColour = tertiaryBG;
Color mainFG = Color(0xffffd717);
Color secondaryFG = Colors.yellowAccent;

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