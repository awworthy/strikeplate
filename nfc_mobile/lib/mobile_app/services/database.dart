import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nfc_mobile/mobile_app/shared/user.dart';

// look up if firebase has SAML
// look up Shlag

class DatabaseService {

  final String uid;
  DatabaseService({ this.uid });

  final CollectionReference userCollection = Firestore.instance.collection('users');

  Future<void> updateUserData(String firstName, String lastName, String email, String company, String rooms, bool isAdmin) async {
    return await userCollection.document(uid).setData({
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'company': company,
      'rooms': rooms,
      'isAdmin': isAdmin
    });
  }

  // user data from snapshots
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      name: snapshot.data['firstName'] + " " + snapshot.data['lastName'],
      email: snapshot.data['email'],
      company: snapshot.data['company']
    );
  }

    // get user doc stream
  Stream<UserData> get userData {
    return userCollection.document(uid).snapshots()
      .map(_userDataFromSnapshot);
  }
}