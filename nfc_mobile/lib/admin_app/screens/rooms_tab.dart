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
  List<String> _buildings;
  List<String> _rooms;
  String _building;
  String _buildingInput;
  String _room;
  String _roomInput;
  DateTime _date = DateTime.now();
  String _dateID;  
  bool buildingInput = false;
  bool roomInput = false;

  Future<Null> selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context, 
      initialDate: _date, 
      firstDate: DateTime(2000), 
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.dark(),
          child: child,
        );
      },
    );

    if (picked != null && picked != _date) {
      setState(() {
        _date = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    
    final user = Provider.of<User>(context);
    _dateID = _date.year.toString() + "-" + _date.month.toString() + "-" + _date.day.toString();
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
                  SizedBox(
                    height: 25
                  ),
                  Text('Room Management',
                  style: TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.italic),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 75,
                        child: Text('Building: '
                        )
                      ),
                      StreamBuilder(
                        stream: DatabaseService(userID: user.uid).userData,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            UserData userData = snapshot.data;
                            _buildings = new List(userData.buildings.length);
                            int i = 0;
                            userData.buildings.forEach((key, value) {_buildings[i] = key;i++;});
                            return SizedBox(
                                width:140,
                                child: DropdownButton<String>(       
                                  value: _building,
                                  onChanged: (String building) { 
                                    setState(() => _building = building);
                                    setState(() => _room = null);
                                  },
                                  hint: Text('Select Building'),
                                  items: _buildings.map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: new Text(value)
                                    );
                                  }
                                ).toList(), 
                              ),
                            );
                          } else {
                            return Container();
                          }  
                        },
                      ),
                      RaisedButton(
                        child: Text('Add'),
                        onPressed: () { 
                          if(buildingInput == false){
                            setState(() => buildingInput = true);
                          }
                          else if(buildingInput == true) {
                            setState(() => buildingInput = false);
                          }
                        }
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      RaisedButton(
                        child: Text('Delete'),
                        onPressed: () { 
                          DatabaseService(buildingID: _building, roomID: _room).deleteBuilding(); 
                          setState(() => _building = null);
                        }
                      )
                    ],
                  ),
                  buildingInput ? 
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
                            setState(() => _buildingInput = val);
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                        child: RaisedButton(
                          child: Text('Enter'),
                          onPressed: () { 
                            if (_formKey.currentState.validate()) {
                              DatabaseService(adminID: user.uid).addBuilding(_buildingInput);
                              setState(() => buildingInput = false);
                            }
                          }
                        ),
                      ),
                    ],
                  ) : 
                  Container(),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 75,
                        child: Text('Room: '
                        )
                      ),
                      StreamBuilder(
                        stream: DatabaseService(adminID: _building).roomData,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return SizedBox(
                              width: 140,
                              child: Text(
                                "Choose Building        ",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontStyle: FontStyle.italic
                                  ),
                                textAlign: TextAlign.center,
                                ),
                            );
                          }
                          BuildingRooms buildingData = snapshot.data;
                          _rooms = buildingData.rooms;
                          return DropdownButton<String>(
                            value: _room,
                            hint: Text('Enter Room'),
                            onChanged: (String room) { 
                              setState(() => _room = room);
                            },
                            items: _rooms.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: new Text(value)
                              );
                            }).toList(), 
                          );
                        },
                      ),
                      RaisedButton(
                        child: Text('Add'),
                        onPressed: () { 
                          if(roomInput == false){
                            setState(() => roomInput = true);
                          }
                          else if(roomInput == true) {
                            setState(() => roomInput = false);
                          }
                        }
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      RaisedButton(
                        child: Text('Delete'),
                        onPressed: () { 
                          if(_building != null && _room != null) {
                            print("Building = " + _building.toString() + ", Room = " + _room.toString());
                            DatabaseService(buildingID: _building, roomID: _room).deleteRoom();
                          } else {
                          print("Please input a room and a building");
                          }
                        }
                      )
                    ],
                  ),
                  roomInput ? 
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
                              hintText: 'Enter room ID', 
                              hintStyle: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 16
                              ),
                            ),
                          validator: (val) => val.isEmpty ? "Please input a room ID" : null,
                          onChanged: (val) {
                            setState(() => _roomInput = val);
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                        child: RaisedButton(
                          child: Text('Enter'),
                          onPressed: () { 
                            if (_formKey.currentState.validate()) {
                              DatabaseService(adminID: user.uid).addRoom(_building, _roomInput);
                              setState(() => roomInput = false);
                            }
                          }
                        ),
                      ),
                    ],
                  ) : 
                  Container(),
                ],
              ),
            ),
          ),
        ),
        
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text('Room Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontStyle: FontStyle.italic
                      ),
                    ),
                  IconButton(
                      icon: Icon(Icons.alarm), 
                      onPressed: () {
                        selectDate(context);
                        setState(() {
                          _dateID = _date.year.toString() + "-" + _date.month.toString() + "-" + _date.day.toString();
                        });
                      }
                    )
                  ],
                ),
                roomInfo(_building, _room, _dateID)
              ],
            ),
          ),
        )
      ],
    );
  }
}

Widget roomInfo(building, room, dateID) {
  return StreamBuilder(
    stream: DatabaseService(buildingID: building, roomID: room, date: dateID).roomLogs,
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return Container();
      }
      else {
      RoomLogs logs = snapshot.data;
      Map<String, List<dynamic>> roomLogs = logs.roomsLog;
      String timesList ='';
      roomLogs.forEach((key, value) {
        timesList += '\nUser:\t' + key.toString() + '\nTimes Accessed:\n';
        for(int i = 0; i < value.length; i++){
          timesList += '\t' + value[i].toDate().toString() + '\n';
        }
      });
      return Text(timesList);
      }
    },
  );
}
