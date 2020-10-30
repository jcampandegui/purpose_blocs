import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purpose_blocs/blocs/purposes/purposes_barrel.dart';
import 'package:purpose_blocs/models/purpose.dart';
import 'package:purpose_blocs/widgets/all_or_nothing_edit.dart';
import 'package:purpose_blocs/widgets/purpose_elements/breakable_block.dart';
import 'package:purpose_blocs/widgets/purpose_elements/fusable_block.dart';
import 'package:purpose_blocs/widgets/purpose_elements/fusable_block_controller.dart';

enum UpdateType {add, remove}
enum PurposeUpdateState {stop, start, end}

class StateControl {
  PurposeUpdateState state;
  Function method;

  StateControl({PurposeUpdateState state, Function method}) :
        this.state = state ?? PurposeUpdateState.stop,
        this.method = method ?? null;
}

class CustomInList extends StatefulWidget {
  final int itemsPerRow;
  final Color blockColor;
  final PurposesBloc purposesBloc;
  final int id;

  const CustomInList(
      {Key key, this.itemsPerRow, this.blockColor, this.purposesBloc, this.id})
      : super(key: key);

  @override
  _CustomInListState createState() => _CustomInListState();
}

class _CustomInListState extends State<CustomInList> {
  int rows;
  int rest;
  double listPadding;

  FusableBlockController fController;
  List<FusableBlockController> bControllers;
  ScrollController _sController;

  StateControl stateControl = new StateControl();

  @override
  void initState() {
    listPadding = 15;

    fController = new FusableBlockController();
    _sController = new ScrollController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PurposesBloc, PurposesState>(
        cubit: widget.purposesBloc,
        builder: (context, state) {
          if (state is PurposesLoadSuccess) {
            Purpose purpose = state.purposes
                .singleWhere((element) => element.id == widget.id);
            int streak = purpose.getStreakNumber();
            rows = streak ~/ widget.itemsPerRow;
            rest = streak % widget.itemsPerRow;
            if(bControllers == null || bControllers.length != rows * widget.itemsPerRow + rest) bControllers = new List<FusableBlockController>.filled(rows * widget.itemsPerRow + rest, new FusableBlockController(), growable: true);
            return Scaffold(
              appBar: AppBar(
                title: Text(purpose.name),
                centerTitle: true,
                actions: [
                  OpenContainer(
                      closedBuilder: (_, openContainer) {
                        return IconButton(
                            icon: Icon(Icons.more_vert), onPressed: openContainer);
                      },
                      closedColor: Color.fromARGB(0, 0, 0, 0),
                      openBuilder: (_, closeContainer) {
                        return AllOrNothingEdit(
                          closeContainerCallback: closeContainer,
                          purposesBloc: widget.purposesBloc,
                          purpose: purpose,
                        );
                      }
                  )
                ],
                backgroundColor: Color.fromARGB(0, 0, 0, 0),
                elevation: 0,
                //backgroundColor: Colors.black54,
              ),
              body: Container(
                margin: EdgeInsets.all(listPadding),
                child: ListView.builder(
                    itemCount: rows +
                        1, // If no rest, add a new row to add newxt block
                    reverse: true,
                    controller: _sController,
                    itemBuilder: (context, index) {
                      double margin = 5;
                      double blockWidth = (MediaQuery.of(context).size.width -
                              listPadding * 2 -
                              margin * widget.itemsPerRow) /
                          widget.itemsPerRow;
                      double blockHeight = (MediaQuery.of(context).size.width -
                              listPadding * 2 -
                              margin * widget.itemsPerRow) /
                          widget.itemsPerRow;
                      List<Widget> children = _buildRowChildren(purpose, streak,
                          index == rows, blockWidth, blockHeight, margin);
                      return Container(
                        padding: EdgeInsets.only(
                            top: index == rows ? listPadding * 3 : 0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: children),
                      );
                    }),
              ),
              floatingActionButton: FloatingActionButton(
                child: purpose.isCompletedForDate(DateTime.now())
                    ? Icon(
                        Icons.done,
                        color: Colors.white,
                      )
                    : Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                onPressed: () => {
                          _sController
                              .animateTo(_sController.position.maxScrollExtent,
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.decelerate)
                              .then((value) => {
                                stateControl.state = PurposeUpdateState.start,
                                if(purpose.isCompletedForDate(DateTime.now())) {
                                  bControllers[bControllers.length-1].animationTrigger(),
                                  stateControl.method = () => widget.purposesBloc.add(UpdatePurpose(purpose.removeStreak(DateTime.now()))),
                                }
                                else {
                                  fController.animationTrigger(),
                                  stateControl.method = () => widget.purposesBloc.add(UpdatePurpose(purpose.addStreak(DateTime.now()))),
                                }
                              })
                        },
                backgroundColor: Color.fromARGB(255, 200, 50, 50),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
            );
          } else {
            return null;
          }
        });
  }

  List<Widget> _buildRowChildren(Purpose purpose, int streak, bool last,
      double width, double height, double margin) {
    List<Widget> children = [];
    int inLine = last ? rest : widget.itemsPerRow;
    for (int i = 0; i < inLine; i++) {
      BreakableBlock bb = BreakableBlock(
          width: width,
          height: height,
          margins: EdgeInsets.only(
              right: (children.length == widget.itemsPerRow - 1) ? 0 : margin,
              bottom: margin),
          color: widget.blockColor,
          controller: bControllers[i],
          onComplete: () => securePurposeUpdate(UpdateType.remove, purpose)//widget.purposesBloc.add(UpdatePurpose(purpose.removeStreak(DateTime.now())))
      );
      children.add(bb);
    }
    if (last) {
      if (fController.resetTrigger != null) fController.resetTrigger();
      children.add(new FusableBlock(
        width: width,
        height: height,
        margins: EdgeInsets.only(
            right: (children.length == widget.itemsPerRow - 1) ? 0 : margin,
            bottom: margin),
        color: widget.blockColor,
        controller: fController,
        onComplete: () => securePurposeUpdate(UpdateType.add, purpose)//widget.purposesBloc.add(UpdatePurpose(purpose.addStreak(DateTime.now())))
      ));
    }
    return children;
  }

  void securePurposeUpdate(UpdateType type, Purpose purpose) {
    if(type == UpdateType.add) {
      widget.purposesBloc.add(UpdatePurpose(purpose.addStreak(DateTime.now())));
    } else if(type == UpdateType.remove) {
      widget.purposesBloc.add(UpdatePurpose(purpose.removeStreak(DateTime.now())));
    }
    stateControl.state = PurposeUpdateState.end;
  }

  @override
  void dispose() {
    if(stateControl.state == PurposeUpdateState.start) stateControl.method();
    _sController.dispose();
    super.dispose();
  }
}
