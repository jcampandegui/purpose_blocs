import 'package:equatable/equatable.dart';
import 'package:purpose_blocs/models/purpose.dart';

abstract class NotificationsEvent extends Equatable {
  const NotificationsEvent();

  @override
  List<Object> get props => [];
}

class InitializeNotifications extends NotificationsEvent {}

class ScheduleNotification extends NotificationsEvent {
  final DateTime when;
  final Purpose purpose;

  const ScheduleNotification({
    this.when,
    this.purpose
  });

  @override
  List<Object> get props => [when, purpose];

  @override
  String toString() => 'ScheduleNotification { when: $when, purpose: $purpose }';
}