import 'package:flutter/material.dart';
import 'package:nfc_mobile/admin_app/services/storage.dart';
import 'package:nfc_mobile/admin_app/shared_admin/app_bar.dart';
import 'package:nfc_mobile/mobile_app/shared/constants.dart';
import 'package:nfc_mobile/mobile_app/shared/drawer.dart';

Storage storage = Storage();

class StorageTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Strikeplate'),
      drawer: MakeDrawer(),
      body: Container(
        decoration: BoxDecoration(
          gradient: backgroundGradient,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
                  child: Text('Storage Test',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: mainFG,
                  )),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
                  child: Text(storage.getPublicKey(),
                  style: TextStyle(
                      color: mainFG,
                  )),
                ),
                FloatingActionButton(onPressed: null)
              ],
            )
          ],
        )
      ),
    );
  }
}
