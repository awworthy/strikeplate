import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nfc_mobile/mobile_app/services/database.dart';
import 'package:nfc_mobile/shared/rooms.dart';
import 'package:nfc_mobile/shared/user.dart';
// look up if firebase has SAML
// look up Shlag

class DatabaseService {

  final String id;
  final String id2;
  final String date;
  DatabaseService({ this.id, this.id2, this.date });

  //final fs.Firestore userCollection = fb.firestore();
  final CollectionReference userCollection = Firestore.instance.collection('users');
  final CollectionReference roomCollection = Firestore.instance.collection('buildings');

  Future<void> updateUserData(String firstName, String lastName, String email, String company, String rooms, bool isAdmin) async {
    return await userCollection.document(id).setData({
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
      uid: id,
      buildings: snapshot.data['buildings'],
      name: snapshot.data['firstName'] + " " + snapshot.data['lastName'],
      email: snapshot.data['email'],
      company: snapshot.data['company']
    );
  }

    // get user doc stream
  Stream<UserData> get userData {
    return userCollection.document(id).snapshots()
      .map(_userDataFromSnapshot);
  }

  Future<void> updateRoomData(String bName, String roomID, String status) async {
    return await roomCollection.document(bName).collection('rooms').document(roomID).setData({
      'status' : status
    });
  }

  BuildingRooms _roomDataFromSnapshot(DocumentSnapshot snapshot) {
    return BuildingRooms(
      rooms: List.from(snapshot.data['rooms']),
    );
  }

    // get user doc stream
  Stream<BuildingRooms> get roomData {
    return roomCollection.document(id).snapshots()
      .map(_roomDataFromSnapshot);
  }

  RoomLogs _roomLogsFromSnapshot(DocumentSnapshot snapshot) {
    return RoomLogs(
      history: snapshot.data['user01'],
      timesEntered: List.from(snapshot.data['user01']['time'])
    );
  }

    // get user doc stream
  Stream<RoomLogs> get roomLogs {
    return roomCollection.document(id).collection('rooms').document(id2).collection('roomLog').document(date).snapshots()
      .map(_roomLogsFromSnapshot);
  }

  Future<void> addBuildingtoBuildings(String buildingID) async {
    return await roomCollection.document(buildingID).setData({
      'buildingID' : buildingID
    });
  }

  Future<void> addBuildingtoAdmin(String buildingID) async {
    List<String> rooms;
    return await userCollection.document(id).setData({
      'buildings' : {buildingID: {'rooms' : rooms}}
    }, merge: true);
  }

  Future<void> addBuilding(String buildingID) async {
    addBuildingtoBuildings(buildingID);
    addBuildingtoAdmin(buildingID);
  }
}