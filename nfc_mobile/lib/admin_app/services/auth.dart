import 'package:firebase_auth/firebase_auth.dart';
import 'package:nfc_mobile/admin_app/services/database.dart';
import 'package:nfc_mobile/shared/user.dart';
class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_userFromFirebaseUser);
  }
  
  // sign in anon

  Future signInAnon() async {

    try{
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print("sign in anon error = " + e.toString());
      return null;
    }
  }

  // sign in with email and password

  Future signInWithEmailandPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user); 
    } catch (e) {
      print("sign in error = " + e.toString());
      return null;
    }
  }


  Future registerNewAdmin(String email, String password, String firstName, String lastName, String company, String rooms) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      // create a new document for the user with the uid
      await DatabaseService(userID: user.uid).updateUserData(firstName, lastName, email, company, rooms, true); 
      return _userFromFirebaseUser(user); 
    } catch (e) {
      print("register error = " + e.toString());
      return null;
    }
  }

  // sign out

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print("sign out error = " + e.toString());
      return null;
    }
  }

}