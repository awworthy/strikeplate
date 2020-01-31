//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/firebase.dart' as fb; 
import 'package:firebase/firestore.dart' as fs;

class DatabaseService {

  final String uid;
  DatabaseService({ this.uid });

  final fs.Firestore userCollection = fb.firestore();

  Future<void> updateUsersData(String firstName, String lastName, String email, String company, String rooms, bool isAdmin) async {
    return await userCollection.collection('users').doc(uid).set( {
      'firstName': firstName,
      'lastName': lastName,
      'company': company,
      'rooms': rooms,
      'isAdmin': isAdmin
    });
  }
}