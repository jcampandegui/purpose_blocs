import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl_standalone.dart';
import 'package:purpose_blocs/blocs/purposes/purposes_barrel.dart';
import 'package:purpose_blocs/models/purpose.dart';
import 'package:intl/intl.dart';

class AllOrNothingCreation extends StatefulWidget {
  final closeContainerCallback;

  AllOrNothingCreation({
    Key key,
    this.closeContainerCallback,
  }) : super(key: key);

  @override
  _AllOrNothingCreationState createState() => _AllOrNothingCreationState();
}

class _AllOrNothingCreationState extends State<AllOrNothingCreation> {
  final _formKey = GlobalKey<FormState>();
  Map<String, bool> _selectedDays;
  DateTime _selectedDate;
  TextEditingController purposeName = TextEditingController();
  int _selectedColor;
  List<Map> colors;

  @override
  void initState() {
    _selectedDays = {
      'L': true,
      'M': true,
      'X': true,
      'J': true,
      'V': true,
      'S': true,
      'D': true,
    };
    _selectedDate = DateTime.now();
    _selectedColor = 0;
    colors = [
      {'color': Color.fromARGB(255, 255, 100, 100), 'id': 0},
      {'color': Color.fromARGB(255, 65, 220, 65), 'id': 1},
      {'color': Color.fromARGB(255, 75, 230, 230), 'id': 2},
      {'color': Color.fromARGB(255, 250, 200, 50), 'id': 3}
    ];
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
                              children: _buildWeekdays(context),
                          ),
                        ),
                        /*Expanded(
                            child: Container()
                        ),*/
                        Container(
                          margin: EdgeInsets.only(top: 30, bottom: 10),
                          child: Text('Fecha de inicio'),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7),
                                color: Color.fromARGB(255, 30, 30, 30)
                            ),
                          child: InkWell(
                            onTap: () => _selectDate(context),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7),
                                  color: Color.fromARGB(255, 30, 30, 30)
                              ),
                              child: Center(
                                child: Text(_formattedDate()),
                              ),
                            )
                          )
                        ),
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
                                  child: Text('Crear',style: TextStyle(color: Colors.white, fontSize: 16),),
                                  onPressed: () {
                                    if (_formKey.currentState.validate()) {
                                      Purpose p = new Purpose(
                                          purposeName.text,
                                          repeatDays: {
                                            '1': _selectedDays['L'],
                                            '2': _selectedDays['M'],
                                            '3': _selectedDays['X'],
                                            '4': _selectedDays['J'],
                                            '5': _selectedDays['V'],
                                            '6': _selectedDays['S'],
                                            '7': _selectedDays['D']
                                          },
                                          creationDate: _selectedDate.millisecondsSinceEpoch,
                                          color: colors[_selectedColor]['color'],
                                          colorDarker: Color.fromARGB(
                                            255,
                                            colors[_selectedColor]['color'].red - 30,
                                            colors[_selectedColor]['color'].green - 30,
                                            colors[_selectedColor]['color'].blue - 30,
                                          )
                                      );
                                      BlocProvider.of<PurposesBloc>(context).add(AddPurpose(p));
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

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020, 1),
      lastDate: DateTime(2050),
      locale: Localizations.localeOf(context),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark().copyWith(
              primary: colors[_selectedColor]['color'],
              surface: colors[_selectedColor]['color'],
            ),
          ),
          child: child,
        );
      }
    );
    if(picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }

  String _formattedDate() {
    return '${_selectedDate.day > 9 ? _selectedDate.day : '0${_selectedDate.day}'}/${_selectedDate.month > 9 ? _selectedDate.month : '0${_selectedDate.month}'}/${_selectedDate.year}';
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
}