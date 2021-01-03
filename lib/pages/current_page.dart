import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purpose_blocs/blocs/navigation/navigation_barrel.dart';
import 'package:purpose_blocs/models/app_tab.dart';
import 'package:purpose_blocs/pages/blocks_page.dart';
import 'package:purpose_blocs/pages/custom_in_list.dart';
import 'package:purpose_blocs/pages/date_debug.dart';
import 'package:purpose_blocs/pages/settings_page.dart';
import 'package:purpose_blocs/pages/test_page.dart';

class CurrentPage extends StatelessWidget {
  //final AppTab appTab;

  const CurrentPage({
    Key key,
    //this.appTab
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBloc, AppTab>(
        builder: (context, appTab) {
          return _getPageByIndex(appTab);
        });
  }

  Widget _getPageByIndex(AppTab appTab) {
    switch(appTab) {
      case AppTab.Purposes: {
        return BlocksPage();
      }
      break;

      case AppTab.Settings: {
        //return CustomInList(itemsPerRow: 7,blockColor: Color.fromARGB(255, 255, 102, 102));
        return SettingsPage();
      }
      break;

      case AppTab.Dummy2: {
        return TestPage(text: 'Test page index 2');
      }
      break;

      case AppTab.Dummy3: {
        return DateDebug();
      }
      break;

      default: {
        return Scaffold(
          body: Center(
            child: Text('INDEX OUT OF BOUNDS'),
          ),
        );
      }
      break;
    }
  }
}