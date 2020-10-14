import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purpose_blocs/blocs/purposes/purposes_barrel.dart';
import 'package:purpose_blocs/models/purpose.dart';
import 'package:purpose_blocs/pages/custom_in_list.dart';
import 'package:purpose_blocs/widgets/purpose_elements/single_purpose.dart';

/*class BlocksPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PurposesBloc, PurposesState>(builder: (context, state) {
      print(state);
      if (state is PurposesLoadSuccess) {
        List<Purpose> purposes = state.purposes;
        print('Change in blocBuilder');
        print(purposes);
        return Scaffold(
          //body: SinglePurpose(purpose: purposes[0]),
          body: GridView.count(
            crossAxisCount: 2,
            children: List.generate(purposes.length, (index) {
              return GestureDetector(
                child: Container(
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(20)),
                  child: Text(purposes[index].name),
                ),
                onTap: () {
                  PurposesBloc purposesBloc =
                      BlocProvider.of<PurposesBloc>(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CustomInList(
                          itemsPerRow: 7,
                          blockColor: Color.fromARGB(255, 255, 102, 102),
                          purposesBloc: purposesBloc,
                          id: purposes[index].id,
                        ),
                      ));
                },
              );
            }),
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
}*/

class BlocksPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PurposesBloc, PurposesState>(builder: (context, state) {
      print(state);
      if (state is PurposesLoadSuccess) {
        List<Purpose> purposes = state.purposes;
        print('Change in blocBuilder');
        print(purposes);
        return Scaffold(
          //body: SinglePurpose(purpose: purposes[0]),
          body: GridView.count(
            crossAxisCount: 2,
            children: List.generate(purposes.length, (index) {
              return OpenContainer(
                  closedBuilder: (_, openContainer) {
                    return GestureDetector(
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text('aaa'),
                                Text('bbb')
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text('ccc'),
                                Text('ddd')
                              ],
                            )
                          ],
                        )
                      ),
                      onTap: openContainer,
                    );
                  },
                  closedColor: Color.fromARGB(255, 255, 102, 102),
                  openColor: Color.fromARGB(255, 255, 102, 102),
                  closedElevation: 1,
                  transitionType: ContainerTransitionType.fade,
                  closedShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)
                  ),
                  openBuilder: (_, closeContainer) {
                    PurposesBloc purposesBloc = BlocProvider.of<PurposesBloc>(context);
                    return CustomInList(
                      itemsPerRow: 7,
                      blockColor: Color.fromARGB(255, 255, 102, 102),
                      purposesBloc: purposesBloc,
                      id: purposes[index].id,
                    );
                  });
              /*return GestureDetector(
                child: Container(
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(20)),
                  child: Text(purposes[index].name),
                ),
                onTap: () {
                  PurposesBloc purposesBloc =
                      BlocProvider.of<PurposesBloc>(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CustomInList(
                          itemsPerRow: 7,
                          blockColor: Color.fromARGB(255, 255, 102, 102),
                          purposesBloc: purposesBloc,
                          id: purposes[index].id,
                        ),
                      ));
                },
              );*/
            }),
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
}
