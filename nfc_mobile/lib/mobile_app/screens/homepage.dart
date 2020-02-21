import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nfc_mobile/mobile_app/services/database.dart';
// import 'package:nfc_mobile/mobile_app/services/nfc_exchange.dart';
import 'package:nfc_mobile/mobile_app/shared_mobile/app_bar.dart';
import 'package:nfc_mobile/shared/constants.dart';
import 'package:nfc_mobile/mobile_app/shared_mobile/drawer.dart';
import 'package:nfc_mobile/shared/user.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {

  final List<String> buildings = ['Building 1', 'Building 2'];

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
                  Container(
                    height: 50,
                    child: RaisedButton(
                      color: Colors.grey,
                      onPressed: () {
                        DatabaseService(uid: user.uid, buildingID: 'building01', roomID: 'A-101').enterRoom(Timestamp.now());
                      },
                      child: Text('Test')
                    ),
                  ),
                  Container(
                    height: 50
                  ),
                  GestureDetector(
                    // onTap: return NFCReader() in a pop up window, adjust the way it looks later,
                    onTap: () => print('pressed'),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 240.0),
                      child: Image.asset('assets/lock_button.png')),
                  ),
                ]
              ),
            ]
          ),
        ),
      )
    );
  }
}
