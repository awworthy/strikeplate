class User {

  final String uid;

  User({ this.uid });

}

class UserData {

  final String uid;
  final String name;
  final String email;
  final String company;
  final Map buildings;

  UserData({ this.uid, this.name, this.email, this.company, this.buildings});
}
