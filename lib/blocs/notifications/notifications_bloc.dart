import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:purpose_blocs/blocs/notifications/notifications_barrel.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {

  NotificationsBloc() : super(InitializingNotifications());

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  AndroidInitializationSettings androidInitializationSettings;
  IOSInitializationSettings iosInitializationSettings;
  InitializationSettings initializationSettings;
  NotificationAppLaunchDetails notificationAppLaunchDetails;

  @override
  Stream<NotificationsState> mapEventToState(NotificationsEvent event) async* {
    if (event is InitializeNotifications) {
      yield* _mapInitializeNotificationsToState();
    } else if(event is ScheduleNotification) {
      yield* _mapScheduleNotificationToState(event);
    } else if(event is ScheduleRepeatingNotification) {
      yield* _mapScheduleRepeatingNotificationToState(event);
    } else if(event is ShowCurrentNotifications) {
      yield* _mapShowCurrentNotificationsToState();
    } else if(event is CancelAllNotifications) {
      yield* _mapCancelAllNotificationsToState();
    }
  }

  Stream<NotificationsState> _mapInitializeNotificationsToState() async* {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    androidInitializationSettings = AndroidInitializationSettings('app_icon');
    iosInitializationSettings = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    initializationSettings = InitializationSettings(
        android: androidInitializationSettings,
        iOS: iosInitializationSettings
    );
    notificationAppLaunchDetails = await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    notificationAppLaunchDetails.didNotificationLaunchApp ? print('app launched by notification') : print('normal launch');
      await flutterLocalNotificationsPlugin.initialize(
          initializationSettings,
          onSelectNotification: onSelectNotification);

    yield NotificationsReady(
        flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin,
        launchedByNotification: notificationAppLaunchDetails.didNotificationLaunchApp
    );
  }

  Stream<NotificationsState> _mapScheduleNotificationToState(ScheduleNotification event) async* {
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

    yield NotificationsReady(
        flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin,
        launchedByNotification: notificationAppLaunchDetails.didNotificationLaunchApp
    );
  }

  Stream<NotificationsState> _mapScheduleRepeatingNotificationToState(ScheduleRepeatingNotification event) async* {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails('repeating channel id', 'repeating channel name', 'repeating description');
    const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.periodicallyShow(0, 'repeating title',
        'repeating body', RepeatInterval.everyMinute, platformChannelSpecifics,
        androidAllowWhileIdle: true);

    yield NotificationsReady(
        flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin,
        launchedByNotification: notificationAppLaunchDetails.didNotificationLaunchApp
    );
  }

  Stream<NotificationsState> _mapShowCurrentNotificationsToState() async* {
    final List<ActiveNotification> activeNotifications =
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.getActiveNotifications();
    print(activeNotifications);

    yield NotificationsReady(
        flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin,
        launchedByNotification: notificationAppLaunchDetails.didNotificationLaunchApp
    );
  }

  Stream<NotificationsState> _mapCancelAllNotificationsToState() async* {
    await flutterLocalNotificationsPlugin.cancelAll();

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