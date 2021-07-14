import 'package:chatter_box/helperServices/auth.dart';
import 'package:chatter_box/screens/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chatter_box/screens/welcome_screen.dart';
import 'package:chatter_box/screens/login_screen.dart';
import 'package:chatter_box/screens/registration_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Chatterbox());
}

class Chatterbox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
        LoginScreen.id :(context) => LoginScreen(),
        HomeScreen.id :(context) => HomeScreen(),

      },
    );
  }
}

