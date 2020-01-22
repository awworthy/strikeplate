import 'package:flutter/material.dart';
import 'package:nfc_mobile/shared/app_bar.dart';
import 'package:nfc_mobile/shared/constants.dart';
import 'package:nfc_mobile/shared/drawer.dart';

class HomePage extends StatelessWidget {

  final List<String> buildings = ['Building 1', 'Building 2'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Strikeplate',),
      drawer: makeDrawer(context),
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
                      child: Text('Name: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: mainFG,
                        letterSpacing: 1
                      )),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
                      child: Text('Shea Odland',
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
                      child: Text('Company: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: mainFG,
                        letterSpacing: 1
                      )),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: Text('MacEwan University',
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
                      child: Text('Title: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: mainFG,
                        letterSpacing: 1
                      )),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: Text('Student',
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
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 240.0),
                  child: Image.asset('assets/lock_button.png'))
              ]
            ),
          ]
        ),
      )
    );
  }
}