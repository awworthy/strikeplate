import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nfc_mobile/mobile_app/screens/authenticate/authenticate.dart';
import 'package:nfc_mobile/mobile_app/screens/homepage.dart';
import 'package:nfc_mobile/mobile_app/shared/user.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<UserClass>(context);

    if (user == null) {
      return Authenticate();
    } else {
      if(kIsWeb) {
        print("It's web");
        //return AdminAddUser();
      }
      return HomePage(); 
    }
  }
}