import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'constants.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [purpleColor, blueColor]
          )
        ),
      child: Center(
        child: SpinKitRipple(
          size: 100,
          color: Colors.orangeAccent,
          borderWidth: 5,
        ),
      ),
    );
  }
}