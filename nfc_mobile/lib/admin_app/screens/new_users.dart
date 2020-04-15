import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nfc_mobile/admin_app/services/database.dart';
import 'package:nfc_mobile/shared/constants.dart';
import 'package:nfc_mobile/shared/user.dart';
import 'package:provider/provider.dart';

class NewUsers extends StatefulWidget {
  @override
  _NewUsersState createState() => _NewUsersState();
}

class _NewUsersState extends State<NewUsers> {

  final FirebaseMessaging _fcm = FirebaseMessaging();
  String _validation;
  String _user;
  String _userID;
  Map<String,dynamic> mapFromSnapshot;
  Map<String, String> newUsers;
  String _error = "";
  

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: backgroundGradient,
        ),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'New Users',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  StreamBuilder(
                    stream: Firestore.instance.collection('users').document(user.uid).get().asStream(),
                    builder: (context, snapshot)  {
                      if(snapshot.hasData) {
                        Map<String, dynamic> mapFromSnapshot = snapshot.data["users"];
                        newUsers = new Map();
                        mapFromSnapshot.forEach((key, value) {
                          if(value["valid"] == false) {
                            newUsers[key] = value["lastName"].toString() + ", " + value["firstName"].toString();
                          }
                        });
                        if(newUsers.isNotEmpty) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width:340,
                              height: 35,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(Radius.circular(5))
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(       
                                    value: _user,
                                    onChanged: (String selUser) {
                                      newUsers.forEach((key, value) {
                                        if(value == selUser) {
                                          setState(() => _user = selUser);
                                          setState(() => _userID = key);
                                          setState(() => _error = "");
                                        }
                                      }); 
                                    },
                                    hint: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('Select User',
                                      style: TextStyle(color: Colors.black)),
                                    ),
                                    items: newUsers.values.map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(value, 
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14
                                            ),
                                          ),
                                        )
                                      );
                                    }).toList(), 
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                                width:340,
                                height: 35,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(Radius.circular(5))
                                  )
                                )
                            )
                          );
                        }  
                      } else {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                              width:340,
                              height: 35,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(Radius.circular(5))
                                )
                              )
                          )
                        );
                      }  
                    }
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8,0,8,0),
                    child: RaisedButton(
                      child: Text(
                        'Validate'
                      ),
                      onPressed: () {
                        if(_userID != null) {
                          Firestore.instance.collection("users").document(user.uid).setData({
                            'users' : { _userID : { 'valid' : true }}
                          }, merge: true);
                          setState(() => _user = null);
                        } else {
                          setState(() => _error = "No user selected");
                        }
                      }
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8,0,8,0),
                    child: RaisedButton(
                      child: Text(
                        'Remove'
                      ),
                      onPressed: () {
                        if(_userID != null) {
                          Firestore.instance.collection('users').document(user.uid).setData({
                            'users' : {_userID : FieldValue.delete()}
                          }, merge: true);
                          setState(() => _user = null);
                        } else {
                          setState(() => _error = "No user selected");
                        }
                      }
                    ),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: Text(_error,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 10
                  )  
                )
              )
            ],
          ),
        )
      ),
    );
  }
}