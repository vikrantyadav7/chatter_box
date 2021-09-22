// import 'package:chatter_box/main.dart';
import 'package:chatter_box/screens/chatting.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService extends ChangeNotifier {
  BuildContext? context;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  doSomething(context)async{
    print("called");
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return
     Chatting('', '', 0);
    }));
  }
  //initilize

  Future initialize() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

    AndroidInitializationSettings androidInitializationSettings =
    AndroidInitializationSettings('mipmap/ic_launcher');

    IOSInitializationSettings iosInitializationSettings =
    IOSInitializationSettings();

    final InitializationSettings initializationSettings =
    InitializationSettings(
        android: androidInitializationSettings,
        iOS: iosInitializationSettings);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
    onSelectNotification: doSomething(context), );
  }

  //Instant Notifications
  Future
  instantNofitication(String from , message,payload ) async {
    var android = AndroidNotificationDetails("id", "channel", "description");

    var ios = IOSNotificationDetails();

    var platform = new NotificationDetails(android: android, iOS: ios);

    await _flutterLocalNotificationsPlugin.show(
        0, from, message, platform,
        payload: payload);
  }

  //Image notification
  Future imageNotification() async {
    var bigPicture = BigPictureStyleInformation(
        DrawableResourceAndroidBitmap('mipmap/ic_launcher'),
        largeIcon: DrawableResourceAndroidBitmap('mipmap/ic_launcher'),
        contentTitle: "Demo image notification",
        summaryText: "This is some text",
        htmlFormatContent: true,
        htmlFormatContentTitle: true);

    var android = AndroidNotificationDetails("id", "channel", "description",
        styleInformation: bigPicture);

    var platform = new NotificationDetails(android: android);

    await _flutterLocalNotificationsPlugin.show(
        0, "Demo Image notification", "Tap to do something", platform,
        payload: "Welcome to demo app");
  }

  //Stylish Notification
  // Future stylishNotification() async {
  //   var android = AndroidNotificationDetails("id", "channel", "description",
  //       color: Colors.deepOrange,
  //       enableLights: true,
  //       enableVibration: true,
  //       largeIcon: DrawableResourceAndroidBitmap('mipmap/ic_launcher'),
  //       styleInformation: MediaStyleInformation(
  //           htmlFormatContent: true, htmlFormatTitle: true));
  //
  //   var platform = new NotificationDetails(android: android);
  //
  //   await _flutterLocalNotificationsPlugin.show(
  //       0, "Demo Stylish notification", "Tap to do something", platform);
  // }

  //Sheduled Notification

  Future sheduledNotification() async {
    var interval = RepeatInterval.everyMinute;
    var bigPicture = BigPictureStyleInformation(
        DrawableResourceAndroidBitmap('mipmap/ic_launcher'),
        largeIcon: DrawableResourceAndroidBitmap('mipmap/ic_launcher'),
        contentTitle: "Demo image notification",
        summaryText: "This is some text",
        htmlFormatContent: true,
        htmlFormatContentTitle: true);

    var android = AndroidNotificationDetails("id", "channel", "description",
        styleInformation: bigPicture);

    var platform = new NotificationDetails(android: android);

    await _flutterLocalNotificationsPlugin.periodicallyShow(
        0,
        "Demo Sheduled notification",
        "Tap to do something",
        interval,
        platform);
  }

  //Cancel notification

  Future cancelNotification() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }
}



// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project


//
//
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// class LocalNotificationService {
//   static final FlutterLocalNotificationsPlugin _notificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//
//   static void initialize() {
//     final initializationSettings = InitializationSettings(
//       android: AndroidInitializationSettings('@drawable/ic_notification'),
//     );
//
//     _notificationsPlugin.initialize(initializationSettings);
//   }
//
//   static Future<void> displayNotification(RemoteMessage message) async {
//     try {
//       final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
//
//       final notificationDetails = NotificationDetails(
//         android: AndroidNotificationDetails(
//           'high_importance_channel',
//           'High Importance Notifications',
//           'This channel is used for important notifications',
//           importance: Importance.max,
//           priority: Priority.high,
//         ),
//       );
//
//       await _notificationsPlugin.show(
//         id,
//         message.notification!.title,
//         message.notification!.body,
//         notificationDetails,
//       );
//     } on Exception catch (e) {
//       print(e);
//     }
//   }
// }