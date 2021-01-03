import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:purpose_blocs/blocs/notifications/notifications_barrel.dart';
import 'package:purpose_blocs/blocs/purposes/purposes_barrel.dart';

class DateDebug extends StatefulWidget {
  @override
  _DateDebugState createState() => _DateDebugState();
}

class _DateDebugState extends State<DateDebug> {
  DateTime _selectedDate;

  @override
  void initState() {
    _selectedDate = new DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: RaisedButton(
              onPressed: () => _selectDate(context),
            child: Text(_selectedDate.toString()),
          )
      ),
      floatingActionButton: FloatingActionButton(
          child: Text('Check broken'),
          onPressed: () => BlocProvider.of<PurposesBloc>(context).add(CheckBrokenPurposes(debugDate: _selectedDate))
      ),
    );
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(2020, 1),
        lastDate: DateTime(2050));
    if(picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }

}