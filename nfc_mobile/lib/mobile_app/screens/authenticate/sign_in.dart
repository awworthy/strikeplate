import 'package:nfc_mobile/mobile_app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:nfc_mobile/shared/constants.dart';
// import 'package:nfc_mobile/mobile_app/shared/drawer.dart';
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
      //iconTheme: new IconThemeData(color: mainFG),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
          child: Image.asset('assets/profile_gold.png'),
          ),
        ],
      ),
      
      //drawer: MakeDrawer(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: backgroundGradient,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Please sign in to Strikeplate',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20
              ),),
              SizedBox(height: 20,),
              SizedBox(
                height: 50, width: MediaQuery.of(context).size.width * .8,
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
                    setState(() => email = val);
                  },
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                height: 50, width: MediaQuery.of(context).size.width * .8,
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
                    setState(() => password = val);
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
                      error = 'Could not sign in with those credentials';
                      loading = false;
                    });
                  }
                }
              }
            ),
            SizedBox(height: MediaQuery.of(context).size.height * .1),
            Text(
              error,
              style: TextStyle(
                color: Colors.red, fontSize: 14
              ),
            ),
            Align(
              alignment: FractionalOffset.bottomCenter,
              child: Container(
                child: Column(
                  children: <Widget>[
                    Text("Not registered?",
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.yellow[200]
                      ),
                    ),
                    RaisedButton(  
                      color: Colors.yellow,
                      child: Text(
                        'Register',
                        style: TextStyle(color: Colors.black)
                      ),
                      onPressed: ()  {
                        widget.toggleView();
                      }
                    ),
                  ],
                ),
              ),
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
    );
  }
}