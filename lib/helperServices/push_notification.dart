import 'package:chatter_box/screens/chat_screen.dart';
import 'package:chatter_box/screens/chatting.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:meta/meta.dart';
import 'dart:convert';
import '../main.dart';
class Payload {
  final String userName;
  final String name;
  final int counter;
  Payload( {required this.counter,required this.userName, required this.name});

  factory Payload.fromJsonString(String str) => Payload._fromJson(jsonDecode(str));

  String toJsonString() => jsonEncode(_toJson());

  factory Payload._fromJson(Map<String, dynamic> json) => Payload(
    userName: json['title'],
    name: json['description'],
    counter: json["counter"],
  );
  Map<String, dynamic> _toJson() => {
    'title': userName,
    'description': name,
     "counter": counter ,
  };
}


//

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static void initialize(BuildContext context) {
    final InitializationSettings initializationSettings =
    InitializationSettings(
        android: AndroidInitializationSettings("@mipmap/ic_launcher"));

    _notificationsPlugin.initialize(initializationSettings,onSelectNotification: (String? route) async{
        // print('this id is the $route');
      Payload payload = Payload.fromJsonString(route!);
      Navigator.push( context,MaterialPageRoute(builder: (context) => Chatting(payload.userName, payload.name,payload.counter)) );
     print(payload.name);
      print(payload.counter);
      print(payload.userName);


    });
  }


  static void display(RemoteMessage message) async {
 print("got teh message ${message.data["route"]}");
 print(message.notification!.title);
 print(message.notification!.body);
    try {

      RemoteNotification? notification = message.notification;
      Payload newPayload = Payload(userName : message.data["username"], name : message.data["name"], counter: int.parse(message.data["counter"])  );
      String payloadJsonString = newPayload.toJsonString();
      print("this is $payloadJsonString");
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
        payload: payloadJsonString,
      );
    } on Exception catch (e) {
      print(e);
    }
  }
}