import 'package:bloc/bloc.dart';
import 'package:nfc_mobile/screens/admin/admin_adduser.dart';
import 'package:nfc_mobile/screens/home/home.dart';
import 'package:nfc_mobile/screens/settings/settings.dart';

enum NavigationEvents {
  HomeClickedEvent,
  AccountClickedEvent,
  SettingsClickedEvent
}

abstract class NavigationStates{}

class NavigationBloc extends Bloc<NavigationEvents, NavigationStates> {

  @override
  NavigationStates get initialState => Home();

  @override
  Stream<NavigationStates> mapEventToState(NavigationEvents event) async* {
    switch (event) {
      case NavigationEvents.HomeClickedEvent:
        yield Home();
        break;
      case NavigationEvents.AccountClickedEvent:
        yield AdminAddUser();
        break;
      case NavigationEvents.SettingsClickedEvent:
        yield Settings();
        break;
    }
  }
}