import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  final String uid;
  DatabaseService({ this.uid });

  final CollectionReference usersCollection = Firestore.instance.collection('users');

  Future<void> updateUsersData(String firstName, String lastName, String email, String company, String rooms, bool isAdmin) async {
    return await usersCollection.document(uid).setData({
      'firstName': firstName,
      'lastName': lastName,
      'company': company,
      'rooms': rooms,
      'isAdmin': isAdmin
    });
  }
}