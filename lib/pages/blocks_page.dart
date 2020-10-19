import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purpose_blocs/blocs/purposes/purposes_barrel.dart';
import 'package:purpose_blocs/models/purpose.dart';
import 'package:purpose_blocs/pages/custom_in_list.dart';

class BlocksPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PurposesBloc, PurposesState>(builder: (context, state) {
      if (state is PurposesLoadSuccess) {
        List<Purpose> purposes = state.purposes;
        return Scaffold(
          body: GridView.count(
            crossAxisCount: 2,
            children: List.generate(purposes.length, (index) {
              return Container(
                margin: EdgeInsets.all(10),
                child: OpenContainer(
                    closedBuilder: (_, openContainer) {
                      return InkWell(
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('cositas'),
                              Text('cositas'),
                              Text('cositas'),
                              Text('cositas'),
                            ],
                          ),
                        ),
                        onTap: openContainer,
                      );
                    },
                    //closedColor: Color.fromARGB(255, 255, 102, 102),
                    //openColor: Color.fromARGB(255, 255, 102, 102),
                    //closedElevation: 1,
                    //transitionType: ContainerTransitionType.fade,
                    transitionDuration: Duration(milliseconds: 600),
                    /*closedShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),*/
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
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
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
            child: CircularProgressIndicator(),
          ),
        );
      }
    });
  }

  void _showModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
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
                        border: Border.all(color: Colors.deepOrangeAccent)),
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: GestureDetector(
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
                            DateTime.now().microsecondsSinceEpoch.toString());
                        BlocProvider.of<PurposesBloc>(context)
                            .add(AddPurpose(p));
                      },
                    )),
                new ListTile(
                  leading: new Icon(Icons.timer),
                  title: new Text('Actividad cronometrada'),
                  onTap: () => {},
                ),
              ],
            ),
          );
        });
  }
}
