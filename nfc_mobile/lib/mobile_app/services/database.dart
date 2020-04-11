import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nfc_mobile/shared/rooms.dart';
import 'package:nfc_mobile/shared/user.dart';

// look up if firebase has SAML
// look up Shlag

class DatabaseService {

  final String uid;
  final String date;
  final String buildingID;
  final String roomID;
  DatabaseService({ this.uid, this.date, this.buildingID, this.roomID });

  final CollectionReference userCollection = Firestore.instance.collection('users');
  final CollectionReference roomCollection = Firestore.instance.collection('buildings');


  Future<void> updateUserData(String firstName, String lastName, String email, String company, String rooms, bool isAdmin, String pubKey) async {
    await userCollection.where("isAdmin", isEqualTo: true).where("company", isEqualTo: company).getDocuments().then((data) =>
      data.documents.forEach((element) {
        element.reference.updateData({"users.$uid.firstName": firstName});
        element.reference.updateData({"users.$uid.lastName" : lastName});
     })
    );
    return await userCollection.document(uid).setData({
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'company': company,
      'isAdmin': isAdmin,
      'pubKey' : pubKey,
      'buildings' : {}
    });
  }

  // user data from snapshots
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      firstName: snapshot.data['firstName'],
      lastName: snapshot.data['lastName'],
      email: snapshot.data['email'],
      company: snapshot.data['company']
    );
  }

    // get user doc stream
  Stream<UserData> get userData {
    return userCollection.document(uid).snapshots()
      .map(_userDataFromSnapshot);
  }

  Stream<RoomAccess> get roomAccess {
    return roomCollection.document(buildingID).collection('rooms').document(roomID).snapshots()
      .map(_userAccessCheck); 
  }

  RoomAccess _userAccessCheck(DocumentSnapshot snapshot) {
    RoomAccess data = new RoomAccess(
      users: List.from(snapshot.data['usersWithAccess']),
      locked: snapshot.data['locked']
    );
    return data;
  }

  Future<void> enterRoom(Timestamp date) async {
    String dateID = date.toDate().year.toString() + '-' + date.toDate().month.toString() + '-' + date.toDate().day.toString();
    var values = { 'times' : FieldValue.arrayUnion([date]) };
    return await roomCollection.document(buildingID).collection('rooms').document(roomID).collection('roomLog').document(dateID).setData({
      uid: values 
    }, merge: true);
  }

  Future<RoomAccess> getRoomAccessData() async {
    DocumentSnapshot result = await roomCollection.document(buildingID).collection('rooms').document(roomID).get();
    if(result.data == null){
      return null;
    } else {
      RoomAccess access = new RoomAccess(users: List.from(result['usersWithAccess']), locked: result.data['locked']);
      return access;
    }
  }
}



