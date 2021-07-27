
import 'package:chatter_box/components/rounded_button.dart';

import 'package:chatter_box/helperServices/auth.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:flutter/widgets.dart';



class RegistrationScreen extends StatefulWidget {
  static const String id = 'Registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final auth = FirebaseAuth.instance;
  String? phoneNumber;

  TextEditingController _pwdController = TextEditingController();
  TextEditingController _numberController = TextEditingController();
  bool numberError = false;

  bool codeSent = false;


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      body:  Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Hero(
              tag: 'logo',
              child: Container(
                height: 200.0,
                child: Image.asset('images/bg_logo.png'),
              ),
            ),
            SizedBox(
              height: 48.0,
            ),

            textItem(numberError ? "Invalid number" : "Phone Number",
                _numberController, false, numberError,context,TextInputType.numberWithOptions()),
            SizedBox(
              height: 18.0,
            ),
            SizedBox(
              height: 24.0,
            ),
            RoundButton(title: 'Get OTP ',
                colour: Colors.blueAccent,
                onPressed:
                () async {
                  print(_pwdController.text);
                  print("+91" + _numberController.text);
                  if (_numberController.text != "" &&
                      _numberController.text.length == 10) {
                    setState(() {
                      numberError = false;
                      codeSent = true;
                    });

                   await AuthMethods().signInWithNumber(
                        "+91" + _numberController.text, context);

                  }
                  else {
                    setState(() {
                      numberError = true;
                    });
                  }

                    },
                    )

          ],
        ),
      ),
    );
  }



}