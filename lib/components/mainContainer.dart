import 'package:flutter/material.dart';
class MainContainer extends StatelessWidget {
  MainContainer({required this.height ,required this.child});
 final Widget? child;
 final double? height ;
  @override
  Widget build(BuildContext context) {
    return Container(child:child ,
      padding: EdgeInsets.symmetric(horizontal: 20),
      height: height,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topRight: Radius.circular(30),topLeft: Radius.circular(30),)
      ),
    );
  }
}
