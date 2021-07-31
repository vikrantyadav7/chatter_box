import 'package:flutter/material.dart';
class RoundButton extends StatelessWidget {
  RoundButton({required this.colour,required this.onPressed,required this.title});
  final Color colour;
  final String title;
  final onPressed;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        color:colour,
        borderRadius: BorderRadius.circular(30.0),
        elevation: 5.0,
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            title,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

Widget textItem(
    String labelText, TextEditingController controller, bool obscureText ,bool invalid , context, TextInputType type ,) {
  return Container(
    width: MediaQuery.of(context).size.width - 70,
    height: 55,
    child: TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: type,
      style: TextStyle(
        fontSize: 17,
        color: invalid ? Colors.red : Colors.blueGrey,
      ),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          fontSize: 17,
          color: invalid ? Colors.red : Colors.blueGrey,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            width: 1.5,
            color: invalid ? Colors.red : Colors.lightBlueAccent,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            width: 1,
            color: invalid ? Colors.red : Colors.blue,
          ),
        ),
      ),
    ),
  );
}

