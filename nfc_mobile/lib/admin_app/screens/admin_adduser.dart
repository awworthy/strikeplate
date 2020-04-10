import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nfc_mobile/admin_app/services/database.dart';
import 'package:nfc_mobile/shared/constants.dart';
import 'package:nfc_mobile/admin_app/services/auth.dart';
import 'package:nfc_mobile/shared/rooms.dart';
import 'package:nfc_mobile/shared/user.dart';
import 'package:provider/provider.dart';


class AdminAddUser extends StatefulWidget{

  final Function toggleView;
  AdminAddUser({ this.toggleView });

  @override
  _AdminAddUserState createState() => _AdminAddUserState();
}

class _AdminAddUserState extends State<AdminAddUser> {
  
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // text field state
  String firstName = '';
  String lastName = '';
  String email = '';
  String compName = '';
  String rooms = '';
  String error = '';
  String password = '';
  List<String> _userNames;
  String _user;
  String _userID;
  bool _edit = false; 
  bool _editActivate = false;
  List<String> _buildings;
  List<String> _rooms;
  String _building;
  String _buildingInput;
  String _room;
  bool buildingInput = false;
  bool roomInput = false;
  int valCount = 0;


 
  
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: backgroundGradient,
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Row(
                children: <Widget>[
                  SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text('Add/Update User', 
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontStyle: FontStyle.italic
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      StreamBuilder(
                                        stream: DatabaseService(userID: user.uid).adminData,
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            AdminData adminData = snapshot.data;
                                            _userNames = new List(adminData.users.length);
                                            int i = 0;
                                            adminData.users.forEach((key, value) {
                                              _userNames[i] = value["userName"];
                                              i++;
                                            });
                                            _userNames.sort();
                                            return Padding(
                                              padding: const EdgeInsets.all(16.0),
                                              child: SizedBox(
                                                  width:340,
                                                  child: DropdownButton<String>(       
                                                    value: _user,
                                                    onChanged: (String selUser) {
                                                      adminData.users.forEach((key, value) {
                                                        if(value["userName"] == selUser) {
                                                          setState(() => _user = selUser);
                                                          setState(() => _userID = key.trim());
                                                        }
                                                      }); 
                                                      if (_user != null) {
                                                        setState(() => _editActivate = true);
                                                      }
                                                    },
                                                    hint: Text('Select User',
                                                    style: TextStyle(color: Colors.white)),
                                                    iconDisabledColor: Colors.white,
                                                    iconEnabledColor: Colors.black,
                                                    focusColor: Colors.black,
                                                    items: _userNames.map<DropdownMenuItem<String>>((String value) {
                                                      return DropdownMenuItem<String>(
                                                        value: value,
                                                        child: new Text(value, 
                                                          style: TextStyle(
                                                            color: Colors.white
                                                          ),
                                                        )
                                                      );
                                                    }
                                                  ).toList(), 
                                                ),
                                              ),
                                            );
                                          } else {
                                            return Container();
                                          }  
                                        },
                                      ),
                                      _editActivate ?
                                      Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: RaisedButton(
                                              child: Text('Edit'),
                                              onPressed: () { 
                                                setState(() {
                                                  _edit = !_edit;
                                                });
                                              }
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: RaisedButton(
                                              child: Text('Delete'),
                                              onPressed: () { 
                                                
                                              }
                                            ),
                                          ),
                                        ],
                                      ) : Container(),
                                    ],
                                  ),
                                  _edit ?
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text('First Name:',
                                              style: TextStyle(
                                                color: Colors.white
                                              ),),
                                              Padding(
                                                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                                child: ConstrainedBox(
                                                  constraints: BoxConstraints(maxWidth: 200, maxHeight: 30),
                                                  child: TextFormField(
                                                    style: TextStyle(
                                                      color: Colors.white
                                                    ),
                                                    decoration: textInputDecoration,
                                                    onChanged: (val) {
                                                      setState(() => firstName = val);
                                                    },
                                                  ),
                                                ),
                                              ),
                                              Text('Email:',
                                              style: TextStyle(
                                                color: Colors.white
                                              ),),
                                              Padding(
                                                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                                child: ConstrainedBox(
                                                  constraints: BoxConstraints(maxWidth: 200, maxHeight: 30),
                                                  child: TextFormField(
                                                    style: TextStyle(
                                                      color: Colors.white
                                                    ),
                                                    decoration: textInputDecoration,
                                                    onChanged: (val) {
                                                      setState(() => email = val);
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text('Last Name: ',
                                              style: TextStyle(
                                                color: Colors.white
                                              ),),
                                              Padding(
                                                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                                child: ConstrainedBox(
                                                  constraints: BoxConstraints(maxWidth: 200, maxHeight: 30),
                                                  child: TextFormField(
                                                    style: TextStyle(
                                                      color: Colors.white
                                                    ),
                                                    decoration: textInputDecoration,
                                                    onChanged: (val) {
                                                      setState(() => lastName = val);
                                                    },
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(10.0),
                                                child: RaisedButton(
                                                  child: Text(
                                                    'Update',
                                                    ),
                                                  onPressed: () async {
                                                      setState(() => loading = true);
                                                      await DatabaseService(userID: _userID).updateExistingUserData(firstName, lastName, email);
                                                      loading = false;

                                                    }
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),    
                                      ],
                                    ),
                                  ) : Container(),
                                  Container(
                                    constraints: BoxConstraints(maxWidth: 570),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Text('Add Rooms', 
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontStyle: FontStyle.italic
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(16,0,0,0),
                                          child: Row(
                                            children: <Widget>[
                                              SizedBox(
                                                width: 75,
                                                child: Text('Building: ',
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
                                                    return SizedBox(
                                                        width:140,
                                                        child: DropdownButton<String>(       
                                                          value: _building,
                                                          onChanged: (String building) { 
                                                            setState(() => _building = building);
                                                            setState(() => _room = null);
                                                          },
                                                          hint: Text('Select Building',
                                                            style: TextStyle(
                                                              color: Colors.white
                                                              ),
                                                            ),
                                                          items: _buildings.map<DropdownMenuItem<String>>((String value) {
                                                            return DropdownMenuItem<String>(
                                                              value: value,
                                                              child: new Text(value,
                                                                style: TextStyle(
                                                                  color: Colors.grey
                                                                )
                                                              )
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
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                                          child: Row(
                                            children: <Widget>[
                                              SizedBox(
                                                width: 75,
                                                child: Text('Room: ',
                                                  style: TextStyle(
                                                    color: Colors.white
                                                  ),
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
                                                    hint: Text('Enter Room',
                                                      style: TextStyle(
                                                        color: Colors.white
                                                        ),
                                                      ),
                                                    onChanged: (String room) { 
                                                      setState(() => _room = room);
                                                    },
                                                    items: _rooms.map<DropdownMenuItem<String>>((String value) {
                                                      return DropdownMenuItem<String>(
                                                        value: value,
                                                        child: new Text(value,
                                                          style: TextStyle(
                                                            color: Colors.grey
                                                          )
                                                        )
                                                      );
                                                    }).toList(), 
                                                  );
                                                },
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: RaisedButton(
                                                  child: Text('Add'),
                                                  onPressed: () { 

                                                  }
                                                ),
                                              )
                                            ]
                                          )
                                        )
                                      ],
                                    ),
                                  ),  
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(maxHeight: 375, minWidth: 400),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.grey[500]
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            children: <Widget>[
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start, // displaying in centre. Why?
                                                children: <Widget>[
                                                  Text('User Information',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20
                                                    ),
                                                  ), 
                                                ],
                                              ),
                                              Divider(  //not showing up. Why?
                                                height: 20,
                                                color: Colors.white,
                                                thickness: 4,
                                              ),
                                              StreamBuilder(
                                                stream: DatabaseService(userID: _userID).userData,
                                                builder: (context, snapshot) {
                                                  if (snapshot.hasData) {
                                                    UserData userData = snapshot.data;
                                                    String tempRooms = "";
                                                    userData.buildings.forEach((key, value) {
                                                      tempRooms += key.toString() + ": ";
                                                      List<String> rooms = List.from(value["rooms"]);
                                                      rooms.forEach((element) {
                                                        tempRooms += element.toString();
                                                        if(element != rooms.last) {
                                                          tempRooms += ", ";
                                                        }
                                                      });
                                                    });
                                                    return Column(
                                                      children: <Widget>[
                                                        Row(
                                                          children: <Widget>[
                                                            userInfo(["UserID: ", "First Name: ", "Last Name: ", "Email: ", "Accessible Rooms"]),
                                                            Column(
                                                              children: <Widget>[
                                                                Row(
                                                                  children: <Widget>[
                                                                    userInfo([userData.uid, userData.firstName, userData.lastName, userData.email]),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  height: 24
                                                                )
                                                              ],
                                                            ),
                                                          ]
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: SizedBox(
                                                            height: 120, width: 350,
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                              border: Border.all(
                                                                color: Colors.grey[400]
                                                              )
                                                            ),
                                                            child: SingleChildScrollView(
                                                              scrollDirection: Axis.vertical,
                                                                child: Padding(
                                                                  padding: EdgeInsets.all(8),
                                                                  child: Text(tempRooms.toString(),
                                                                    style: TextStyle(
                                                                      color: Colors.white
                                                                    )
                                                                  ),
                                                                ),
                                                            ),
                                                            )
                                                          )
                                                        )
                                                      ],
                                                    );
                                                  } else {
                                                    return Container();
                                                  }
                                                }
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


Widget userInfo(List<String> info) {
  int i = 0;
  List<Padding> infoObjects = new List<Padding>();
  info.forEach((element) {
    if(i == 0) {
      infoObjects.add(new Padding(
      padding: const EdgeInsets.fromLTRB(4,0,4,4),
      child: Text(element,
        style: TextStyle(
          color: Colors.white
        )
      )
    ));
    } else {
      infoObjects.add(new Padding(
      padding: const EdgeInsets.fromLTRB(4,4,4,4),
      child: Text(element,
        style: TextStyle(
          color: Colors.white
        )
      )
    ));
    }
    i++;
  });
  
  return Column(
    children: infoObjects,  
  );
}

List<String> getNames(List<String> users){
  List<String> userNames = new List(users.length);
  int i = 0;
  users.forEach((element) async {
    DocumentSnapshot querySnapshot = await Firestore.instance.collection("users").document(element).get();
    userNames[i] = querySnapshot.data["lastName"] + ", " + querySnapshot.data["firstName"];
  });
  return userNames;
}