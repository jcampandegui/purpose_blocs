import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:purpose_blocs/blocs/purposes/purposes_barrel.dart';
import 'package:purpose_blocs/models/purpose.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class AllOrNothingEdit extends StatefulWidget {
  final closeContainerCallback;
  final PurposesBloc purposesBloc;
  final Purpose purpose;

  AllOrNothingEdit({
    Key key,
    this.closeContainerCallback,
    this.purposesBloc,
    this.purpose
  }) : super(key: key);

  @override
  _AllOrNothingEditState createState() => _AllOrNothingEditState();
}

class _AllOrNothingEditState extends State<AllOrNothingEdit> {
  final _formKey = GlobalKey<FormState>();
  Map<String, bool> _selectedDays;
  TextEditingController purposeName = TextEditingController();
  int _selectedColor;
  List<Map> colors;

  @override
  void initState() {
    _selectedDays = {
      'L': widget.purpose.repeatDays['1'],
      'M': widget.purpose.repeatDays['2'],
      'X': widget.purpose.repeatDays['3'],
      'J': widget.purpose.repeatDays['4'],
      'V': widget.purpose.repeatDays['5'],
      'S': widget.purpose.repeatDays['6'],
      'D': widget.purpose.repeatDays['7'],
    };
    purposeName.text = widget.purpose.name;
    _selectedColor = _detectColor(widget.purpose.color.red);
    colors = [
      {'color': Color.fromARGB(255, 255, 100, 100), 'id': 0},
      {'color': Color.fromARGB(255, 65, 220, 65), 'id': 1},
      {'color': Color.fromARGB(255, 75, 230, 230), 'id': 2},
      {'color': Color.fromARGB(255, 250, 200, 50), 'id': 3}
    ];

    //tz.initializeTimeZones();
    //tz.setLocalLocation(tz.getLocation('Europe/Spain'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
            backgroundColor: Color.fromARGB(0, 0, 0, 0),
            elevation: 0,
          ),
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Container(
                margin: EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 20, bottom: 10),
                          child: Text('Nombre'),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              color: Color.fromARGB(255, 30, 30, 30)
                          ),
                          child: TextFormField(
                            cursorColor: Colors.white,
                            controller: purposeName,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                border: InputBorder.none
                            ),
                            validator: (value) {
                              if(value.isEmpty) return '¡No dejes el nombre vacío!';
                              return null;
                            },
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 30, bottom: 10),
                          child: Text('Periodo'),
                        ),
                        Container(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: _buildWeekdays(context)
                          ),
                        ),
                        /*Container(
                          margin: EdgeInsets.only(top: 30, bottom: 10),
                          child: Text('Recordatorio'),
                        ),
                        Container(
                          child: TimePickerSpinner(
                            is24HourMode: true,
                            normalTextStyle: TextStyle(
                              color: Color.fromARGB(100, 255, 255, 255),
                              fontWeight: FontWeight.bold
                            ),
                            highlightedTextStyle: TextStyle(
                              color: Colors.white
                            ),
                            isForce2Digits: true,
                            onTimeChange: (time) {
                              print(time);
                            },
                          )
                        ),*/
                        Container(
                          margin: EdgeInsets.only(top: 30),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: _colorPicker(context)
                          ),
                        ),
                        Align(
                            alignment: Alignment.center,
                            child: Container(
                              margin: EdgeInsets.only(top: 20),
                              child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 100,
                                  ),
                                  color: colors[_selectedColor]['color'],
                                  child: Text('Guardar',style: TextStyle(color: Colors.white, fontSize: 16),),
                                  onPressed: () {
                                    if (_formKey.currentState.validate()) {
                                      BlocProvider.of<PurposesBloc>(context).add(UpdatePurpose(
                                          widget.purpose.copyWith(
                                              name: purposeName.text,
                                              repeatDays: {
                                                '1': _selectedDays['L'],
                                                '2': _selectedDays['M'],
                                                '3': _selectedDays['X'],
                                                '4': _selectedDays['J'],
                                                '5': _selectedDays['V'],
                                                '6': _selectedDays['S'],
                                                '7': _selectedDays['D']
                                              },
                                              color: colors[_selectedColor]['color'],
                                              colorDarker: Color.fromARGB(
                                                255,
                                                colors[_selectedColor]['color'].red - 30,
                                                colors[_selectedColor]['color'].green - 30,
                                                colors[_selectedColor]['color'].blue - 30,
                                              )
                                          )
                                      ));
                                      widget.closeContainerCallback();
                                    }
                                  }
                              ),
                            )
                        )
                      ],
                    ),
                  ),
                )
            ),
          )
    );
  }

  List<Widget> _buildWeekdays(BuildContext context) {
    List<Widget> weekdays = [];
    List<String> weekdayLabels = ['L', 'M', 'X', 'J', 'V', 'S', 'D'];
    double width = MediaQuery.of(context).size.width;
    double padding = 15;
    double toSeparate = width - padding*2*7;

    for(String label in weekdayLabels) {
      weekdays.add(InkWell(
        borderRadius: BorderRadius.circular(7),
        onTap: () => _selectDay(label),
        child: Container(
          padding: EdgeInsets.all(padding),
          margin: EdgeInsets.only(
              left: label == 'L' ? 0 : (toSeparate / 6 / 7),
              right: label == 'D' ? 0 : (toSeparate / 6 / 7)
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              color: _selectedDays[label] ? colors[_selectedColor]['color'] : Color.fromARGB(255, 30, 30, 30)
          ),
          child: Align(
            alignment: Alignment.center,
            child: Text(label),
          )
        ),
      ));
    }
    return weekdays;
  }

  void _selectDay(String day) {
    setState(() {
      _selectedDays[day] = !_selectedDays[day];
    });
  }

  List<Widget> _colorPicker(BuildContext context) {
    List<Widget> colorRow = [];
    for(var c in colors) {
      colorRow.add(
          InkWell(
            onTap: () {
              setState(() {
                _selectedColor = c['id'];
              });
            },
            customBorder: CircleBorder(),
            child: Container(
              constraints: BoxConstraints.tightFor(
                  width: 40,
                  height: 40
              ),
              decoration: BoxDecoration(
                  color: c['color'],
                  border: Border.all(
                    color: _selectedColor == c['id'] ? Colors.white : c['color'],
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(20))
              ),
            ),
          )
      );
    }
    return colorRow;
  }

  int _detectColor(int red) {
    if(red == 255) return 0;
    if(red == 65) return 1;
    if(red == 75) return 2;
    if(red == 250) return 3;
  }
}