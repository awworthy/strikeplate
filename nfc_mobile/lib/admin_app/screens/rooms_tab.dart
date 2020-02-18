import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nfc_mobile/admin_app/services/database.dart';
import 'package:nfc_mobile/shared/constants.dart';
import 'package:nfc_mobile/shared/rooms.dart';
import 'package:nfc_mobile/shared/user.dart';
import 'package:provider/provider.dart';


class Rooms extends StatefulWidget {
  
  @override
  _RoomsState createState() => _RoomsState();
}

class _RoomsState extends State<Rooms> {
  final _formKey = GlobalKey<FormState>();
  String building = 'building01';
  String buildingInput = '';
  String room = 'A-101';
  DateTime date1 = new DateTime(2020, 2, 15);
  String dateID = '';  
  bool input = false;
  int count = 0;
  String test;

  @override
  Widget build(BuildContext context) {
    
    final user = Provider.of<User>(context);
    dateID = date1.year.toString() + "-" + "02" + "-" + date1.day.toString();
    test ='users';
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: MediaQuery.of(context).size.width*.6,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Choose a room',
                  style: TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.italic),
                  ),
                  Row(
                    children: <Widget>[
                      Text('Building: '),
                      BuildingsDropDown(),
                      RaisedButton(
                        child: Text('Add building'),
                        onPressed: () { 
                          if(input == false){
                            setState(() => input = true);
                          }
                          else if(input == true) {
                            setState(() => input = false);
                          }
                          
                        }
                      ),
                      
                    ],
                  ),
                  input ? 
                  Row(
                    children: <Widget>[
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 200, maxHeight: 30),
                        child: TextFormField(
                          style: TextStyle(
                            fontSize: 16,
                            ),
                            decoration: textInputDecoration.copyWith(
                              contentPadding: new EdgeInsets.all(4),
                              hintText: 'Enter building ID', 
                              hintStyle: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 16
                              ),
                            ),
                          validator: (val) => val.isEmpty ? "Please input a building ID" : null,
                          onChanged: (val) {
                            setState(() => buildingInput = val);
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                        child: RaisedButton(
                          child: Text('Enter'),
                          onPressed: () { 
                            if (_formKey.currentState.validate()) {
                              print('hello');
                              DatabaseService(id: user.uid).addBuilding(buildingInput);
                              setState(() => input = false);
                            }
                          }
                        ),
                      ),
                    ],
                  ) : 
                  Container(),
                  Row(
                    children: <Widget>[
                      Text('Room: '),
                      StreamBuilder(
                        stream: DatabaseService(id: building).roomData,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) return Container();
                          BuildingRooms buildingData = snapshot.data;
                          List<String> rooms = buildingData.rooms;
                          return DropdownButton<String>(
                            value: room,
                            onChanged: (String newValue) { 
                              setState(() => room = newValue);
                            },
                            items: rooms.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: new Text(value)
                              );
                            }).toList(), 
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              children: <Widget>[
                StreamBuilder(
                  stream: DatabaseService(id: building, id2: room, date: dateID).roomLogs,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Container();
                    }
                    RoomLogs logs = snapshot.data;
                    //Map roomLogs = logs.history;
                    List<Timestamp> times = logs.timesEntered;
                    times.sort(); // shouldn't need to be sorted if times are entered correctly
                    String timesList ='';
                    for(int i = 0; i < times.length; i++) {
                      timesList += times[i].toDate().toString();
                      if(i != times.length - 1) {
                        timesList += '\n';
                      }
                    }
                    return Text(timesList);
                  },
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class BuildingsDropDown extends StatefulWidget {
  @override
  _BuildingsDropDownState createState() => _BuildingsDropDownState();
}

class _BuildingsDropDownState extends State<BuildingsDropDown> {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
    String building = 'building02';

    return StreamBuilder(
      stream: DatabaseService(id: user.uid).userData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          UserData userData = snapshot.data;
          List<String> buildings = new List(userData.buildings.length);
          int i = 0;
          userData.buildings.forEach((key, value) {buildings[i] = key;i++;});
          return DropdownButton<String>(
            
            value: building,
            onChanged: (String newValue) { 
              setState(() => building = newValue);
            },
            items: buildings.map<DropdownMenuItem<String>>((String value) {
              print(value);
              return DropdownMenuItem<String>(
                value: value,
                child: new Text(value)
              );
            }).toList(), 
          );
        } else {
          return Text('snapshot has no data');
        }  
      },
    );
  }
}