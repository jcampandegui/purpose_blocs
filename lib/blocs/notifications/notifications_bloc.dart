import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:purpose_blocs/blocs/notifications/notifications_barrel.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {

  NotificationsBloc() : super(InitializingNotifications());

  @override
  Stream<NotificationsState> mapEventToState(NotificationsEvent event) async* {
    if (event is InitializeNotifications) {
      yield* _mapInitializeNotificationsToState();
    }
  }

  Stream<NotificationsState> _mapInitializeNotificationsToState() async* {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    AndroidInitializationSettings androidInitializationSettings = AndroidInitializationSettings('app_icon');
    IOSInitializationSettings iosInitializationSettings = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings
    );
    final NotificationAppLaunchDetails notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    notificationAppLaunchDetails.didNotificationLaunchApp ? print('app launched by notification') : print('normal launch');
    await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onSelectNotification: onSelectNotification);

    yield NotificationsReady(
        flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin,
        launchedByNotification: notificationAppLaunchDetails.didNotificationLaunchApp
    );
  }

  Future<dynamic> onSelectNotification(String payload) {
    if(payload != null) print(payload);
  }

  Future onDidReceiveLocalNotification(int id, String title, String body, String payload) async {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(body),
      actions: [
        CupertinoDialogAction(
            child: Text('Okay'),
          isDefaultAction: true,
          onPressed: () {
              print('On pressed cupertino action');
          },
        )
      ],
    );
  }
}