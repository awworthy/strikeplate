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
  List<String> _buildings;
  List<String> _buildings2;
  List<String> _roomsNoReaders;
  List<String> _rooms;
  List<String> _readers;
  String _building;
  String _building2;
  String _buildingInput;
  String _room;
  String _roomNoReader;
  String _roomInput;
  String _reader;
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
    return Container(
      decoration: BoxDecoration(
        gradient: backgroundGradient,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              width: MediaQuery.of(context).size.width*.6,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Room Management',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontStyle: FontStyle.italic),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Row(
                      children: <Widget>[
                        SizedBox(
                          width: 75,
                          child: Text(
                            'Building: ',
                            style: TextStyle(
                              color: Colors.white
                            ),
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
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                    width:140,
                                    height:35,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(Radius.circular(5))
                                      ),
                                      child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                          style: TextStyle(color: Colors.black),
                                          value: _building,
                                          onChanged: (String building) { 
                                            setState(() => _building = building);
                                            setState(() => _room = null);
                                          },
                                          hint: Text(
                                            '  Select Building',
                                            style: TextStyle(
                                              color: Colors.grey
                                            ),
                                          ),
                                          items: _buildings.map<DropdownMenuItem<String>>((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Padding(
                                                padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                                                child: Text(
                                                  value,
                                                  style: TextStyle(
                                                    color: Colors.black
                                                  ),
                                                ),
                                              )
                                            );
                                          }
                                        ).toList(), 
                                  ),
                                      ),
                                    )
                                ),
                              );
                            } else {
                              return Padding(
                                padding: EdgeInsets.all(8),
                                child: SizedBox(
                                  height: 35,
                                  width: 140,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(Radius.circular(5))
                                    ),
                                    child: Text("  Select Building",
                                      style: TextStyle(
                                        color: Colors.grey
                                      ),
                                    ),
                                  ),
                                ),
                              );
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
                        Padding(
                          padding: const EdgeInsets.fromLTRB(82, 0, 0, 0),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: 240, maxHeight: 35),
                            child: TextFormField(
                              style: TextStyle(
                                fontSize: 16,
                                ),
                                decoration: textInputDecoration.copyWith(
                                  contentPadding: new EdgeInsets.all(8),
                                  hintText: 'Enter building ID', 
                                  hintStyle: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontSize: 16,
                                    color: Colors.white
                                  ),
                                ),
                              validator: (val) => val.isEmpty ? "Please input a building ID" : null,
                              onChanged: (val) {
                                setState(() => _buildingInput = val);
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
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
                          child: Text(
                            'Room: ',
                            style: TextStyle(
                              color: Colors.white
                            ),
                          )
                        ),
                        StreamBuilder(
                          stream: DatabaseService(adminID: _building).roomData,
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: 140,
                                  height: 35,
                                  child: Center(
                                    child: Text(
                                      "Choose Building ",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontStyle: FontStyle.italic
                                        ),
                                      textAlign: TextAlign.center,
                                      ),
                                  ),
                                ),
                              );
                            }
                            BuildingRooms buildingData = snapshot.data;
                            _rooms = buildingData.rooms;
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: 140,
                                height: 35,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(Radius.circular(5))
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: _room,
                                      hint: Text('  Enter Room',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14
                                        ),
                                      ),
                                      onChanged: (String room) { 
                                        setState(() => _room = room);
                                      },
                                      items: _rooms.map<DropdownMenuItem<String>>((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
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
                        Padding(
                          padding: const EdgeInsets.fromLTRB(82, 0, 0, 0),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: 240, maxHeight: 35),
                            child: TextFormField(
                              style: TextStyle(
                                fontSize: 16,
                                ),
                                decoration: textInputDecoration.copyWith(
                                  contentPadding: new EdgeInsets.all(8),
                                  hintText: 'Enter room ID', 
                                  hintStyle: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontSize: 16,
                                    color: Colors.white
                                  ),
                                ),
                              validator: (val) => val.isEmpty ? "Please input a room ID" : null,
                              onChanged: (val) {
                                setState(() => _roomInput = val);
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
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
                    SizedBox(height: 25,),
                    Text('Reader Management',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontStyle: FontStyle.italic),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: StreamBuilder(
                        stream: Firestore.instance.collection("readers").where("buildingID", isEqualTo: "").snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            QuerySnapshot documents = snapshot.data;
                            _readers = new List(documents.documents.length);
                            int i = 0;
                            documents.documents.forEach((element) {
                              _readers[i] = element.documentID.toString();
                              i++;
                            });
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
                                        value: _reader,
                                        onChanged: (String selReader) {
                                          _readers.forEach((element) {
                                            if(selReader == element.toString()) {
                                              setState(() => _reader = selReader);
                                            }
                                          });
                                        },
                                        hint: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text('Select Reader',
                                          style: TextStyle(color: Colors.black)),
                                        ),
                                        items: _readers.map<DropdownMenuItem<String>>((String value) {
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
                                        }
                                      ).toList(), 
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
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                      child: Text('Assign To:',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      )
                    ),
                    Row(
                      children: <Widget>[
                        StreamBuilder(
                          stream: DatabaseService(userID: user.uid).userData,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              UserData userData = snapshot.data;
                              _buildings2 = new List(userData.buildings.length);
                              int i = 0;
                              userData.buildings.forEach((key, value) {_buildings2[i] = key;i++;});
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                    width:140,
                                    height:35,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(Radius.circular(5))
                                      ),
                                      child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                          style: TextStyle(color: Colors.black),
                                          value: _building2,
                                          onChanged: (String building) { 
                                            setState(() => _building2 = building);
                                            setState(() => _roomNoReader = null);
                                          },
                                          hint: Text(
                                            '  Select Building',
                                            style: TextStyle(
                                              color: Colors.grey
                                            ),
                                          ),
                                          items: _buildings2.map<DropdownMenuItem<String>>((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Padding(
                                                padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                                                child: Text(
                                                  value,
                                                  style: TextStyle(
                                                    color: Colors.black
                                                  ),
                                                ),
                                              )
                                            );
                                          }
                                        ).toList(), 
                                  ),
                                      ),
                                    )
                                ),
                              );
                            } else {
                              return Padding(
                                padding: EdgeInsets.all(8),
                                child: SizedBox(
                                  height: 35,
                                  width: 140,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(Radius.circular(5))
                                    ),
                                    child: Text("  Select Building",
                                      style: TextStyle(
                                        color: Colors.grey
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }  
                          },
                        ),
                        StreamBuilder(
                          stream: Firestore.instance.collection('buildings').document(_building2).collection('rooms').where('reader', isEqualTo: null).snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              QuerySnapshot documents = snapshot.data;
                              _roomsNoReaders = new List(documents.documents.length);
                              int i = 0;
                              documents.documents.forEach((element) {
                                _roomsNoReaders[i] = element.documentID.toString();
                                i++;
                              });
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                    width:140,
                                    height: 35,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(Radius.circular(5))
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(       
                                          value: _roomNoReader,
                                          onChanged: (String selRoom) {
                                            _roomsNoReaders.forEach((element) {
                                              if(selRoom == element.toString()) {
                                                setState(() => _roomNoReader = selRoom);
                                              }
                                            });
                                          },
                                          hint: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text('Select Room',
                                            style: TextStyle(color: Colors.black)),
                                          ),
                                          items: _roomsNoReaders.map<DropdownMenuItem<String>>((String value) {
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
                                          }
                                        ).toList(), 
                                  ),
                                      ),
                                    ),
                                ),
                              );
                            } else {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                    width:140,
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
                          },
                        ),
                        RaisedButton(
                          child: Text('Assign'),
                          onPressed: () { 
                            DatabaseService().assignReader(_building2, _roomNoReader, _reader);
                            setState(() => _building2 = null);
                            setState(() => _roomNoReader = null);
                            setState(() => _reader = null);
                          }
                        ),
                      ],
                    )
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
                          fontStyle: FontStyle.italic,
                          color: Colors.white
                        ),
                      ),
                    ],
                  ),
                  _room != null ?
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height *.25,
                      width: MediaQuery.of(context).size.width * .3,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey[400]
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(5))
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: StreamBuilder(
                            stream: Firestore.instance.collection('buildings').document(_building).collection('rooms').document(_room).snapshots(),
                            builder: (context, snapshot) {
                              if(snapshot.hasData) {
                                RoomData roomData = new RoomData(locked: snapshot.data['locked'], usersWithAccess: List.from(snapshot.data['usersWithAccess']), readerID: snapshot.data['readerID']);
                                String toRet = "Building: $_building, Room: $_room\nLocked: ";
                                toRet += roomData.locked.toString() + '\nReader ID: ';
                                toRet += roomData.readerID.toString() + '\nUsers With Access:\n';
                                roomData.usersWithAccess.forEach((userID) {
                                  toRet += userID.toString() + '\n';
                                });
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(toRet,
                                    style: TextStyle(
                                      color: Colors.white
                                    ),
                                  ),
                                );
                              } else {
                                return Container();
                              }
                            }
                          ),
                        ),
                      ),
                    ),
                  ) :  
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height *.25,
                      width: MediaQuery.of(context).size.width * .3,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey[400]
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(5))
                        )
                      )
                    )
                  ),
                  Row(
                    children: <Widget>[
                      Text('Room Log',
                        style: TextStyle(
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                          color: Colors.white
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.alarm),
                        color: Colors.white, 
                        onPressed: () {
                          selectDate(context);
                          setState(() {
                            _dateID = _date.year.toString() + "-" + _date.month.toString() + "-" + _date.day.toString();
                          });
                        }
                      ),
                    ],
                  ),
                  _dateID != null ?
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * .35,
                        width: MediaQuery.of(context).size.width * .3,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey[400]
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(5))
                          ),
                          child:roomInfo(_building, _room, _dateID)
                        )
                      )
                    ) : 
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * .35,
                        width: MediaQuery.of(context).size.width * .3,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey[400]
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(5))
                          )
                        )
                      )
                    ),
                ],
              ),
            ),
          )
        ],
      ),
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
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(timesList,
          style: TextStyle(
            color: Colors.white
          ),),
      );
      }
    },
  );
}

