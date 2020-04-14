import 'package:nfc_mobile/admin_app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:nfc_mobile/shared/constants.dart';
import 'package:nfc_mobile/shared/loading.dart';

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


