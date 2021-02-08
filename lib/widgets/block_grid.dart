import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:purpose_blocs/blocs/purposes/purposes_barrel.dart';
import 'package:purpose_blocs/models/purpose.dart';
import 'package:purpose_blocs/pages/custom_in_list.dart';
import 'package:purpose_blocs/widgets/purpose_elements/purpose_widget_all_or_nothing.dart';

class BlockGrid extends StatefulWidget {
  @override
  _BlockGridState createState() => _BlockGridState();
}

class _BlockGridState extends State<BlockGrid> {
  int gridRows = 2;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PurposesBloc, PurposesState>(builder: (context, state) {
      if (state is PurposesLoadSuccess) {
        List<Purpose> purposes = state.purposes;
        return AnimationLimiter(
            child: GridView.count(
              crossAxisCount: gridRows,
              children: List.generate(purposes.length, (index) {
                return AnimationConfiguration.staggeredGrid(
                    position: index,
                    columnCount: gridRows,
                    child: ScaleAnimation(
                      child: FadeInAnimation(
                        child: Container(
                          margin: EdgeInsets.only(top: 10, bottom: 10, left: index % 2 == 0 ? 20 : 10, right: index % 2 == 0 ? 10 : 20),
                          child: OpenContainer(
                              closedBuilder: (_, openContainer) {
                                return InkWell(
                                  child: PurposeWidgetAllOrNothing(purpose: purposes[index],),
                                  onTap: openContainer,
                                );
                              },
                              closedElevation: 0,
                              closedColor: purposes[index].broken ? Color.fromARGB(150, 150, 150, 150) : purposes[index].color,
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
                                      blockColor: purposes[index].color,
                                      purposesBloc: purposesBloc,
                                      id: purposes[index].id,
                                      thePurpose: purposes[index]
                                    )
                                );
                              }),
                        ),
                      ),
                    )
                );
              }),
            )
        );
      } else {
        return Container();
      }
    }
    );
  }
}