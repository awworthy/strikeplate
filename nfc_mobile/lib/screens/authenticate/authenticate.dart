import 'package:flutter/material.dart';
import 'package:nfc_mobile/screens/authenticate/register_admin.dart';
import 'package:nfc_mobile/screens/authenticate/sign_in.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool showSignIn = true;
  void toggleView() {
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    if(showSignIn) {
      return SignIn(toggleView: toggleView);
    } else {
      return RegAdmin(toggleView: toggleView);
    }
  }
}