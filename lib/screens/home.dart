import 'dart:async';
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
        appBar: AppBar(
      automaticallyImplyLeading: false,
         title: Text('Chatterbox'),
        actions: [
          IconButton(onPressed: (){ AuthMethods().signOut().then((value) {

            Navigator.pushNamed(context, WelcomeScreen.id);});
          },
              icon: Icon(Icons.exit_to_app))
        ],

    ),

    body:  Container(height: screenHeight(context,dividedBy: 1),
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                     children: [
                  Row(
                     children: [
                      isSearching
                   ? GestureDetector(
                      onTap: () {
                    isSearching = false;
                    searchUsernameEditingController.text = "";
                     setState(() {});
                      },
                       child: Padding(
                           padding: EdgeInsets.only(right: 12),
                         child: Icon(Icons.arrow_back)),
                     )
                            : Container(),
                    Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 16),
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                          border: Border.all(
                          color: Colors.grey,
                          width: 1,
                          style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(24)),
                           child: Row(
                               children: [
                               Expanded(
                                         child: TextField(
                            controller: searchUsernameEditingController,
                            decoration: InputDecoration(
                            border: InputBorder.none, hintText: "username"),
                            )),
                                 GestureDetector(
                                        onTap: () {

                                           print(searchUsernameEditingController);
                                          setState(() {

                                    if (searchUsernameEditingController.text != "")
                                    {onSearchButtonClick();}
                                                                  });


                                  },
                                  child: Icon(Icons.search))
                                  ],
                                  ),
                                  ),
                                  ),
                              ],
                              ),
                             isSearching ? GetThings().searchUserLists(searchUsernameEditingController) : GetThings().chatRoomsLists(),




                 ],
                ),
               )
              );



  }
}




