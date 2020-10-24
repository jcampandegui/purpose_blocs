import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purpose_blocs/blocs/purposes/purposes_barrel.dart';
import 'package:purpose_blocs/models/purpose.dart';

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
  TextEditingController purposeName = TextEditingController();

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(purposeName);
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color.fromARGB(0, 0, 0, 0),
          ),
          body: Container(
              margin: EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        color: Color.fromARGB(100, 200, 50, 50)
                      ),
                      child: TextFormField(
                        controller: purposeName,
                        decoration: InputDecoration(
                          labelText: 'Nombre',
                        ),
                        validator: (value) {
                          if(value.isEmpty) return '¡No dejes el nombre vacío!';
                          return null;
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: Text('Periodo'),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: _buildWeekdays(context)
                      ),
                    ),
                    RaisedButton(
                        child: Text('Crear'),
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
                                }
                            );
                            BlocProvider.of<PurposesBloc>(context).add(AddPurpose(p));
                            widget.closeContainerCallback();
                          }
                        }
                    )
                  ],
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
    for(String label in weekdayLabels) {
      weekdays.add(InkWell(
        borderRadius: BorderRadius.circular(7),
        onTap: () => _selectDay(label),
        child: Container(
          padding: EdgeInsets.only(right: width/10, top: 5, bottom: 5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              color: _selectedDays[label] ? Color.fromARGB(100, 200, 50, 50) : Color.fromARGB(100, 200, 200, 200)
          ),
          child: Text(label),
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
}