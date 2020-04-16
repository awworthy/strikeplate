import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nfc_mobile/mobile_app/services/database.dart';
import 'package:nfc_mobile/mobile_app/services/key_helper.dart';
import 'package:nfc_mobile/mobile_app/services/nfc_exchange.dart';
import 'package:nfc_mobile/mobile_app/services/storage.dart';
import 'package:nfc_mobile/mobile_app/shared_mobile/app_bar.dart';
import 'package:nfc_mobile/mobile_app/shared_mobile/rsa_provider.dart';
import 'package:nfc_mobile/mobile_app/shared_mobile/storage_provider.dart';
import 'package:nfc_mobile/shared/constants.dart';
import 'package:nfc_mobile/mobile_app/shared_mobile/drawer.dart';
import 'package:nfc_mobile/shared/rooms.dart';
import 'package:nfc_mobile/shared/user.dart';
import 'package:provider/provider.dart';
import "package:pointycastle/export.dart" as ac;

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selector = 1;
  String _room;
  String _building;
  String accessData = "";
  String _readerID;
  bool _pressA101 = false;
  bool _pressA102 = false;
  NFCReader _nfcReader; // context provided in widget

  @override
  Widget build(BuildContext context) {
    _nfcReader = NFCReader(context);
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
                        Row( // The next three rows display instructions for user. 1
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
                        Row( // 2
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
                        Row( // 3
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
                        Container(
                            height: 50
                        ),
                        Row( // this row contains two buttons simulating rooms
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
                            height: 60,
                            child: Center(
                              child: Text(accessData,
                              style: TextStyle(
                                fontSize: 15
                              ),),
                            ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            if (!_pressA101 && !_pressA102) {
                              _room = null;
                            }
                            if(_room == 'A-101') {
                              _readerID = "eR7qo1BAHC0:APA91bH9BNJ5CgbJLVHlHGKhjYIqxrPHBgWocMtGHb32gusGLhkDUKtXwAQEfHXEZ3yZ0cP-jb0vDp-2oMGGzoTS8KR59ZXXXNm5VRRLqohFK0enKAsMwAkkLhki4UzKcDkSYslmP9by"; 
                            }
                            if(_room == 'A-102') {
                              _readerID = "ewR81pflgUI:APA91bGdlGn5ULwhSSQ_PRW-zNnHfc0_hxliSmpwcwVByzpkUX9A63aUm0-jcL7Y9YJX3vSgzT1-sI3Ok7mHrWkhqL3Ra8cRSQ3_5YoHVhPDGX0hR7PIgoSUxMpmskbp1k20th3d1OOY";
                            }
                            await Firestore.instance.collection('readers').document(_readerID).get().then((doc) async {
                              if(doc != null) {
                                _room = doc['roomID'];
                                _building = doc['buildingID'];
                                // _room = _nfcReader.listen();
                                dynamic result = await DatabaseService(uid: user.uid, buildingID: _building, roomID: _room).getRoomAccessData();
                                if(result != null) {
                                  RoomAccess roomAccess = result;
                                  if(roomAccess.locked == false && roomAccess.users.contains(user.uid) && _selector == 1) {
                                    // send userID to server
                                    String status = await _makePostRequest(context, user.uid, _readerID);
                                    // submit log entry for user with room
                                    if (status == "true") {
                                      DatabaseService(uid: user.uid, buildingID: _building, roomID: _room).enterRoom(Timestamp.now());
                                      setState(() {
                                        _selector = 2;
                                        accessData = "";
                                      });
                                    } else {
                                      setState(() {
                                        accessData = "Access Denied";
                                        _selector = 3;
                                      });
                                    }
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
                                      if(accessData.length > 0) {
                                        accessData = "";
                                      }
                                      _selector = 1;
                                    });
                                  });
                                } else {
                                  Text('error');
                                }
                              }
                            });
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
  switch(selector) {
    case 1: { return Image.asset('assets/lock_button_orange.png'); }
    case 2: { return Image.asset('assets/lock_button_green.png'); }
    case 3: { return Image.asset('assets/lock_button_red.png'); }
    default: return null;
  }
}

Future<String> _makePostRequest(BuildContext context, String uid, String readerID) async {  // set up POST request arguments
  var client = http.Client();
  String url = 'https://us-central1-strikeplate-app.cloudfunctions.net/postUserID';
  Map<String, String> headers = {"Content-type": "application/json"};
  String json = '{"FunctionType" : "1", "challenge": ""}';  // make POST request

  // Get Crypto and Storage classes
  KeyHelper _keyHelper = RSAProvider.of(context).getKeyHelper();
  Storage _storage = StorageProvider.of(context).getStorage();

  try {
    var response = await client.post(url, headers: headers, body: json);  // check the status code for the result
    switch(response.statusCode) {
      case 200: {
        String body = response.body;
        var parsedJson = jsonDecode(body);
        String challenge = parsedJson["challenge"];
        String nonceID = parsedJson["nonceID"];
        String _privateKey = await _storage.loadPrivate();
        if (_privateKey == null) {
          throw "Error: no Private Key saved to device\nPlease register properly\n...Aborting";
        }
        ac.RSAPrivateKey _pKey = _keyHelper.parsePrivateFromString(_privateKey);
        String signature = _keyHelper.sign(challenge, _pKey);
        json = '{"FunctionType" : "2", "userID": "$uid", "signature": "$signature", "nonceID": "$nonceID", "readerID" : "$readerID"}';
        response = await client.post(url, headers: headers, body: json);
        body = response.body;
        parsedJson = jsonDecode(body);
        String status = parsedJson["status"];
        client.close();
        return status;
      }
      default: {
        client.close();
        return "Error " + response.statusCode.toString() + ": Please try again";
      }
    }
  } finally {
    client.close();
  }
}