
class Room {

  final String rid;

  Room({ this.rid });

}

class RoomData {

  final String rid;
  final String building;
  final String status;

  RoomData({ this.rid, this.building, this.status});
}

class Building {

  final String bName;

  Building({ this.bName});

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