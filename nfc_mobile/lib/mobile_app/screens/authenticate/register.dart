import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nfc_mobile/mobile_app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:nfc_mobile/mobile_app/services/key_helper.dart';
import 'package:nfc_mobile/mobile_app/services/storage.dart';
import 'package:nfc_mobile/mobile_app/shared_mobile/rsa_provider.dart';
import 'package:nfc_mobile/mobile_app/shared_mobile/storage_provider.dart';
import 'package:nfc_mobile/shared/constants.dart';
// import 'package:nfc_mobile/mobile_app/shared/drawer.dart';
import 'package:nfc_mobile/shared/loading.dart';
import 'package:pointycastle/export.dart' as ac;

class RegAdmin extends StatefulWidget {

  final Function toggleView;
  RegAdmin({ this.toggleView });

  @override
  _RegAdminState createState() => _RegAdminState();
}

class _RegAdminState extends State<RegAdmin> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  bool loading = false;
  bool _page1 = true;
  var _keyHelper;

  String _email = '';
  String _password = '';
  String _error = '';
  String _fName = '';
  String _lName = '';
  String _company = '';
  String _pubKey = '';

  // Future reference to key pair generated by functions
  Future<ac.AsymmetricKeyPair<ac.PublicKey, ac.PrivateKey>> _futureKeyPair;

  // declare current keyPair
  ac.AsymmetricKeyPair _keyPair;

  // generate a new asymmetric key pair
  Future<ac.AsymmetricKeyPair<ac.PublicKey, ac.PrivateKey>> getKeyPair() {
    return _keyHelper.computeKeyPair(_keyHelper.getSecureRandom());
  }

  @override
  Widget build(BuildContext context) {
    _keyHelper = RSAProvider.of(context).getKeyHelper();
    return loading ? Loading() :  
    Scaffold(
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
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
          child: Image.asset('assets/profile_gold.png'),
          ),
        ],
      ),
      body: _page1 ?
      Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: backgroundGradient,
        ),
        child: Form(
          key: _formKey,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Please sign up to Strikeplate',
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
                          color: Colors.white
                          ),
                        decoration: textInputDecoration.copyWith(
                          hintText: 'email', 
                          hintStyle: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.white54
                          ),
                        ),
                        onChanged: (val) {
                          setState(() => _email = val);
                        },
                      ),
                    ),
                    SizedBox(height: 20,),
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
                              color: Colors.white54
                              ),
                            ),
                        obscureText: true,
                        onChanged: (val) {
                          setState(() => _password = val);
                        },
                      ),
                    ),
                    SizedBox(height: 20,),
                    RaisedButton(
                      color: Colors.yellow,
                      child: Text(
                        'Continue',
                        style: TextStyle(color: Colors.black)
                      ),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          // Store private key to device
                          // setState (() => _pubKey = pubKey);
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return Dialog(
                                child: Center(
                                  child: SpinKitFadingCube(
                                    size: 100,
                                    color: Colors.orangeAccent,
                                  ),
                                ),
                              );
                            },
                          );
                          _futureKeyPair = getKeyPair();
                          _futureKeyPair.then((value) {
                            _keyPair = value;
                            setState(() {
                              _page1 = false;
                              _pubKey = _keyHelper.publicToString(_keyPair.publicKey);
                              String privateKeyS = _keyHelper.privateToString(_keyPair.privateKey);
                              Storage storage = StorageProvider.of(context).getStorage();
                              storage.savePrivate(privateKeyS);
                              storage.savePublic(_pubKey);
                            });
                            Navigator.pop(context);
                          });

                        }
                      }
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * .1),
                    Text(
                      _error,
                      style: TextStyle(
                        color: Colors.red, fontSize: 14
                      ),
                    ),
                    Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Text("Already registered?",
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.yellow[200]
                              ),
                            ),
                            RaisedButton(  
                              color: Colors.yellow,
                              child: Text(
                                'Sign In',
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
                        _error,
                        style: TextStyle(color: Colors.red, fontSize: 14),
                      )
                  ],
                ),
              ),
            ],
          ),
        ),
      ): Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: backgroundGradient,
        ),
        child: Form(
          key: _formKey2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Please sign up to Strikeplate',
                      style: TextStyle(
                      color: Colors.white,
                      fontSize: 20
                    ),),
                    SizedBox(height: 20,),
                    SizedBox(
                      height: 50, width: MediaQuery.of(context).size.width * .8,
                      child: TextFormField(
                        validator: (val) => val.isEmpty ? 'Enter your first name' : null,
                        style: TextStyle(
                          color: Colors.white
                          ),
                        decoration: textInputDecoration.copyWith(
                          hintText: 'First Name', 
                          hintStyle: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.white54
                          ),
                        ),
                        onChanged: (val) {
                          setState(() => _fName = val);
                        },
                      ),
                    ),
                    SizedBox(height: 20,),
                    SizedBox(
                      height: 50, width: MediaQuery.of(context).size.width * .8,
                      child: TextFormField(
                        validator: (val) => val.isEmpty ? 'Enter your last name' : null,
                        style: TextStyle(
                          color: Colors.white
                          ),
                        decoration: textInputDecoration.copyWith(
                          hintText: 'Last Name', 
                          hintStyle: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.white54
                          ),
                        ),
                        onChanged: (val) {
                          setState(() => _lName = val);
                        },
                      ),
                    ),
                    SizedBox(height: 20,),
                    SizedBox(
                      height: 50, width: MediaQuery.of(context).size.width * .8,
                      child: TextFormField(
                        validator: (val) => val.isEmpty ? 'Enter the company you work for' : null,
                        style: TextStyle(
                          color: Colors.white
                          ),
                        decoration: textInputDecoration.copyWith(
                          hintText: 'Company Name', 
                          hintStyle: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.white54
                          ),
                        ),
                        onChanged: (val) {
                          setState(() => _company = val);
                        },
                      ),
                    ),
                    SizedBox(height: 20,),
                    RaisedButton(
                      color: Colors.yellow,
                      child: Text(
                        'Register',
                        style: TextStyle(color: Colors.black)
                      ),
                      onPressed: () async {
                        if (_formKey2.currentState.validate()) {
                          setState(() => loading = true);
                          dynamic result = await _auth.registerNewUser(_email, _password, _fName, _lName, _company, _pubKey);
                          if(result == null) {
                            setState(() { 
                              _error = 'Please supply a valid email';
                              setState(() => _page1 = true);
                              loading = false;
                            });
                          }
                        }
                      }
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * .1),
                    Text(
                      _error,
                      style: TextStyle(
                        color: Colors.red, fontSize: 14
                      ),
                    ),
                    Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Text("Already registered?",
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.yellow[200]
                              ),
                            ),
                            RaisedButton(  
                              color: Colors.yellow,
                              child: Text(
                                'Sign In',
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
                        _error,
                        style: TextStyle(color: Colors.red, fontSize: 14),
                      )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}