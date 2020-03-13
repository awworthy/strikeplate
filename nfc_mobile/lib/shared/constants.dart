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

// Primary Colors for general use go here
Color mainBG = Color(0xff050819);
Color secondaryBG = Color(0xff262537);
Color tertiaryBG = Color(0xff201e33);
Color sideBarColour = tertiaryBG;
LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [secondaryBG, mainBG]
);
Color mainFG = Color(0xffffd717);
Color secondaryFG = Colors.yellowAccent;