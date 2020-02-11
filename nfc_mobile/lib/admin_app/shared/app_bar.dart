import 'package:flutter/material.dart';
import 'package:nfc_mobile/admin_app/screens/admin_adduser.dart';
import 'package:nfc_mobile/admin_app/services/auth.dart';
import 'package:nfc_mobile/admin_app/shared/constants.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {

  final String title;
  final AuthService _auth = AuthService();

  CustomAppBar({this.title});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: <Widget>[
                Tab(icon: Icon(Icons.notifications)),
                Tab(icon: Icon(Icons.people)),
                Tab(icon: Icon(Icons.add_location))
              ],
            ),
            elevation: 0.0,
            title: Text("Strikeplate"),
            textTheme: TextTheme(
              headline6: TextStyle(fontSize: 36.0, fontWeight: FontWeight.w200, color: mainFG),
            ),
            centerTitle: true,
            backgroundColor: secondaryBG,
            iconTheme: new IconThemeData(color: mainFG),
            actions: <Widget>[
              RaisedButton(
                child: Text("Sign Out",
                  style: TextStyle(
                    color: Colors.yellow
                  ),
                ),
                color: Colors.transparent,
                onPressed: () async {
                  await _auth.signOut();
                }
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                child: Image.asset('assets/profile_gold.png'),
              ),
            ],
          ),
          body: TabBarView(
            children: [
              Icon(Icons.notifications),
              AdminAddUser(),
              Icon(Icons.add_location)
            ]),
        )
      ),
    );
  }
  @override
  Size get preferredSize => Size.fromHeight(50.0);
}

class LogoIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      child: GestureDetector(
        onTap: () {
          print('Logo Icon pressed');
        },
        child: Image(image: AssetImage('assets/profile_gold.png')),
      ),
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
    );
  }
}

