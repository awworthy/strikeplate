import 'package:flutter/material.dart';
import 'package:nfc_mobile/mobile_app/services/database.dart';
import 'package:nfc_mobile/mobile_app/screens/homepage.dart';
import 'package:nfc_mobile/mobile_app/screens/settings.dart';
import 'package:nfc_mobile/mobile_app/services/auth.dart';
import 'package:nfc_mobile/shared/constants.dart';
import 'package:nfc_mobile/shared/loading.dart';
import 'package:nfc_mobile/shared/user.dart';
import 'package:provider/provider.dart';

class MakeDrawer extends StatelessWidget {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {

    User user = Provider.of<User>(context);

    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user.uid).userData,
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          UserData userData = snapshot.data;
          print(userData.name);
          return Drawer(
          elevation: 16.0,
          child: new ListView(
            children: <Widget>[
              Container(
                color: secondaryBG,
                child: new UserAccountsDrawerHeader(
                  accountName: Text(userData.name),
                  accountEmail: Text(userData.email),
                  currentAccountPicture: new CircleAvatar(
                    backgroundColor: secondaryBG,
                    child: Icon(
                      Icons.perm_identity,
                      color: mainFG,
                    ),
                    radius: 40,
                  ),
                  decoration: new BoxDecoration(
                    color: mainBG,
                    image: new DecorationImage(
                        image: AssetImage('assets/shapes_drawer_crop.jpg'),
                        fit: BoxFit.fitWidth,
                    )
                  ),
                ),
              ),
              new Container(
                color: secondaryBG,
                child: ListTileTheme(
                  selectedColor: secondaryFG,
                  iconColor: mainFG,
                  child: new Column(
                    children: <Widget>[
                      new ListTile(
                          title: Text('Home',),
                          leading: new Icon(Icons.home),
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).push(
                                new MaterialPageRoute(builder: (BuildContext context) => new HomePage())
                            );
                          },
                          
                      ),
                      new ListTile(
                          title: Text('Account Setup'),
                          leading: new Icon(Icons.person_add),
                          onTap: () {
                            // Navigator.of(context).pop();
                            // Navigator.of(context).push(
                            //     new MaterialPageRoute(builder: (BuildContext context) => new AdminAddUser())
                            // );
                          }
                      ),
                      new Divider(
                        //height: 4.0,
                        thickness: 0.5,
                        color: Colors.white.withOpacity(0.3),
                        indent: 16,
                        endIndent: 16,
                      ),
                      new ListTile(
                          title: Text('Settings'),
                          leading: new Icon(Icons.settings),
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).push(
                                new MaterialPageRoute(builder: (BuildContext context) => new Settings())
                            );
                          }
                      ),
                      new ListTile(
                          title: Text('Sign out'),
                          leading: new Icon(Icons.power_settings_new),
                          onTap: () async {
                            await _auth.signOut();
                          }
                      ),
                      Container(
                        constraints: BoxConstraints(maxHeight: 250
                        ),
                        child: Image.asset('assets/profile_gold.png')),
                      ],
                    ),
                  )
                ),
              ],
            )
          );
        }
        else {
          return Loading();
        }  
      }
    );
  }
}
