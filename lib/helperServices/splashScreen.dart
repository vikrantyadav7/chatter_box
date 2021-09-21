import 'dart:async';
import 'package:chatter_box/screens/home.dart';
import 'package:chatter_box/screens/welcome_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
 final bool data;

 SplashScreen({required this.data}) ;
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    print(widget.data);
    Timer(
        Duration(seconds: 3),
            widget.data ?
            () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => HomeScreen()))
       :
                () => Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => WelcomeScreen())
                )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Hero(
          tag: 'logo',
            child: Container(height: 500,width: 300,
                child: Image.asset('images/bg_logo.png'))),
      ),
    );
  }
}