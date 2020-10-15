import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purpose_blocs/blocs/purposes/purposes_barrel.dart';
import 'package:purpose_blocs/models/purpose.dart';
import 'package:purpose_blocs/blocs/purposes/purposes_bloc.dart';

/*class SinglePurpose extends StatefulWidget {
  final Purpose purpose;

  const SinglePurpose({Key key, this.purpose}) : super(key: key);

  @override
  _SinglePurposeState createState() => _SinglePurposeState();
}

class _SinglePurposeState extends State<SinglePurpose> {
  int rowsToDraw, rest;
  ScrollController _sController;
  Purpose purpose;

  @override
  void initState() {
    purpose = widget.purpose;
    rowsToDraw = purpose.streak < 3 ? 1 : purpose.streak ~/ 3;
    rest = purpose.streak < 3 ? 0 : purpose.streak % 3;
    _sController = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Timer(Duration(milliseconds: 500),
            () => _sController.jumpTo(_sController.position.minScrollExtent));
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 40,40, 40),
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Center(
          child: Text(purpose.name),
        ),
      ),
      body: Column(
        children: [
          Container(
            constraints: BoxConstraints.tightFor(height: MediaQuery.of(context).size.height * 0.2),
            margin: EdgeInsets.all(10),
            color: Colors.white70,
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10),
              constraints: BoxConstraints.tightFor(height: MediaQuery.of(context).size.height),
              child: ListView.builder(
                  itemCount: rowsToDraw + (rest > 0 ? 1 : 0),
                  reverse: true,
                  scrollDirection: Axis.vertical,
                  controller: _sController,
                  itemBuilder: (context, index) {
                    double width = MediaQuery.of(context).size.width;
                    List<Widget> blocks = _buildBlocs(rowsToDraw == index ? rest : 3, width); // 3 items per row by default
                    return Row(
                      children: blocks,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                    );
                  }
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.black87,
        onPressed: () {
          BlocProvider.of<PurposesBloc>(context).add(PurposeUpdated(purpose.copyWith(streak: purpose.streak + 1)));
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }

  List<Widget> _buildBlocs(int perRow, double width) {
    print(perRow);
    List<Widget> blocks = [];
    for(int i = 0; i < perRow; i++) {
      blocks.add(
        new Container(
          width: width / 3.5,
          height: width / 2.5 / 2,
          color: Colors.deepOrangeAccent,
          margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        )
      );
    }
    return blocks;
  }
}*/

class SinglePurpose extends StatelessWidget {
  final String purposeId;
  final PurposesBloc purposesBloc;

  const SinglePurpose({Key key, this.purposeId, this.purposesBloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PurposesBloc, PurposesState>(
      cubit: purposesBloc,
        builder: (context, state) {
          if(state is PurposesLoadSuccess) {
            Purpose purpose = state.purposes.singleWhere((element) => element.id == purposeId);
            int rowsToDraw = purpose.streak < 3 ? 1 : purpose.streak ~/ 3;
            int rest = purpose.streak < 3 ? 0 : purpose.streak % 3;
            return  Scaffold(
              backgroundColor: Color.fromARGB(255, 40,40, 40),
              appBar: AppBar(
                backgroundColor: Colors.black87,
                title: Center(
                  child: Text(purpose.name),
                ),
              ),
              body: Column(
                children: [
                  Container(
                    constraints: BoxConstraints.tightFor(height: MediaQuery.of(context).size.height * 0.2),
                    margin: EdgeInsets.all(10),
                    color: Colors.white70,
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      constraints: BoxConstraints.tightFor(height: MediaQuery.of(context).size.height),
                      child: ListView.builder(
                          itemCount: rowsToDraw + (rest > 0 ? 1 : 0),
                          reverse: true,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            double width = MediaQuery.of(context).size.width;
                            List<Widget> blocks = _buildBlocs(rowsToDraw == index ? rest : 3, width); // 3 items per row by default
                            return Row(
                              children: blocks,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                            );
                          }
                      ),
                    ),
                  ),
                ],
              ),
              floatingActionButton: FloatingActionButton(
                child: Icon(Icons.add),
                backgroundColor: Colors.black87,
                onPressed: () {
                  purposesBloc.add(UpdatePurpose(purpose.copyWith(streak: purpose.streak + 1)));
                },
              ),
              floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
            );
          } else {
            return Container();
          }
        }
    );
  }

  List<Widget> _buildBlocs(int perRow, double width) {
    print(perRow);
    List<Widget> blocks = [];
    for(int i = 0; i < perRow; i++) {
      blocks.add(
        new Container(
          width: width / 3.5,
          height: width / 2.5 / 2,
          color: Colors.deepOrangeAccent,
          margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        )
      );
    }
    return blocks;
  }
}