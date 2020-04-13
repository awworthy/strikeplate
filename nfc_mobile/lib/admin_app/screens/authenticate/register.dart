import 'package:nfc_mobile/admin_app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:nfc_mobile/admin_app/services/database.dart';
import 'package:nfc_mobile/shared/constants.dart';
import 'package:nfc_mobile/shared/loading.dart';
import 'package:nfc_mobile/shared/user.dart';
import 'package:provider/provider.dart';
import '../../responsive_widget.dart';

class RegAdmin extends StatefulWidget {

  final Function toggleView;
  RegAdmin({ this.toggleView });

  @override
  _RegAdminState createState() => _RegAdminState();
}

class _RegAdminState extends State<RegAdmin> {

  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();
  String _email = "";
  String _password = "";
  String _error;

  @override
  Widget build(BuildContext context) {
    // final user = Provider.of<User>(context);
    return loading ? Loading() : Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Strikeplate'),
        textTheme: TextTheme(
          headline6: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w200,
            color: mainFG
          ),
        ),
        centerTitle: true,
        backgroundColor: secondaryBG,
        iconTheme: new IconThemeData(
          color: mainFG
        ),
        actions: <Widget>[
          SizedBox(
            height: 11,
            child: RaisedButton(  
              color: Colors.transparent,
              child: Text(
                'Sign In',
                style: TextStyle(color: Colors.yellow)
              ),
              onPressed: ()  {
                widget.toggleView();
              }
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
            child: Image.asset('assets/profile_gold.png'
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: backgroundGradient,
        ),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 50, width: 300,
                    child: TextFormField(
                      validator: (val) => val.isEmpty ? 'Enter email' : null,
                      style: TextStyle(
                        color: Colors.white),
                      decoration: textInputDecoration.copyWith(
                        hintText: 'email', 
                        hintStyle: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.white54),
                        ),
                      onChanged: (val) {
                        setState(() => _email = val.trim());
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 50, width: 300,
                      child: TextFormField(
                      validator: (val) => val.length < 6 ? 'Enter password' : null,
                      style: TextStyle(
                        color: Colors.white),
                      decoration: textInputDecoration.copyWith(
                        hintText: 'password', 
                        hintStyle: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.white54),
                        ),
                      obscureText: true,
                      onChanged: (val) {
                        setState(() => _password = val.trim());
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                RaisedButton(
                  child: Text("Register as admin"),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      setState (() => loading = true);
                      dynamic result = await _auth.registerNewAdmin(_email, _password);
                      if(result == null) {
                        setState(() {
                          loading = false;
                          _error = 'Could not register with those credentials';
                        });
                      } 
                    }
                    
                  }
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
//     return loading ? Loading() : Scaffold(
//       appBar: AppBar(
//       elevation: 0.0,
//       title: Text('Strikeplate'),
//       textTheme: TextTheme(
//         headline6: TextStyle(fontSize: 36.0, fontWeight: FontWeight.w200, color: mainFG),
//       ),
//       centerTitle: true,
//       backgroundColor: secondaryBG,
//       iconTheme: new IconThemeData(color: mainFG),
//       actions: <Widget>[
//         SizedBox(
//           height: 11,
//           child: RaisedButton(  
//             color: Colors.transparent,
//             child: Text(
//               'Sign In',
//               style: TextStyle(color: Colors.yellow)
//             ),
//             onPressed: ()  {
//               widget.toggleView();
//             }
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
//           child: Image.asset('assets/profile_gold.png'),
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: ResponsiveWidget(
//           largeScreen: RegFormLarge(),
//           smallScreen: RegFormSmall() 
//         ),
//       ),
//     );
//   }
// }

// class RegFormLarge extends StatefulWidget {
//   @override
//   _RegFormLargeState createState() => _RegFormLargeState();
// }

// class _RegFormLargeState extends State<RegFormLarge> {
//   final AuthService _auth = AuthService();
//   final _formKey = GlobalKey<FormState>();
//     final TextEditingController _pass = TextEditingController();
//   final TextEditingController _confirmPass = TextEditingController();
//   bool loading = false;

//   // text field state
//   String firstName = '';
//   String lastName = '';
//   String email = '';
//   String password = '';
//   String compName = '';
//   String rooms = '';
//   String error = '';

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: MediaQuery.of(context).size.height,
//       decoration: BoxDecoration(
//         gradient: backgroundGradient,
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(24.0),
//         child: Column(
//           children: <Widget>[
//             Text('Please sign up to Strikeplate',
//               style: TextStyle(
//               color: Colors.white,
//               fontSize: 20
//             ),),
//             Form(
//               key: _formKey,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Column(
//                       children: <Widget>[
//                         SizedBox(height: 10,),
//                         SizedBox(
//                           height: 50, width: 300,
//                           child: TextFormField(
//                             validator: (val) => val.isEmpty ? 'Enter your first name' : null,
//                             style: TextStyle(
//                               color: Colors.white),
//                               decoration: textInputDecoration.copyWith(
//                                 hintText: 'first name', 
//                                 hintStyle: TextStyle(
//                                   fontStyle: FontStyle.italic,
//                                   color: Colors.white54
//                                   ),
//                                 ),
//                             onChanged: (val) {
//                               setState(() => firstName = val.trim());
//                             },
//                           ),
//                         ),
//                         SizedBox(height: 10,),
//                         SizedBox(
//                           height: 50, width: 300,
//                           child: TextFormField(
//                             validator: (val) => val.isEmpty ? 'Enter your last name' : null,
//                             style: TextStyle(
//                               color: Colors.white),
//                               decoration: textInputDecoration.copyWith(
//                                 hintText: 'last name', 
//                                 hintStyle: TextStyle(
//                                   fontStyle: FontStyle.italic,
//                                   color: Colors.white54
//                                   ),
//                                 ),
//                             onChanged: (val) {
//                               setState(() => lastName = val.trim());
//                             },
//                           ),
//                         ),
//                         SizedBox(height: 10,),
//                         SizedBox(
//                           height: 50, width: 300,
//                           child: TextFormField(
//                             validator: (val) => val.isEmpty ? 'Enter an email' : null,
//                             style: TextStyle(
//                               color: Colors.white
//                               ),
//                             decoration: textInputDecoration.copyWith(
//                               hintText: 'email', 
//                               hintStyle: TextStyle(
//                                 fontStyle: FontStyle.italic,
//                                 color: Colors.white54
//                               ),
//                             ),
//                             onChanged: (val) {
//                               setState(() => email = val.trim());
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Column(
//                       children: <Widget>[
//                         SizedBox(height: 10,),
//                         SizedBox(
//                           height: 50, width: 300,
//                           child: TextFormField(
//                             controller: _pass,
//                             validator: (val) => val.length < 6 ? 'Enter a password 6+ chars long' : null,
//                             style: TextStyle(
//                               color: Colors.white),
//                               decoration: textInputDecoration.copyWith(
//                                 hintText: 'password', 
//                                 hintStyle: TextStyle(
//                                   fontStyle: FontStyle.italic,
//                                   color: Colors.white54
//                                   ),
//                                 ),
//                             obscureText: true,
//                             onChanged: (val) {
//                               setState(() => password = val.trim());
//                             },
//                           ),
//                         ),
//                         SizedBox(height: 10,),
//                         SizedBox(
//                           height: 50, width: 300,
//                           child: TextFormField(
//                             controller: _confirmPass,
//                             validator: (val) => val == _pass.text ? null : 'Passwords do not match',
//                             style: TextStyle(
//                               color: Colors.white),
//                               decoration: textInputDecoration.copyWith(
//                                 hintText: 'confirm password', 
//                                 hintStyle: TextStyle(
//                                   fontStyle: FontStyle.italic,
//                                   color: Colors.white54
//                                   ),
//                                 ),
//                             obscureText: true,
//                             onChanged: (val) {
//                               setState(() => password = val.trim());
//                             },
//                           ),
//                         ),
//                         SizedBox(height: 10,),
//                         RaisedButton(
//                           color: Colors.yellow,
//                           child: Text(
//                             'Register',
//                             style: TextStyle(color: Colors.black)
//                             ),
//                           onPressed: () async {
//                             if (_formKey.currentState.validate()) {
//                               setState(() => loading = true);
//                               dynamic result = await _auth.registerNewAdmin(email, password, firstName, lastName, null, null);
//                               if(result == null) {
//                                 setState(() { 
//                                   error = 'Please supply a valid email';
//                                   loading = false;
//                                 });
//                               }
//                             }
//                           }
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 12),
//                     Text(
//                       error,
//                       style: TextStyle(color: Colors.red, fontSize: 14),
//                     ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class RegFormSmall extends StatefulWidget {
//   @override
//   _RegFormSmallState createState() => _RegFormSmallState();
// }

// class _RegFormSmallState extends State<RegFormSmall> {

//   final AuthService _auth = AuthService();
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _pass = TextEditingController();
//   final TextEditingController _confirmPass = TextEditingController();
//   bool loading = false;

//   // text field state
//   String firstName = '';
//   String lastName = '';
//   String email = '';
//   String password = '';
//   String compName = '';
//   String error = '';

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: MediaQuery.of(context).size.height,
//       decoration: BoxDecoration(
//         gradient: backgroundGradient,
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(24.0),
//         child: Column(
//           children: <Widget>[
//             Text('Please sign up to Strikeplate',
//               style: TextStyle(
//               color: Colors.white,
//               fontSize: 20
//             ),),
//             Form(
//               key: _formKey,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Column(
//                     children: <Widget>[
//                       SizedBox(height: 10,),
//                       SizedBox(
//                         height: 50, width: MediaQuery.of(context).size.width *0.8,
//                         child: TextFormField(
//                           validator: (val) => val.isEmpty ? 'Enter your first name' : null,
//                           style: TextStyle(
//                             color: Colors.white),
//                             decoration: textInputDecoration.copyWith(
//                               hintText: 'first name', 
//                               hintStyle: TextStyle(
//                                 fontStyle: FontStyle.italic,
//                                 color: Colors.white54
//                                 ),
//                               ),
//                           onChanged: (val) {
//                             setState(() => firstName = val.trim());
//                           },
//                         ),
//                       ),
//                       SizedBox(height: 10,),
//                       SizedBox(
//                         height: 50, width: MediaQuery.of(context).size.width *0.8,
//                         child: TextFormField(
//                           validator: (val) => val.isEmpty ? 'Enter your last name' : null,
//                           style: TextStyle(
//                             color: Colors.white),
//                             decoration: textInputDecoration.copyWith(
//                               hintText: 'last name', 
//                               hintStyle: TextStyle(
//                                 fontStyle: FontStyle.italic,
//                                 color: Colors.white54
//                                 ),
//                               ),
//                           onChanged: (val) {
//                             setState(() => lastName = val.trim());
//                           },
//                         ),
//                       ),
//                       SizedBox(height: 10,),
//                       SizedBox(
//                         height: 50, width: MediaQuery.of(context).size.width *0.8,
//                         child: TextFormField(
//                           validator: (val) => val.isEmpty ? 'Enter an email' : null,
//                           style: TextStyle(
//                             color: Colors.white
//                             ),
//                           decoration: textInputDecoration.copyWith(
//                             hintText: 'email', 
//                             hintStyle: TextStyle(
//                               fontStyle: FontStyle.italic,
//                               color: Colors.white54
//                             ),
//                           ),
//                           onChanged: (val) {
//                             setState(() => email = val.trim());
//                           },
//                         ),
//                       ),
//                       SizedBox(height: 10,),
//                       SizedBox(
//                         height: 50, width: MediaQuery.of(context).size.width *0.8,
//                         child: TextFormField(
//                           controller: _pass,
//                           validator: (val) => val.length < 6 ? 'Enter a password 6+ chars long' : null,
//                           style: TextStyle(
//                             color: Colors.white),
//                             decoration: textInputDecoration.copyWith(
//                               hintText: 'password', 
//                               hintStyle: TextStyle(
//                                 fontStyle: FontStyle.italic,
//                                 color: Colors.white54
//                                 ),
//                               ),
//                           obscureText: true,
//                           onChanged: (val) {
//                             setState(() => password = val.trim());
//                           },
//                         ),
//                       ),
//                       SizedBox(height: 10,),
//                       SizedBox(
//                         height: 50, width: MediaQuery.of(context).size.width *0.8,
//                         child: TextFormField(
//                           controller: _confirmPass,
//                           validator: (val) => val == _pass.text ? null : 'Passwords do not match',
//                           style: TextStyle(
//                             color: Colors.white),
//                             decoration: textInputDecoration.copyWith(
//                               hintText: 'confirm password', 
//                               hintStyle: TextStyle(
//                                 fontStyle: FontStyle.italic,
//                                 color: Colors.white54
//                                 ),
//                               ),
//                           obscureText: true,
//                           onChanged: (val) {
//                             setState(() => password = val.trim());
//                           },
//                         ),
//                       ),
//                       SizedBox(height: 10,),
//                       RaisedButton(
//                         color: Colors.yellow,
//                         child: Text(
//                           'Register',
//                           style: TextStyle(color: Colors.black)
//                           ),
//                         onPressed: () async {
//                           if (_formKey.currentState.validate()) {
//                             setState(() => loading = true);
//                             dynamic result = await _auth.registerNewAdmin(email, password, firstName, lastName, null, null);
//                             if(result == null) {
//                               setState(() { 
//                                 error = 'Please supply a valid email';
//                                 loading = false;
//                               });
//                             }
//                           }
//                         }
//                       ),
//                     ],
//                   ),
//                 SizedBox(height: 20,),  
//                 SizedBox(height: 12),
//                   Text(
//                     error,
//                     style: TextStyle(color: Colors.red, fontSize: 14),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

