import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purpose_blocs/blocs/user_preferences/user_preferences_barrel.dart';

class SettingsPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: BlocBuilder<UserPreferencesBloc, UserPreferencesState>(
              builder: (context, state) {
                if(state is PreferencesLoaded) {
                  return Column(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.15),
                        child: Center(
                          child: Text('Ajustes',
                            style: TextStyle(fontSize: 32),),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 0),
                        child: ListTile(
                          title: Text('Vibración al poner bloques', style: TextStyle(color: Colors.white),),
                          tileColor: Color.fromARGB(255, 30, 30, 30),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)
                          ),
                          trailing: Switch(
                            value: state.preferences.blockAddVibration,
                            activeColor: Color.fromARGB(255, 200, 50, 50),
                            inactiveThumbColor: Color.fromARGB(255, 50, 50, 50),
                            activeTrackColor: Color.fromARGB(255, 200, 50, 50),
                            inactiveTrackColor: Color.fromARGB(255, 80, 80, 80),
                            onChanged: (val) =>
                                BlocProvider.of<UserPreferencesBloc>(context).add(UpdatePreferences(state.preferences.copyWith(blockAddVibration: val))),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 0),
                        child: ListTile(
                          title: Text('Otro setting...', style: TextStyle(color: Colors.white),),
                          tileColor: Color.fromARGB(255, 30, 30, 30),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: ListTile(
                          title: Text('Otra linea de settings...', style: TextStyle(color: Colors.white),),
                          tileColor: Color.fromARGB(255, 30, 30, 30),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return Center(
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.4),
                      child: CircularProgressIndicator(),
                    )
                  );
                }
              },
            )
          )
        )
      ),
    );
  }
}