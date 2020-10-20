import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purpose_blocs/blocs/purposes/purposes_barrel.dart';
import 'package:purpose_blocs/models/purpose.dart';
import 'package:purpose_blocs/pages/custom_in_list.dart';
import 'package:purpose_blocs/widgets/calendar_wrapper.dart';
import 'package:purpose_blocs/widgets/purpose_elements/purpose_widget_all_or_nothing.dart';
import 'dart:math';

class BlocksPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PurposesBloc, PurposesState>(builder: (context, state) {
      if (state is PurposesLoadSuccess) {
        List<Purpose> purposes = state.purposes;
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                CalendarWrapper(),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    children: List.generate(purposes.length, (index) {
                      return Container(
                        margin: EdgeInsets.only(top: 10, bottom: 10, left: index % 2 == 0 ? 20 : 10, right: index % 2 == 0 ? 10 : 20),
                        child: OpenContainer(
                            closedBuilder: (_, openContainer) {
                              return InkWell(
                                child: PurposeWidgetAllOrNothing(purpose: purposes[index],),
                                onTap: openContainer,
                              );
                            },
                            closedElevation: 0,
                            closedColor: Color.fromARGB(150, 200, 50, 50),
                            closedShape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)
                            ),
                            transitionDuration: Duration(milliseconds: 400),
                            openBuilder: (context, closeContainer) {
                              PurposesBloc purposesBloc =
                              BlocProvider.of<PurposesBloc>(context);
                              return Container(
                                  color: Colors.blueAccent,
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height,
                                  child: CustomInList(
                                    itemsPerRow: 7,
                                    blockColor: Color.fromARGB(255, 255, 102, 102),
                                    purposesBloc: purposesBloc,
                                    id: purposes[index].id,
                                  )
                              );
                            }),
                      );
                    }),
                  ),
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
      } else if (state is PurposesLoadFailure) {
        return Scaffold(
          body: Center(
            child: Text('Error al cargar propósitos'),
          ),
        );
      } else {
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 200, 50, 50)),),
          ),
        );
      }
    });
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
                Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color.fromARGB(200, 200, 50, 50),
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
                                  'Actividad todo o nada',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                    'Actividades que sólo pueden estar completadas o no')
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
                      color: Color.fromARGB(200, 80, 80, 200),
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
                                      'Tipo 2',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                        'Descripcion tipo 2')
                                  ],
                                ),
                              ))
                        ],
                      ),
                      onTap: () {
                        Purpose p = new Purpose(
                            DateTime.now().microsecondsSinceEpoch.toString());
                        BlocProvider.of<PurposesBloc>(context)
                            .add(AddPurpose(p));
                      },
                    )),
              ],
            ),
          );
        });
  }
}
