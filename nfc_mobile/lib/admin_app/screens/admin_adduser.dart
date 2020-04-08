import 'package:flutter/material.dart';
import 'package:nfc_mobile/admin_app/services/database.dart';
// import 'package:nfc_mobile/admin_app/shared/app_bar.dart';
import 'package:nfc_mobile/shared/constants.dart';
import 'package:nfc_mobile/admin_app/services/auth.dart';
import 'package:nfc_mobile/shared/user.dart';
import 'package:provider/provider.dart';
// import 'package:nfc_mobile/admin_app/shared/loading.dart';
// import 'package:nfc_mobile/admin_app/shared/passwordGen.dart';

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
  List<String> _users;
  String _user;
  String _userRooms;
  
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Scaffold(
      //appBar: CustomAppBar(title: 'Strikeplate',),
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
                                  StreamBuilder(
                                    stream: DatabaseService(userID: user.uid).adminData,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        AdminData adminData = snapshot.data;
                                        _users = new List(adminData.users.length);
                                        int i = 0;
                                        adminData.users.forEach((value) {_users[i] = value.trim();i++;});
                                        return Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: SizedBox(
                                              width:340,
                                              child: DropdownButton<String>(       
                                                value: _user,
                                                onChanged: (String selUser) { 
                                                  setState(() => _user = selUser);
                                                },
                                                hint: Text('Select User',
                                                style: TextStyle(color: Colors.white)),
                                                iconDisabledColor: Colors.white,
                                                iconEnabledColor: Colors.black,
                                                focusColor: Colors.black,
                                                items: _users.map<DropdownMenuItem<String>>((String value) {
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
                                                    validator: (val) => val.isEmpty ? "Enter user's first name" : null,
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
                                                    validator: (val) => val.isEmpty ? "Enter user's email address" : null,
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
                                                    validator: (val) => val.isEmpty ? "Enter user's last name" : null,
                                                    decoration: textInputDecoration,
                                                    onChanged: (val) {
                                                      setState(() => lastName = val);
                                                    },
                                                  ),
                                                ),
                                              ),
                                              Text('Company: ',
                                              style: TextStyle(
                                                color: Colors.white
                                              ),),
                                              Padding(
                                                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                                child: ConstrainedBox(
                                                  constraints: BoxConstraints(maxWidth: 200, maxHeight: 30),
                                                  child: TextFormField(
                                                    validator: (val) => val.isEmpty ? "Enter user's employer" : null,
                                                    decoration: textInputDecoration,
                                                    onChanged: (val) {
                                                      setState(() => compName = val);
                                                    },
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),    
                                      ],
                                    ),
                                  ),
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
                                          padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                                          child: ConstrainedBox(
                                            constraints: BoxConstraints(maxHeight: 30),
                                            child: TextFormField(
                                              validator: (val) => val.isEmpty ? "Enter rooms user may enter" : null,
                                              decoration: textInputDecoration,
                                              onChanged: (val) {
                                                setState(() => rooms = val);
                                              },
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                          child: Container(
                                            child: Align(
                                              alignment: Alignment.bottomRight,
                                              child: RaisedButton(
                                                child: Text('Add/Update User',
                                                style: TextStyle(
                                                  color: Colors.black
                                                ),),
                                                onPressed: () async {
                                                  // if (_formKey.currentState.validate()) {
                                                  //   setState(() => loading = true);
                                                  //   dynamic result = await _auth.registerNewAdmin(email, password, firstName, lastName, compName, rooms);
                                                  //   if(result == null) {
                                                  //     setState(() { 
                                                  //       error = 'Please supply a valid email';
                                                  //       loading = false;
                                                  //     });
                                                  //   }
                                                  // }
                                                }
                                              )
                                            ),
                                          ),
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
                                                stream: DatabaseService(userID: _user).userData,
                                                builder: (context, snapshot) {
                                                  if (snapshot.hasData) {
                                                    UserData userData = snapshot.data;
                                                    String tempRooms = "";
                                                    print(userData.buildings.toString());
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
                                                            Column(
                                                              children: <Widget>[
                                                                Padding(
                                                                  padding: const EdgeInsets.all(4.0),
                                                                  child: Text('User ID: ',
                                                                    style: TextStyle(
                                                                      color: Colors.white
                                                                    ),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets.all(4.0),
                                                                  child: Text('First Name: ',
                                                                    style: TextStyle(
                                                                      color: Colors.white
                                                                    ),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets.all(4.0),
                                                                  child: Text('Last Name: ',
                                                                    style: TextStyle(
                                                                      color: Colors.white
                                                                    ),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets.all(4.0),
                                                                  child: Text('Email: ',
                                                                    style: TextStyle(
                                                                      color: Colors.white
                                                                    ),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets.all(8.0),
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.start, // displaying in centre. Why?
                                                                    children: <Widget>[
                                                                      Text('Accessible Rooms:',
                                                                        style: TextStyle(
                                                                          color: Colors.white,
                                                                          fontSize: 12
                                                                        )
                                                                      )
                                                                    ]
                                                                  )
                                                                )
                                                              ]
                                                            ),
                                                            Column(
                                                              children: <Widget>[
                                                                Padding(
                                                                  padding: const EdgeInsets.all(4.0),
                                                                  child: Text(userData.uid,
                                                                    style: TextStyle(
                                                                      color: Colors.white
                                                                    ),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets.all(4.0),
                                                                  child: Text(userData.firstName,
                                                                    style: TextStyle(
                                                                      color: Colors.white
                                                                    ),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets.all(4.0),
                                                                  child: Text(userData.lastName,
                                                                    style: TextStyle(
                                                                      color: Colors.white
                                                                    )
                                                                  )
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets.all(4.0),
                                                                  child: Text(userData.email,
                                                                    style: TextStyle(
                                                                      color: Colors.white
                                                                    ),
                                                                  ),
                                                                ),
                                                                Padding(padding: const EdgeInsets.all(14))
                                                              ]
                                                            )
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

