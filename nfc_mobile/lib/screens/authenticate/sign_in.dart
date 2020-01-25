import 'package:nfc_mobile/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:nfc_mobile/shared/app_bar.dart';
import 'package:nfc_mobile/shared/constants.dart';
import 'package:nfc_mobile/shared/drawer.dart';

class SignIn extends StatefulWidget {

  final Function toggleView;
  SignIn({ this.toggleView });

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();

  String email = '';
  String password = '';

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
            child: Column(
              children: <Widget>[
                SizedBox(height: 20,),
                TextFormField(
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
                    'Sign In',
                    style: TextStyle(color: Colors.black)
                  ),
                  onPressed: () async {
                    print(email);
                    print(password);
                  }
                ),
                SizedBox(height: 20,),
                RaisedButton(
                  color: Colors.yellow,
                  child: Text(
                    'Register',
                    style: TextStyle(color: Colors.black)
                  ),
                  onPressed: ()  {
                    widget.toggleView();
                  }
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}