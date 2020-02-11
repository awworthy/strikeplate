import 'package:firebase/firebase.dart' as fb; 
import 'package:firebase/firestore.dart' as fs;

// look up if firebase has SAML
// look up Shlag

class DatabaseService {

  final String uid;
  DatabaseService({ this.uid });

  final fs.Firestore userCollection = fb.firestore();
  //final CollectionReference userCollection = Firestore.instance.collection('users');

  Future<void> updateUserData(String firstName, String lastName, String email, String company, String rooms, bool isAdmin) async {
    return await userCollection.collection('users').doc(uid).set({
      'firstName': firstName,
      'lastName': lastName,
      'email' : email,
      'company': company,
      'rooms': rooms,
      'isAdmin': isAdmin
    });
  }
}