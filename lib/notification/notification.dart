import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class MQTTNotification {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  MQTTNotification() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('ic_notification');
    var initializationSettingsIOS =
        const IOSInitializationSettings();
    var initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: null);
  }

  Future<void> showNotification(String text) async {
    const String id = 'MSM Project';
    const String title = 'MSM Client';
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(id, title,
        channelDescription: id,
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, text, null, platformChannelSpecifics,
        payload: 'item x');
  }
}