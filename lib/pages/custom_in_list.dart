import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purpose_blocs/blocs/purposes/purposes_barrel.dart';
import 'package:purpose_blocs/models/purpose.dart';
import 'package:purpose_blocs/widgets/purpose_elements/fusable_block.dart';
import 'package:purpose_blocs/widgets/purpose_elements/fusable_block_controller.dart';

class CustomInList extends StatefulWidget {
  final int itemsPerRow;
  final Color blockColor;
  final PurposesBloc purposesBloc;
  final int id;

  const CustomInList({
    Key key,
    this.itemsPerRow,
    this.blockColor,
    this.purposesBloc,
    this.id
  }) : super(key: key);

  @override
  _CustomInListState createState() => _CustomInListState();
}

class _CustomInListState extends State<CustomInList> {
  int rows;
  int rest;
  double listPadding;

  FusableBlockController fController;
  ScrollController _sController;

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
          if(state is PurposesLoadSuccess) {
            Purpose purpose = state.purposes.singleWhere((element) => element.id == widget.id);
            int streak = purpose.getStreakNumber();
            rows = streak ~/ widget.itemsPerRow;
            rest = streak % widget.itemsPerRow;
            return Scaffold(
              appBar: AppBar(
                title: Text(purpose.name),
                centerTitle: true,
                actions: [
                  IconButton(
                      icon: Icon(Icons.more_vert),
                      onPressed: () => null
                  )
                ],
                backgroundColor: Color.fromARGB(0, 0, 0, 0),
                elevation: 0,
                //backgroundColor: Colors.black54,
              ),
              body:
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Stack(
                  children: [
                    Positioned.fill(
                        bottom: 0,
                        child: Container(
                          constraints: BoxConstraints.tightFor(
                            height: MediaQuery.of(context).size.height * 0.55,
                          ),
                          margin: EdgeInsets.all(listPadding),
                          child: ListView.builder(
                              itemCount: rows + 1, // If no rest, add a new row to add newxt block
                              reverse: true,
                              controller: _sController,
                              itemBuilder: (context, index) {
                                double margin = 5;
                                double blockWidth = (MediaQuery.of(context).size.width - listPadding * 2 - margin * widget.itemsPerRow) / widget.itemsPerRow;
                                double blockHeight = (MediaQuery.of(context).size.width - listPadding * 2 - margin * widget.itemsPerRow) / widget.itemsPerRow;
                                List<Widget> children = _buildRowChildren(purpose, streak, index == rows, blockWidth, blockHeight, margin);
                                return Container(
                                  padding: EdgeInsets.only(top: index == rows ? listPadding * 3 : 0),
                                  child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: children
                                  ),
                                );
                              }),
                        )
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.25,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color.fromARGB(255, 0, 0, 0),
                                  Color.fromARGB(0, 0, 0, 0),
                                ],
                                stops: [0.5, 1]
                            )
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              /*Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                      child: Container(
                        margin: EdgeInsets.all(listPadding),
                        child: ListView.builder(
                            itemCount: rows + 1, // If no rest, add a new row to add newxt block
                            reverse: true,
                            controller: _sController,
                            itemBuilder: (context, index) {
                              double margin = 5;
                              double blockWidth = (MediaQuery.of(context).size.width - listPadding * 2 - margin * widget.itemsPerRow) / widget.itemsPerRow;
                              double blockHeight = (MediaQuery.of(context).size.width - listPadding * 2 - margin * widget.itemsPerRow) / widget.itemsPerRow;
                              List<Widget> children = _buildRowChildren(purpose, streak, index == rows, blockWidth, blockHeight, margin);
                              return Container(
                                padding: EdgeInsets.only(top: index == rows ? listPadding * 3 : 0),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: children
                                ),
                              );
                            }),
                      )
                  )
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          bottom: 0,
                            child: Container(
                              margin: EdgeInsets.all(listPadding),
                              child: ListView.builder(
                                  itemCount: rows + 1, // If no rest, add a new row to add newxt block
                                  reverse: true,
                                  controller: _sController,
                                  itemBuilder: (context, index) {
                                    double margin = 5;
                                    double blockWidth = (MediaQuery.of(context).size.width - listPadding * 2 - margin * widget.itemsPerRow) / widget.itemsPerRow;
                                    double blockHeight = (MediaQuery.of(context).size.width - listPadding * 2 - margin * widget.itemsPerRow) / widget.itemsPerRow;
                                    List<Widget> children = _buildRowChildren(purpose, streak, index == rows, blockWidth, blockHeight, margin);
                                    return Container(
                                      padding: EdgeInsets.only(top: index == rows ? listPadding * 3 : 0),
                                      child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: children
                                      ),
                                    );
                                  }),
                            )
                        ),
                        Positioned(
                          top: 0,
                          left: 0,
                          child: Container(
                            height: 500,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color.fromARGB(255, 0, 0, 0),
                                      Color.fromARGB(0, 0, 0, 0),
                                    ],
                                  stops: [0.5, 1]
                                )
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),*/
              floatingActionButton: FloatingActionButton(
                child: Icon(
                    Icons.add,
                  color: Colors.white,
                ),
                onPressed: () => {
                  _sController.animateTo(
                      _sController.position.maxScrollExtent,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.decelerate
                  ).then((value) => fController.animationTrigger())
                },
                backgroundColor: Color.fromARGB(255, 200, 50, 50),
              ),
              floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            );
        } else {
            return null;
          }
        }
    );
  }

  List<Widget> _buildRowChildren(Purpose purpose, int streak, bool last, double width, double height, double margin) {
    List<Widget> children = [];
    int inLine = last ? rest : widget.itemsPerRow;
    for(int i = 0; i < inLine; i++) {
      children.add(
        Container(
          constraints: BoxConstraints.tightFor(
            width: width,
            height: height,
          ),
          margin: EdgeInsets.only(right: (i == widget.itemsPerRow - 1) ? 0 : margin, bottom: margin),
          color: widget.blockColor,
        )
      );
    }
    if(last) {
      if(fController.resetTrigger != null) fController.resetTrigger();
      children.add(
          new FusableBlock(
            width: width,
            height: height,
            margins: EdgeInsets.only(right: (children.length == widget.itemsPerRow - 1) ? 0 : margin, bottom: margin),
            color: widget.blockColor,
            controller: fController,
            onComplete: () {
              Map<String, bool> updatedStreak = new Map.from(purpose.streak);
              updatedStreak['${DateTime.now().millisecondsSinceEpoch.toString()}'] = true;
              widget.purposesBloc.add(UpdatePurpose(purpose.copyWith(streak: updatedStreak)));
            },
          )
      );
    }
    return children;
  }

  @override
  void dispose() {
    _sController.dispose();
    super.dispose();
  }
}