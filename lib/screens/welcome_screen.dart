import 'package:chatter_box/helperServices/auth.dart';
// import 'package:chatter_box/helperServices/profileUpdate.dart';
import 'package:chatter_box/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:chatter_box/components/rounded_button.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'Welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/bg.jpeg'),
                    height: 60.0,
                  ),
                ),
                SizedBox(width: 10,),
                Text(
                  'Chatter Box',
                  style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20.0,
            ),

            RoundButton(title: 'Login with phoneNumber',colour: Colors.lightBlueAccent,
                onPressed:(){
                  Navigator.of(context).pop();
             Navigator.pushNamed(context, RegistrationScreen.id);}
            ),
            RoundButton(title: 'SignIn with google',colour: Colors.blue,
                onPressed:(){
                  AuthMethods().signInWithGoogle(context);}
            ),
            // RoundButton(title: 'Sign in with '
            //     'Google',colour: Colors.lightBlueAccent,onPressed:AuthMethods().signInWithGoogle(context) ,)
          ],
        ),
      ),
    );
  }
}

