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

class BuildingData {

  final String bName;
  final List<Room> rooms;

  BuildingData({ this.bName, this.rooms});

}