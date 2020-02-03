//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/firebase.dart' as fb; 
import 'package:firebase/firestore.dart' as fs;

// look up if firebase has SAML
// look up Shlag

class DatabaseService {

  final String uid;
  DatabaseService({ this.uid });

  final fs.Firestore userCollection = fb.firestore();

  Future<void> updateAdminData(String firstName, String lastName, String email, String company, String rooms, bool isAdmin) async {
    return await userCollection.collection('users').doc(uid).set( {
      'firstName': firstName,
      'lastName': lastName,
      'company': company,
      'rooms': rooms,
      'isAdmin': isAdmin
    });
  }

  Future<void> updateUsersData(String password, String firstName, String lastName, String email, String company, String rooms, bool isAdmin) async {
    return await userCollection.collection('users').doc(uid).set({
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      'company': company,
      'rooms': rooms,
      'isAdmin': isAdmin
    });
  }
}