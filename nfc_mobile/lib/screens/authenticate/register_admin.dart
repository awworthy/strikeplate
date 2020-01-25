import 'package:nfc_mobile/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:nfc_mobile/shared/app_bar.dart';
import 'package:nfc_mobile/shared/constants.dart';
import 'package:nfc_mobile/shared/drawer.dart';

class RegAdmin extends StatefulWidget {

  final Function toggleView;
  RegAdmin({ this.toggleView });

  @override
  _RegAdminState createState() => _RegAdminState();
}

class _RegAdminState extends State<RegAdmin> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'StrikePlate'),
      drawer: MakeDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            gradient: backgroundGradient,
          ),
          //padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(height: 20,),
                TextFormField(
                  validator: (val) => val.isEmpty ? 'Enter an email' : null,
                  style: TextStyle(
                    color: Colors.black,
                    fontStyle: FontStyle.normal),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white
                  ),
                  onChanged: (val) {
                    setState(() => email = val);
                  },
                ),
                SizedBox(height: 20,),
                TextFormField(
                  validator: (val) => val.length < 6 ? 'Enter a password 6+ chars long' : null,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white
                    
                  ),
                  obscureText: true,
                  onChanged: (val) {
                    setState(() => password = val);
                  },
                ),
                SizedBox(height: 20,),
                RaisedButton(
                  color: Colors.yellow,
                  child: Text(
                    'Register',
                    style: TextStyle(color: Colors.black)
                  ),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      dynamic result = await _auth.registerWithEmailandPassword(email, password);
                      if(result == null) {
                        setState(() => error = 'Please supply a valid email');
                      }
                    }
                  }
                ),
                SizedBox(height: 12),
                  Text(
                    error,
                    style: TextStyle(color: Colors.red, fontSize: 14),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}