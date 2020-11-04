import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:purpose_blocs/blocs/notifications/notifications_barrel.dart';

class TestPage extends StatelessWidget {
  final String text;

  const TestPage({
    Key key,
    this.text
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsBloc, NotificationsState>(
        builder: (context, state) {
          if(state is NotificationsReady) {
            return Scaffold(
              body: Center(
                child: Text(state.launchedByNotification ? 'Launched by notification' : 'Normal launch'),
              ),
              floatingActionButton: FloatingActionButton(
                  child: Icon(Icons.add),
                  onPressed: () => _showNotifications(state.flutterLocalNotificationsPlugin)
              ),
            );
          } else if(state is InitializingNotifications) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            return Scaffold(
              body: Center(
                child: Text('Error'),
              )
            );
          }
        }
    );
  }

  void _showNotifications(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    await notification(flutterLocalNotificationsPlugin);
  }

  Future<void> notification(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
        'Channel ID', 'Channel title', 'Channel body',
        priority: Priority.high,
        importance: Importance.max,
        ticker: 'test'
    );

    IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();

    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: iosNotificationDetails
    );

    await flutterLocalNotificationsPlugin.show(
        0,
        'Esto es el titulo',
        'Esto es el cuerpo',
        notificationDetails,
      payload: 'This is the payload'
    );
  }

}