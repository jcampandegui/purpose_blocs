import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:purpose_blocs/models/app_tab.dart';
import 'calendar_barrel.dart';

class CalendarBloc extends Bloc<CalendarEvent, DateTime> {

  CalendarBloc() : super(DateTime.now());

  @override
  Stream<DateTime> mapEventToState(CalendarEvent event) async* {
    if (event is UpdateDate) {
      yield event.date;
    }
  }
}