import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:purpose_blocs/models/app_tab.dart';
import 'navigation_barrel.dart';

class NavigationBloc extends Bloc<NavigationEvent, AppTab> {

  NavigationBloc() : super(AppTab.Purposes);

  @override
  Stream<AppTab> mapEventToState(NavigationEvent event) async* {
    if (event is UpdateNavigation) {
      yield event.appTab;
    }
  }
}