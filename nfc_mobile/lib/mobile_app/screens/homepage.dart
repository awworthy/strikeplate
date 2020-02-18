import 'package:flutter/material.dart';
// import 'package:nfc_mobile/mobile_app/services/nfc_exchange.dart';
import 'package:nfc_mobile/mobile_app/shared_mobile/app_bar.dart';
import 'package:nfc_mobile/shared/constants.dart';
import 'package:nfc_mobile/mobile_app/shared_mobile/drawer.dart';

class HomePage extends StatelessWidget {

  final List<String> buildings = ['Building 1', 'Building 2'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Strikeplate',),
      drawer: MakeDrawer(),
      body: Container(
        decoration: BoxDecoration(
          gradient: backgroundGradient,
        ),
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
                  height: 100,
                ),
                GestureDetector(
                  // onTap: return NFCReader() in a pop up window, adjust the way it looks later,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 240.0),
                    child: Image.asset('assets/lock_button.png')),
                ),
              ]
            ),
          ]
        ),
      )
    );
  }
}