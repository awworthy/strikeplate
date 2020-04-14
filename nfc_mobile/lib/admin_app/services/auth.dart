import 'package:cloud_firestore/cloud_firestore.dart';
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
      DocumentSnapshot userData = await Firestore.instance.collection("users").document(user.uid).get();
      if(userData.exists) {
        if(userData["isAdmin"] != false) {
          return _userFromFirebaseUser(user); 
        } else {
          return null;
        }
      }
    } catch (e) {
      print("sign in error = " + e.toString());
      return null;
    }
  }


  Future registerNewAdmin(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      // create a new document for the user with the uid
      await DatabaseService(adminID: user.uid).registerUserAsAdmin(); 
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