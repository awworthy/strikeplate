import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nfc_mobile/shared/rooms.dart';
import 'package:nfc_mobile/shared/user.dart';
// look up if firebase has SAML
// look up Shlag

class DatabaseService {

  final String adminID;
  final String userID;
  final String date;
  final String buildingID;
  final String roomID;
  DatabaseService({ this.adminID, this.userID, this.date, this.buildingID, this.roomID });

  //final fs.Firestore userCollection = fb.firestore();
  final CollectionReference userCollection = Firestore.instance.collection('users');
  final CollectionReference roomCollection = Firestore.instance.collection('buildings');

  Future<void> updateUserData(String firstName, String lastName, String email, String company, String rooms, bool isAdmin) async {
    return await userCollection.document(userID).setData({
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
      uid: userID,
      buildings: snapshot.data['buildings'],
      name: snapshot.data['firstName'] + " " + snapshot.data['lastName'],
      email: snapshot.data['email'],
      company: snapshot.data['company']
    );
  }

    // get user doc stream
  Stream<UserData> get userData {
    return userCollection.document(userID).snapshots()
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
    return roomCollection.document(adminID).snapshots()
      .map(_roomDataFromSnapshot);
  }

  RoomLogs _roomLogsFromSnapshot(DocumentSnapshot snapshot) {
    Map<dynamic, dynamic> dailyLog = Map.from(snapshot.data);
    Map<String, List<dynamic>> newDailyLog = new Map();
    Map<dynamic, dynamic> temp;
    List<dynamic> times;

    dailyLog.forEach((key, value) {
      temp = value;
      temp.forEach((otherkey, othervalue) {
        times = List.from(othervalue);
        times.forEach((element) {
          }
        );    
      });
      newDailyLog[key] = times;
    });
    return RoomLogs(
      roomsLog: newDailyLog
    );
  }

    // get user doc stream
  Stream<RoomLogs> get roomLogs {
    return roomCollection.document(buildingID).collection('rooms').document(roomID).collection('roomLog').document(date).snapshots()
      .map(_roomLogsFromSnapshot);
  }

  Future<void> addBuildingtoBuildings(String buildingID) async {
    List<String> rooms;
    return await roomCollection.document(buildingID).setData({
      'buildingID' : buildingID,
      'rooms' : rooms
    });
  }

  Future<void> addBuildingtoAdmin(String buildingID) async {
    return await userCollection.document(adminID).setData({
      'buildings' : {buildingID: {'rooms' : []}}
    }, merge: true);
  }

  Future<void> addBuilding(String buildingID) async {
    addBuildingtoBuildings(buildingID);
    addBuildingtoAdmin(buildingID);
  }

  Future<void> addRoomtoBuilding(String buildingID, String roomID) async {
    return await roomCollection.document(buildingID).collection('rooms').document(roomID).setData({
      'users' : [adminID],
      'locked' : false
    }, merge: true);
  }

  Future<void> addRoomtoBuildingFields(String buildingID, String roomID) async {
    return await roomCollection.document(buildingID).setData({
      'buildingID' : buildingID, 
      'rooms' : [roomID]
    }, merge: true);
  }

  Future<void> addRoomtoAdmin(String buildingID, String roomID) async {
    return await userCollection.document(adminID).setData({
      'buildings' : {buildingID: {'rooms' : [roomID]}}
    }, merge: true);
  }

  Future<void> addRoom(String buildingID, String roomID) async {
    addRoomtoBuilding(buildingID, roomID);
    addRoomtoBuildingFields(buildingID, roomID);
    addRoomtoAdmin(buildingID, roomID);
  }

  Future<void> deleteRoom() async {
    deleteRoomFromBuildingRoomArray();
    deleteRoomFromBuildingRoomCollection();
    deleteRoomFromAllUsers();
  }

  Future<void> deleteRoomFromBuildingRoomArray() async { // success
    DocumentReference postRef = Firestore.instance.document('buildings/$buildingID');
    return await postRef.updateData({"rooms" : FieldValue.arrayRemove([roomID])});
  }

  Future<void> deleteRoomFromBuildingRoomCollection() async { // success
    Firestore.instance.collection('buildings/$buildingID/rooms/$roomID/roomLog').getDocuments().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.documents){
        ds.reference.delete();
      }
    });
    Firestore.instance.collection('buildings/$buildingID/rooms').document(roomID).delete(); // success
  }
  
  Future<void> deleteRoomFromAllUsers() async {
    return Firestore.instance.collection('users').where("buildings.$buildingID.rooms", arrayContains: roomID).snapshots().listen((data) =>
      data.documents.forEach((element) => element.reference.updateData({"buildings.$buildingID.rooms" : FieldValue.arrayRemove([roomID])})));
  }

  Future<void> deleteBuilding() async {
    deleteBuildingFromBuildings();
    deleteRoomsFromBuilding();
    deleteBuildingFromAllUsers();
  }

  Future<void> deleteBuildingFromBuildings() async { // success
    return await roomCollection.document(buildingID).delete();
  }

  Future<void> deleteRoomsFromBuilding() async { // success
    Firestore.instance.collection('buildings/$buildingID/rooms').getDocuments().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.documents) {
        String docID = ds.documentID;
        Firestore.instance.collection('buildings/$buildingID/rooms/$docID.roomLog').getDocuments().then((snapshot) {
          for (DocumentSnapshot ds in snapshot.documents) {
            ds.reference.delete();
          }
        });
        ds.reference.delete();
      }
    });
  }
  
  Future<void> deleteBuildingFromAllUsers() async { 
    print("buildingID = " + buildingID);
    return Firestore.instance.collection('users').where("buildingList", arrayContains: buildingID).snapshots().listen((data) =>
      data.documents.forEach((element) { 
        print(element["email"]);
        element.reference.updateData({"buildingList" : FieldValue.arrayRemove([buildingID])});
        element.reference.updateData({"buildings.$buildingID": FieldValue.delete()});
        }
      )
    );
  }


}

