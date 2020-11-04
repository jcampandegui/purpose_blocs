import 'package:equatable/equatable.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

abstract class NotificationsState extends Equatable {
  const NotificationsState();

  @override
  List<Object> get props => [];
}

class InitializingNotifications extends NotificationsState {}

class NotificationsReady extends NotificationsState {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final bool launchedByNotification;

  const NotificationsReady({
    this.flutterLocalNotificationsPlugin,
    this.launchedByNotification
  });

  @override
  List<Object> get props => [flutterLocalNotificationsPlugin];

  @override
  String toString() => 'NotificationsReady { plugin: $flutterLocalNotificationsPlugin }';
}