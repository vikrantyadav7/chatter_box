import 'package:chatter_box/helperServices/auth.dart';
import 'package:chatter_box/helperServices/profileUpdate.dart';
import 'package:chatter_box/screens/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chatter_box/screens/welcome_screen.dart';
import 'package:chatter_box/screens/registration_screen.dart';
import "package:flutter_local_notifications/flutter_local_notifications.dart";
import 'package:google_fonts/google_fonts.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    "high_importance_channel",  // id
    "High Importance Notifications", // title
    "This channel is used for important notifications" , // description
importance: Importance.high,
  playSound: true
);
FirebaseMessaging messaging = FirebaseMessaging.instance;
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message)async{
  await Firebase.initializeApp();
 print("a bg message just came ${message.messageId}");
}

 void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
   await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
     alert: true,
     badge: true,
     sound: true,
   );
  runApp(Chatterbox());
}

class Chatterbox extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.latoTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future:AuthMethods().getCurrentUser() ,
        builder:(context, AsyncSnapshot<dynamic> snapshot)  {
          if(snapshot.hasData){
          return HomeScreen();}
          else{return WelcomeScreen() ;}
          }

      ),

      routes: {
        WelcomeScreen.id:(context) => WelcomeScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        // LoginScreen.id :(context) => LoginScreen(),
        HomeScreen.id :(context) => HomeScreen(),
        SignUpPage.id : (context) => SignUpPage(),

      },
    );
  }
}

