import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  savePrivate(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('privateKey', value);
  }

  savePublic(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('publicKey', value);
  }

  Future<String> loadPrivate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String or return 'null' if there is no value to return
    String value = prefs.getString('privateKey') ?? null;
    return value;
  }

  Future<String> loadPublic() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // return String version of public key or return 'null'
    String value = prefs.getString('publicKey') ?? null;
    return value;
  }
}