
class Room {

  final String rid;

  Room({ this.rid });

}

class RoomData {

  final bool locked;
  final List<String> usersWithAccess;
  final String readerID;

  RoomData({ this.locked, this.usersWithAccess, this.readerID});
}

class Building {

  final String buildingID;
  final String company;
  final List<String> rooms;

  Building({ this.buildingID, this.company, this.rooms });

}

class BuildingRooms {

  final List<String> rooms;

  BuildingRooms({ this.rooms});

}

class RoomLogs {

  final Map<String, List<dynamic>> roomsLog;

  RoomLogs({ this.roomsLog });

}

class RoomAccess {

  final List<String> users;
  final bool locked;

  RoomAccess({ this.users, this.locked });

}