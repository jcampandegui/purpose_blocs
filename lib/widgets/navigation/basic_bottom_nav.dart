import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purpose_blocs/blocs/navigation/navigation_barrel.dart';
import 'package:purpose_blocs/models/app_tab.dart';

class BasicBottomNav extends StatelessWidget {
  //final AppTab appTab;

  const BasicBottomNav({
    Key key,
    //this.appTab
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBloc, AppTab>(builder: (context, appTab) {
      return BottomNavigationBar(
        backgroundColor: Color.fromARGB(255, 20, 20, 20),
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.widgets),
              label: 'Propóstios',
              backgroundColor: Color.fromARGB(255, 30, 30, 30),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Ajustes',
              backgroundColor: Color.fromARGB(255, 30, 30, 30)),
          /*BottomNavigationBarItem(
              icon: Icon(Icons.notifications_active),
              label: 'Nav 3',
              backgroundColor: Color.fromARGB(255, 30, 30, 30)),
          BottomNavigationBarItem(
              icon: Icon(Icons.date_range),
              label: 'Nav 4',
              backgroundColor: Color.fromARGB(255, 30, 30, 30)),*/
        ],
        currentIndex: _appTabToIndex(appTab),
        onTap: (ind) {
          BlocProvider.of<NavigationBloc>(context)
              .add(UpdateNavigation(_indexToAppTab(ind)));
        },
        unselectedItemColor: Colors.white,
      );
    });
  }

  int _appTabToIndex(AppTab appTab) {
    if (appTab == AppTab.Purposes)
      return 0;
    else if (appTab == AppTab.Settings)
      return 1;
    else if (appTab == AppTab.Dummy2)
      return 2;
    else if (appTab == AppTab.Dummy3)
      return 3;
    else
      return -1;
  }

  AppTab _indexToAppTab(int index) {
    if (index == 0)
      return AppTab.Purposes;
    else if (index == 1)
      return AppTab.Settings;
    else if (index == 2)
      return AppTab.Dummy2;
    else if (index == 3)
      return AppTab.Dummy3;
    else
      return null;
  }
}
