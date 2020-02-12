import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nfc_mobile/shared/rooms.dart';
import 'package:nfc_mobile/shared/user.dart';
// look up if firebase has SAML
// look up Shlag

class DatabaseService {

  final String uid;
  DatabaseService({ this.uid });

  //final fs.Firestore userCollection = fb.firestore();
  final CollectionReference userCollection = Firestore.instance.collection('users');
  final CollectionReference roomCollection = Firestore.instance.collection('buildings');

  Future<void> updateUserData(String firstName, String lastName, String email, String company, String rooms, bool isAdmin) async {
    return await userCollection.document(uid).setData({
      'firstName': firstName,
      'lastName': lastName,
      'email' : email,
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

  Future<void> updateRoomData(String bName, String roomID, String status) async {
    return await roomCollection.document(bName).collection('rooms').document(roomID).setData({
      'status' : status
    });
  }

  RoomData _roomDataFromSnapshot(DocumentSnapshot snapshot) {
    return RoomData(
      rid: "10001",
      building: "building02",
      status: snapshot.data['status']
    );
  }

    // get user doc stream
  Stream<RoomData> get roomData {
    return roomCollection.document('building01').collection('rooms').document('A-101').snapshots()
      .map(_roomDataFromSnapshot);
  }
}