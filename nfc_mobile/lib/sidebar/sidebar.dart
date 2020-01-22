import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfc_mobile/bloc/navigation_bloc/navigation_bloc.dart';
import 'package:nfc_mobile/shared/constants.dart';
import 'package:rxdart/rxdart.dart';
import 'package:nfc_mobile/sidebar/menu_item.dart';

class SideBar extends StatefulWidget {

  @override
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> with SingleTickerProviderStateMixin<SideBar>{

  AnimationController _animationController;
  StreamController isOpenStreamController;
  Stream isOpenStream;
  StreamSink isOpenSink;
  final _animationDuration = const Duration(milliseconds: 400);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: _animationDuration);
    isOpenStreamController = PublishSubject();
    isOpenStream = isOpenStreamController.stream;
    isOpenSink = isOpenStreamController.sink;
  }

  @override
  void dispose() {
    _animationController.dispose();
    isOpenStreamController.close();
    isOpenSink.close();
    super.dispose();
  }

  void onIconPressed() {
    final animationStatus = _animationController.status;
    final isAnimationCompleted = animationStatus == AnimationStatus.completed;
    if (isAnimationCompleted) {
      isOpenSink.add(false);
      _animationController.reverse();
    } else {
      isOpenSink.add(true);
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return StreamBuilder(
      initialData: false,
      stream: isOpenStream,
      builder: (context, isOpenAsync) {
        return AnimatedPositioned(
          duration: _animationDuration,
          top: 0,
          bottom: 0,
          left: isOpenAsync.data ? 0 : -screenWidth,
          right: isOpenAsync.data ? 0 : screenWidth - 45,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  color: sideBarColour,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 100, ),
                      ListTile(
                        title: Text(user.username,
                          style: TextStyle(color: mainFG, fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(user.email + '\n' + user.institution,
                          style: TextStyle(color: secondaryFG, fontSize: 15, fontWeight: FontWeight.w300),
                        ),
                        isThreeLine: true,
                        leading: CircleAvatar(
                          backgroundColor: secondaryBG,
                          child: Icon(
                            Icons.perm_identity,
                            color: mainFG,
                          ),
                          radius: 40,
                        ),
                      ),
                      Divider(
                        height: 64.0,
                        thickness: 0.5,
                        color: Colors.white.withOpacity(0.3),
                        indent: 16,
                        endIndent: 16,
                      ),
                      MenuItem(
                        icon: Icons.home,
                        title: 'Home',
                        onTap: () {
                          onIconPressed();
                          BlocProvider.of<NavigationBloc>(context).add(NavigationEvents.HomeClickedEvent);
                        }
                      ),
                      MenuItem(
                        icon: Icons.person,
                        title: 'My Account',
                          onTap: () {
                            onIconPressed();
                            BlocProvider.of<NavigationBloc>(context).add(NavigationEvents.AccountClickedEvent);
                          }
                      ),
                      Divider(
                        height: 64.0,
                        thickness: 0.5,
                        color: Colors.white.withOpacity(0.3),
                        indent: 16,
                        endIndent: 16,
                      ),
                      MenuItem(
                        icon: Icons.settings,
                        title: 'Settings',
                          onTap: () {
                            onIconPressed();
                            BlocProvider.of<NavigationBloc>(context).add(NavigationEvents.SettingsClickedEvent);
                          }
                      ),
                    ],
                  )
                ),
              ),
              Align(
                alignment: Alignment(0, -0.9),
                child: GestureDetector(
                  onTap: () {
                    onIconPressed();
                  },
                  child: ClipPath(
                    clipper: CustomMenuClipper(),
                    child: Container(
                        width: 35,
                        height: 110,
                        color: sideBarColour,
                        alignment: Alignment.centerLeft,
                        child: AnimatedIcon(
                          progress: _animationController.view,
                          icon: AnimatedIcons.menu_close,
                          color: secondaryFG,
                          size: 25,

                        )
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}

class CustomMenuClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Paint paint = Paint();
    paint.color = Colors.transparent;

    final width = size.width;
    final height = size.height;

    Path path = Path();
    path.moveTo(0,0);
    path.quadraticBezierTo(0, 8, 10, 16);
    path.quadraticBezierTo(width-1, height/2-20, width, height/2);
    path.quadraticBezierTo(width+1, height/2+20, 10, height-16);
    path.quadraticBezierTo(0, height-8, 0, height);
    path.close();


    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
