import 'dart:async';
import 'package:chatter_box/components/mainContainer.dart';
import 'package:chatter_box/helperServices/auth.dart';
import 'package:chatter_box/helperServices/database.dart';
import 'package:chatter_box/helperServices/gettingThings.dart';
import 'package:chatter_box/screens/welcome_screen.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';




class HomeScreen extends StatefulWidget {
  static const String id = 'Home';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
    GetThings().getMyInfoFromPhone().whenComplete(() {
      setState(() {});
    });
    onScreenLoded();
  }

    Stream? userStream , chatRoomStream ,usersStream ;
  TextEditingController searchUsernameEditingController = TextEditingController();
  bool search = false;


  onSearchButtonClick()async{
    isSearching = true;
    setState(() {

    });

    GetThings().searchUserLists(searchUsernameEditingController);

    setState(() {
     GetThings().getMyInfoFromPhone();
    });
  }
 Future getChatRooms() async{
   print('Get cHAT ROOM HAS BEEN CALLED');
   return
      chatRoomStream  = await DatabaseMethods().getChatRooms();

   }
   onScreenLoded()async{
   getChatRooms();
   print('SCREEEN LOADEED HAS BEEN CALEED ');
   }


  @override
  Widget build(BuildContext context) {
    return Scaffold(


     body:  Container(
      decoration: BoxDecoration(image: DecorationImage(image: AssetImage('images/chart.jpg'),fit: BoxFit.fill)),
      height: screenHeight(context,dividedBy: 1),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Chatterbox',style: TextStyle(color: Colors.white,fontSize:33,fontWeight: FontWeight.w900 ,fontFamily: 'Qahiri'),),
                IconButton(onPressed: (){ AuthMethods().signOut().then((value) {

                             Navigator.pushNamed(context, WelcomeScreen.id);});
                           },
                    icon: Icon(Icons.exit_to_app,color: Colors.white,))
                         ],),
          ),
          search ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                 GestureDetector(
                  onTap: () {
                    isSearching = false;
                    searchUsernameEditingController.text = "";
                    setState(() {});
                    search = false;
                  },
                  child: Padding(
                      padding: EdgeInsets.only(right: 12),
                      child: Icon(Icons.arrow_back,color: Colors.white,)),
                ) ,
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 16),
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.white,
                            width: 1,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(24)),
                    child: Row(
                      children: [
                        Expanded(
                            child: TextField(
                              style: TextStyle(color: Colors.white),
                              textInputAction: TextInputAction.go,
                              onSubmitted: (value){
                                onSearchButtonClick();

                              },
                              controller: searchUsernameEditingController,
                              decoration: InputDecoration(
                                hintStyle: TextStyle(color: Colors.white),
                                  border: InputBorder.none, hintText: "username"),
                            )),
                        GestureDetector( onTap: () {
                          print(searchUsernameEditingController);
                          setState(() {
                            if (searchUsernameEditingController.text != "")
                            {onSearchButtonClick();}
                          });
                        },
                            child: Icon(Icons.search,color: Colors.white,))
                      ],
                    ),
                  ),
                ),
              ],

            ),
          ) : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(height: 40,width: 40,
                  decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(40),
                  color: Colors.white.withOpacity(0.5)
                  ),
                  child: IconButton(onPressed: (){setState(() {
                    search = true;
                  }); }, icon: Icon(Icons.search,color: Colors.white)),
                ),

                SizedBox(width: 250,height: 60,
                    child: GetThings().usersList()),
              ],
            ),
          ),
          isSearching ? MainContainer(height: screenHeight(context,dividedBy: 1.3), child: GetThings().searchUserLists(searchUsernameEditingController)) :

          Flexible(
            child: MainContainer(height:screenHeight(context,dividedBy: 1.3) ,child:  GetThings().chatRoomsLists(),)
          ),




        ],
      ),
    )
    );



  }
}




