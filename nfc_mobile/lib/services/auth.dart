import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase/firebase.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // sign in anon

  Future signInAnon() async {
    // AuthResult result = await _auth.signInAnonymously();
    // FirebaseUser user = result.user;
    // return user;
    try{
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign in with email and password

  // sign out

}