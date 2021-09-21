import 'package:chatter_box/screens/chat_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../main.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static void initialize(BuildContext context) {
    final InitializationSettings initializationSettings =
    InitializationSettings(
        android: AndroidInitializationSettings("@mipmap/ic_launcher"));

    _notificationsPlugin.initialize(initializationSettings,onSelectNotification: (String? route) async{
        // print('this id is the $route');
        Navigator.pushNamed(context, MyHomePage.id);

    });
  }

  static void display(RemoteMessage message) async {
 print("got teh message ${message.data["route"]}");
 print(message.notification!.title);
 print(message.notification!.body);
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/1000;
      RemoteNotification? notification = message.notification;

      flutterLocalNotificationsPlugin.show(
          notification.hashCode, notification!.title, notification.body,
          NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                color: Colors.blue,
                playSound: true,
                icon: "@mipmap/ic_launcher",
              )
          ),
        payload: message.data["route"],
      );
    } on Exception catch (e) {
      print(e);
    }
  }
}