import 'package:flutter/material.dart';

class RoomForm extends StatefulWidget {
  @override
  _RoomFormState createState() => _RoomFormState();
}

class _RoomFormState extends State<RoomForm> {

  final List<String> buildings = ['A', 'B', 'C'];

  String building;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Accessible Rooms:'),
            Text('R-104'),
            Text('T-111'),
          ],
        )),
    );
  }
}