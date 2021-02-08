import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purpose_blocs/blocs/purposes/purposes_barrel.dart';
import 'package:purpose_blocs/models/purpose.dart';
import 'package:purpose_blocs/widgets/block_grid.dart';
import 'package:purpose_blocs/widgets/calendar_wrapper.dart';
import 'package:purpose_blocs/widgets/closed_creation_button.dart';

class BlocksPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              CalendarWrapper(),
              Expanded(
                child: BlockGrid()
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color.fromARGB(255, 200, 50, 50),
          child: Icon(Icons.add, color: Colors.white,),
          onPressed: () => _showModalBottomSheet(context),
        ),
      );
  }

  void _showModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Color.fromARGB(255, 20, 20, 20),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                Align(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: 5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color.fromARGB(255, 50, 50, 50),
                    ),
                    margin: EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
                Container(
                    /*decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color.fromARGB(200, 200, 50, 50),
                    ),*/
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: ClosedCreationButton(
                        title: 'Actividad todo o nada',
                        description: 'Actividades que se completan un sóla vez',
                        icon: Icons.calendar_today,
                        openedWidget: 'allOrNothing',
                        autoClose: () => hideBottommSheet(context)
                    )
                ),
                Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color.fromARGB(200, 50, 50, 200),
                    ),
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: InkWell(
                      customBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 20, left: 10),
                            child: Icon(Icons.calendar_today_sharp),
                          ),
                          Expanded(
                              child: Container(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    Text(
                                      'Actividad random',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                        'Para debugear cosas')
                                  ],
                                ),
                              ))
                        ],
                      ),
                      onTap: () {
                        Purpose p = new Purpose(
                            DateTime.now().microsecondsSinceEpoch.toString(),
                            repeatDays: {
                              '1': Random().nextBool(),
                              '2': Random().nextBool(),
                              '3': Random().nextBool(),
                              '4': Random().nextBool(),
                              '5': Random().nextBool(),
                              '6': Random().nextBool(),
                              '7': Random().nextBool()
                            }
                        );
                        BlocProvider.of<PurposesBloc>(context)
                            .add(AddPurpose(p));
                      },
                    )),
                Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color.fromARGB(200, 50, 200, 50),
                    ),
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: InkWell(
                      customBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 20, left: 10),
                            child: Icon(Icons.calendar_today_sharp),
                          ),
                          Expanded(
                              child: Container(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    Text(
                                      'Actividad con bloques llenos',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                        'Para debugear cosas')
                                  ],
                                ),
                              ))
                        ],
                      ),
                      onTap: () {
                        Map<String, bool> m = {};
                        for(int i = 0; i < 30; i++) m['2020-10-$i'] = true;
                        Purpose p = new Purpose(
                            DateTime.now().microsecondsSinceEpoch.toString(),
                            repeatDays: {
                              '1': Random().nextBool(),
                              '2': Random().nextBool(),
                              '3': Random().nextBool(),
                              '4': Random().nextBool(),
                              '5': Random().nextBool(),
                              '6': Random().nextBool(),
                              '7': Random().nextBool()
                            },
                          streak: m
                        );
                        BlocProvider.of<PurposesBloc>(context)
                            .add(AddPurpose(p));
                      },
                    )),
              ],
            ),
          );
        });
  }

  void hideBottommSheet(BuildContext context) {
    Navigator.pop(context);
  }
}
