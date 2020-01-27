import 'package:flutter/material.dart';
import 'package:nfc_mobile/screens/admin_adduser.dart';
import 'package:nfc_mobile/screens/authenticate/authenticate.dart';
import 'package:nfc_mobile/shared/user.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<UserClass>(context);
    print(user);
    if (user == null) {
      return Authenticate();
    } else {
      return AdminAddUser();
    }
  }
}