import 'package:flutter/material.dart';
import 'package:purpose_blocs/widgets/purpose_elements/fusable_block.dart';
import 'package:purpose_blocs/widgets/purpose_elements/fusable_block_controller.dart';
import 'package:table_calendar/table_calendar.dart';

class CustomInList extends StatefulWidget {
  final int itemsPerRow;
  final Color blockColor;

  const CustomInList({
    Key key,
    this.itemsPerRow,
    this.blockColor
  }) : super(key: key);

  @override
  _CustomInListState createState() => _CustomInListState();
}

class _CustomInListState extends State<CustomInList> {
  int streak;
  int rows;
  int rest;
  double listPadding;

  FusableBlockController fController;
  ScrollController _sController;
  CalendarController _calendarController;

  @override
  void initState() {
    streak = 97;
    rows = streak ~/ widget.itemsPerRow;
    rest = streak % widget.itemsPerRow;
    listPadding = 15;

    fController = new FusableBlockController();
    _sController = new ScrollController();
    _calendarController = new CalendarController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Block builder'),
        ),
        backgroundColor: Colors.black54,
      ),
      backgroundColor: Colors.black87,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TableCalendar(
            //locale: 'es_ES',
              calendarController: _calendarController,
            initialCalendarFormat: CalendarFormat.week,
            startingDayOfWeek: StartingDayOfWeek.monday,
            availableCalendarFormats: {CalendarFormat.week: 'Week'},
            calendarStyle: CalendarStyle(
              weekdayStyle: TextStyle(
                color: Colors.white
              ),
              weekendStyle: TextStyle(
                color: Colors.blueAccent
              )
            ),
          ),
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
                      List<Widget> children = _buildRowChildren(index == rows, blockWidth, blockHeight, margin);
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
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => {
          _sController.animateTo(
              _sController.position.maxScrollExtent,
              duration: Duration(milliseconds: 300),
              curve: Curves.decelerate
          ).then((value) => fController.animationTrigger())
        },
        backgroundColor: Color.fromARGB(255, 102, 168, 255),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  List<Widget> _buildRowChildren(bool last, double width, double height, double margin) {
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
      children.add(
          new FusableBlock(
            width: width,
            height: height,
            margins: EdgeInsets.only(right: (children.length == widget.itemsPerRow - 1) ? 0 : margin, bottom: margin),
            color: widget.blockColor,
            controller: fController,
            onComplete: () {
              setState(() {
                streak++;
                rows = streak ~/ widget.itemsPerRow;
                rest = streak % widget.itemsPerRow;
              });
            },
          )
      );
    }
    return children;
  }

  @override
  void dispose() {
    _sController.dispose();
    _calendarController.dispose();
    super.dispose();
  }
}