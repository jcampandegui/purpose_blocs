import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purpose_blocs/blocs/calendar/calendar_barrel.dart';
import 'package:purpose_blocs/blocs/purposes/purposes_barrel.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarWrapper extends StatefulWidget {

  CalendarWrapper({
    Key key,
  }) : super(key: key);

  @override
  _CalendarWrapperState createState() => _CalendarWrapperState();
}

class _CalendarWrapperState extends State<CalendarWrapper> {
  CalendarController _calendarController;

  @override
  void initState() {
    _calendarController = new CalendarController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10, left: 5, right: 5),
      child: BlocBuilder<CalendarBloc, DateTime>(
        builder: (context, date) {
          return TableCalendar(
              locale: 'es_ES',
              calendarController: _calendarController,
              initialCalendarFormat: CalendarFormat.week,
              startingDayOfWeek: StartingDayOfWeek.monday,
              availableCalendarFormats: {CalendarFormat.week: 'Week'},
              daysOfWeekStyle: DaysOfWeekStyle(
                  weekendStyle: TextStyle(
                      color: Color.fromARGB(255, 20, 150, 255)
                  ),
                  weekdayStyle: TextStyle(
                      color: Colors.white
                  )
              ),
              calendarStyle: CalendarStyle(
                  weekdayStyle: TextStyle(
                    color: Colors.white,
                  ),
                  weekendStyle: TextStyle(
                      color: Color.fromARGB(255, 20, 150, 255)
                  ),
                  selectedColor: Color.fromARGB(255, 200, 50, 50)
              ),
              initialSelectedDay: date,
              onDaySelected: (date, map) {
                BlocProvider.of<CalendarBloc>(context).add(UpdateDate(date));
              }
          );
        },
      )
    );
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }
}