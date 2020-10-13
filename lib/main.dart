import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purpose_blocs/blocs/navigation/navigation_barrel.dart';
import 'package:purpose_blocs/blocs/purposes/purposes_barrel.dart';
import 'package:purpose_blocs/pages/current_page.dart';
import 'package:purpose_blocs/widgets/basic_bottom_nav.dart';

//void main() => runApp(MyApp());
void main() {
  runApp(
    BlocProvider(
        create: (context) {
          return PurposesBloc()..add(PurposesLoad());
        },
      child: MyApp(),
        )
  );
}

// TODO: Separate displayed page into routes
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Purpose blocs',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Colors.black87,
            selectedItemColor: Colors.deepOrangeAccent,
            unselectedItemColor: Colors.white70
        ),
        bottomAppBarColor: Colors.black45
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider<NavigationBloc>(
            create: (context) => NavigationBloc(),
          ),
        ],
        child: Scaffold(
          body:  CurrentPage(),
          bottomNavigationBar: BasicBottomNav(),
        ),
      ),
    );
  }
}