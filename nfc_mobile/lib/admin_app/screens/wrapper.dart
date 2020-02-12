// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:nfc_mobile/admin_app/screens/admin_adduser.dart';
import 'package:nfc_mobile/admin_app/screens/authenticate/authenticate.dart';
import 'package:nfc_mobile/admin_app/shared_admin/app_bar.dart';
import 'package:nfc_mobile/shared/user.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<UserClass>(context);

    if (user == null) {
      return Authenticate();
    } else {
      return CustomAppBar();
      //return HomePage(); 
    }
  }
}