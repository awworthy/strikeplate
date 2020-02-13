import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nfc_mobile/admin_app/services/auth.dart';
import 'package:nfc_mobile/admin_app/services/database.dart';
import 'package:nfc_mobile/shared/rooms.dart';
import 'package:nfc_mobile/shared/user.dart';
import 'package:provider/provider.dart';

class Rooms extends StatelessWidget {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {

    UserClass user = Provider.of<UserClass>(context);
    
    return StreamBuilder<RoomData>(
      stream: DatabaseService(uid: user.uid).roomData,
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          RoomData roomData = snapshot.data;
          print(roomData.status);
        }
        else {
          print(snapshot.data);
        }
      }
    );
  }
}