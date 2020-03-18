import 'package:nfc_mobile/admin_app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:nfc_mobile/shared/constants.dart';
import 'package:nfc_mobile/shared/loading.dart';

class SignIn extends StatefulWidget {

  final Function toggleView;
  SignIn({ this.toggleView });

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      appBar: AppBar(
      elevation: 0.0,
      title: Text('Strikeplate'),
      textTheme: TextTheme(
        headline6: TextStyle(fontSize: 36.0, fontWeight: FontWeight.w200, color: mainFG),
      ),
      centerTitle: true,
      backgroundColor: secondaryBG,
      iconTheme: new IconThemeData(color: mainFG),
      actions: <Widget>[
        SizedBox(
          height: 11,
          child: RaisedButton(  
            color: Colors.transparent,
            child: Text(
              'Register',
              style: TextStyle(color: Colors.yellow)
            ),
            onPressed: ()  {
              widget.toggleView();
            }
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
          child: Image.asset('assets/profile_gold.png'),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: backgroundGradient,
        ),
        child: Form(
          key: _formKey,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Please sign in to Strikeplate',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20
                  ),),
                  SizedBox(height: 20,),
                  SizedBox(
                    height: 50, width: 300,
                    child: TextFormField(
                      validator: (val) => val.isEmpty ? 'Enter an email' : null,
                      style: TextStyle(
                        color: Colors.white),
                      decoration: textInputDecoration.copyWith(
                        hintText: 'email', 
                        hintStyle: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.white54),
                        ),
                      onChanged: (val) {
                        setState(() => email = val.trim());
                      },
                    ),
                  ),
                  SizedBox(height: 20, width: 50,),
                  SizedBox(
                    height: 50, width: 300,
                      child: TextFormField(
                      validator: (val) => val.length < 6 ? 'Enter a password 6+ chars long' : null,
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
                        setState(() => password = val.trim());
                      },
                    ),
                  ),
                  SizedBox(height: 20,),
                  RaisedButton(
                    color: Colors.yellow,
                    child: Text(
                      'Sign In',
                      style: TextStyle(color: Colors.black)
                    ),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        setState (() => loading = true);
                        dynamic result = await _auth.signInWithEmailandPassword(email, password);
                        if(result == null) {
                          setState(() {
                          loading = false;
                          error = 'Could not sign in with those credentials';
                        });
                      }
                    }
                    }),
                  SizedBox(height: 12),
                    Text(
                      error,
                      style: TextStyle(color: Colors.red, fontSize: 14),
                    )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}