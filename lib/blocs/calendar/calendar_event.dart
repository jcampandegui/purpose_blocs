import 'package:equatable/equatable.dart';

abstract class CalendarEvent extends Equatable {
  const CalendarEvent();

  @override
  List<Object> get props => [];
}

class UpdateDate extends CalendarEvent {
  final DateTime date;

  const UpdateDate(this.date);

  @override
  List<Object> get props => [date];

  @override
  String toString() => 'UpdateDate { date: $date }';
}