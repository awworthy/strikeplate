class User {

  final String uid;

  User({ this.uid });

}

class UserData {

  final String uid;
  final String firstName;
  final String lastName;
  final String email;
  final String company;
  final Map buildings;

  UserData({ this.uid, this.firstName, this.lastName, this.email, this.company, this.buildings});
}

class AdminData {

  final String uid;
  final String firstName;
  final String lastName;
  final String email;
  final String company;
  final Map buildings;
  final List<String> users;

  AdminData({ this.uid, this.firstName, this.lastName, this.email, this.company, this.buildings, this.users});
}
