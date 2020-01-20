import 'package:flutter/material.dart';
import 'package:nfc_mobile/shared/app_bar.dart';
import 'package:nfc_mobile/shared/constants.dart';

class Home extends StatelessWidget {

  final List<String> buildings = ['building1', 'building2'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Strikeplate',),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
                    child: Text('Name: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1
                    )),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
                    child: Text('Shea Odland',
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
                      letterSpacing: 1
                    )),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: Text('MacEwan University',
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
                      letterSpacing: 1
                    )),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: Text('Student',
                    ),
                  ),
                ]
              ),
              // Padding( 
              //   padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              //   child: DropdownButtonFormField(
              //     decoration: textInputDecoration,
              //     value: buildings[0],
              //     items: buildings.map((building) {
              //       return DropdownMenuItem(
              //         value: building,
              //         child: Text('$building')
              //       );
              //     }).toList(), 
              //     onChanged: (String value) { 
              //       //this will change the value for rooms displayed in the next child  
              //     },
              //   ),
              // ),
            ]
          ),
          
        ]
      )
    );
  }
}