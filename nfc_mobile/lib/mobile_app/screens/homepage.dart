import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nfc_mobile/mobile_app/services/database.dart';
import 'package:nfc_mobile/mobile_app/shared_mobile/app_bar.dart';
import 'package:nfc_mobile/shared/constants.dart';
import 'package:nfc_mobile/mobile_app/shared_mobile/drawer.dart';
import 'package:nfc_mobile/shared/rooms.dart';
import 'package:nfc_mobile/shared/user.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selector = 1;
  String _room;
  bool _pressA101 = false;
  bool _pressA102 = false;

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    return Scaffold(
      appBar: CustomAppBar(title: 'Strikeplate',),
      drawer: MakeDrawer(),
      body: Container(
        decoration: BoxDecoration(
          gradient: backgroundGradient,
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
            child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    height: 50,
                  ),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
                        child: Text('Step One: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: mainFG,
                          letterSpacing: 1
                        )),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
                        child: Text('Tap button below',
                        style: TextStyle(
                          color: secondaryFG
                          )
                        ),
                      ),
                    ]
                  ),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: Text('Step Two: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: mainFG,
                          letterSpacing: 1
                        )),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: Text('Place phone on Strikplate',
                          style: TextStyle(
                          color: secondaryFG
                          )
                        ),
                      ),
                    ]
                  ),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: Text('Step Three: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: mainFG,
                          letterSpacing: 1
                        )),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: Text('Enter room',
                        style: TextStyle(
                          color: secondaryFG
                        ),
                        ),
                      ),
                    ]
                  ),
                  // ConstrainedBox(
                  //   constraints: BoxConstraints(maxWidth: 240.0),
                  //   child: Padding( 
                  //     padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  //     child: DropdownButtonFormField(
                  //       decoration: textInputDecoration,
                  //       value: buildings[0],
                  //       items: buildings.map((building) {
                  //         return DropdownMenuItem(
                  //           value: building,
                  //           child: Text('$building')
                  //         );
                  //       }).toList(), 
                  //       onChanged: (String newValue) {
                  //         //this will change the value for rooms displayed in the next child

                  //       },
                  //     ),
                  //   ),
                  // ),
                  Container(
                    height: 50
                  ),  
                  Row(
                    children: <Widget>[
                      Container(
                        height: 50,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RaisedButton(
                            color: _pressA101 ? Colors.yellow : Colors.grey,
                            onPressed: () { 
                              setState(() {
                                if(_pressA102){
                                  _pressA102 = !_pressA102;
                                }
                                _pressA101 = !_pressA101;
                                _room = 'A-101';
                              });
                            },
                            child: Text('A-101')
                          ),
                        ),
                      ),
                      Container(
                        height: 50,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RaisedButton(
                            color: _pressA102 ? Colors.yellow : Colors.grey,
                            onPressed: () { 
                              setState(() {
                                if(_pressA101){
                                  _pressA101 = !_pressA101;
                                }
                                _pressA102 = !_pressA102;
                                _room = 'A-102';
                              });
                            },
                            child: Text('A-102')
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 50
                  ),
                  GestureDetector(
                    onTap: () async { 
                      dynamic result = await DatabaseService(uid: user.uid, buildingID: 'building01', roomID: _room).getRoomAccessData();
                      if(result != null) {
                        RoomAccess roomAccess = result;
                        if(roomAccess.locked == false && roomAccess.users.contains(user.uid) && _selector == 1) {
                          DatabaseService(uid: user.uid, buildingID: 'building01', roomID: _room).enterRoom(Timestamp.now());
                          setState(() {
                            _selector = 2;
                          });
                        } else {
                          setState(() {
                            _selector = 3;
                          });
                        }
                        Timer(Duration(seconds: 2), () {
                          setState(() {
                            _room = null;
                            if(_pressA101) {
                              _pressA101 = false;
                            }
                            if(_pressA102) {
                              _pressA102 = false;
                            }
                            _selector = 1;
                          });                          
                        }); 
                      } else {
                        Text('error');
                      }
                    },
                    child:  ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 240.0),
                      child: getImage(_selector)
                    ),
                  )
                ]
              ),
            ]
          ),
        ),
      )
    );
  }
}


Image getImage(int selector) {
  
  if (selector == 1) {
    return Image.asset('assets/lock_button_orange.png');
  }
  else if ( selector ==2 ) {
    return Image.asset('assets/lock_button_green.png');
  }
  else if ( selector == 3 ) {
    return Image.asset('assets/lock_button_red.png');
  }
  return null;
}