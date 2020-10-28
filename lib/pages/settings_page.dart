import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
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
                      value: true,
                      activeColor: Color.fromARGB(255, 200, 50, 50),
                      inactiveThumbColor: Color.fromARGB(255, 200, 50, 50),
                      activeTrackColor: Color.fromARGB(255, 200, 50, 50),
                      inactiveTrackColor: Color.fromARGB(255, 80, 80, 80),
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
            ),
          )
        )
      ),
    );
  }
}