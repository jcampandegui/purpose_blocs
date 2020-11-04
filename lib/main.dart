import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:purpose_blocs/blocs/calendar/calendar_barrel.dart';
import 'package:purpose_blocs/blocs/navigation/navigation_barrel.dart';
import 'package:purpose_blocs/blocs/notifications/notifications_barrel.dart';
import 'package:purpose_blocs/blocs/purposes/purposes_barrel.dart';
import 'package:purpose_blocs/blocs/user_preferences/user_preferences_barrel.dart';
import 'package:purpose_blocs/pages/current_page.dart';
import 'package:purpose_blocs/widgets/basic_bottom_nav.dart';

//void main() => runApp(MyApp());
void main() {
    initializeDateFormatting('es_ES', null).then((_) {
      runApp(
          MultiBlocProvider(
            providers: [
              BlocProvider<UserPreferencesBloc>(
                create: (context) => UserPreferencesBloc()
                  ..add(LoadPreferences()),
              ),
              BlocProvider<NotificationsBloc>(
                create: (context) => NotificationsBloc()
                  ..add(InitializeNotifications()),
              ),
              BlocProvider<CalendarBloc>(
                create: (context) => CalendarBloc(),
              ),
              BlocProvider<PurposesBloc>(
                  create: (context) => PurposesBloc(
                      calendarBloc: BlocProvider.of<CalendarBloc>(context)
                  )..add(CheckBrokenPurposes())
              )
            ],
            child: MyApp(),
          )
      );
  });
}

// TODO: Separate displayed page into routes
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Purpose blocs',
      theme: ThemeData(
        brightness: Brightness.dark
      ),
      darkTheme: ThemeData(
        scaffoldBackgroundColor: Color.fromARGB(255, 10, 10, 10),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Color.fromARGB(255, 255, 50, 50),
          selectedItemColor: Color.fromARGB(255, 200, 50, 50),
        ),
        popupMenuTheme: PopupMenuThemeData(
          color: Colors.black87,
          textStyle: TextStyle(
            color: Colors.white
          )
        ),
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        textTheme: TextTheme(
          headline1: TextStyle(
            color: Colors.white
          ),
          headline2: TextStyle(
              color: Colors.white
          ),
          headline3: TextStyle(
              color: Colors.white
          ),
          headline4: TextStyle(
              color: Colors.white
          ),
          bodyText1: TextStyle(
              color: Colors.white
          ),
          bodyText2: TextStyle(
              color: Colors.white
          ),
        )
      ),
      themeMode: ThemeMode.system,
      home: MultiBlocProvider(
        providers: [
          BlocProvider<NavigationBloc>(
            create: (context) => NavigationBloc(),
          ),
        ],
        child: BlocBuilder<UserPreferencesBloc, UserPreferencesState>(
          builder: (context, state) {
            return Scaffold(
              body:  CurrentPage(),
              bottomNavigationBar: BasicBottomNav(),
            );
          },
        )
      ),
    );
  }
}