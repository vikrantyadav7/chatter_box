import 'dart:async';
import 'dart:io';
import 'package:chatter_box/components/mainContainer.dart';
import 'package:chatter_box/helperServices/auth.dart';
import 'package:chatter_box/helperServices/database.dart';
import 'package:chatter_box/helperServices/gettingThings.dart';
import 'package:chatter_box/helperServices/push_notification.dart';
import 'package:chatter_box/screens/chat_screen.dart';
import 'package:chatter_box/screens/chatting.dart';
import 'package:chatter_box/screens/profileUpdate.dart';
import 'package:chatter_box/main.dart';
import 'package:chatter_box/screens/welcome_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:connectivity_plus/connectivity_plus.dart';



class HomeScreen extends StatefulWidget {
  static const String id = 'Home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>with SingleTickerProviderStateMixin {
 bool isInternet = false;
 Future<bool> connectivityChecker() async {
   var connected = false;
   print("Checking internet...");
   try {
     final result = await InternetAddress.lookup('google.com');
     final result2 = await InternetAddress.lookup('facebook.com');
     final result3 = await InternetAddress.lookup('microsoft.com');
     if ((result.isNotEmpty && result[0].rawAddress.isNotEmpty) ||
         (result2.isNotEmpty && result2[0].rawAddress.isNotEmpty) ||
         (result3.isNotEmpty && result3[0].rawAddress.isNotEmpty)) {
       print('connected..');
       connected = true;
          setState(() {
            isInternet = true;
      });


     } else {
       print("not connected from else..");
       connected = false;

       setState(() {
         isInternet = false;
       });

     }
   } on SocketException catch (_) {
     print('not connected...');
     connected = false;

     setState(() {
       isInternet = false;
     });

   }
   return connected;
 }



  @override
  void initState() {
    super.initState();
    LocalNotificationService.initialize(context);
    connectivityChecker();
    var subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      // Got a new connectivity status!
      connectivityChecker();
    });
// Be sure to cancel subscription after you are done
  @override
  dispose() {
    super.dispose();
    subscription.cancel();
  }



    FirebaseMessaging.onMessage.listen((RemoteMessage message) {

      LocalNotificationService.display(message);
    }
    );


    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('a new on message event was published ');
      print(message.data["username"]);
      print(message.data["name"]);
      print(message.data["counter"]);
      Navigator.push( context,MaterialPageRoute(builder: (context) => Chatting(message.data["username"], message.data["name"], int.parse(message.data["counter"]))) );



    });

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
   return
      chatRoomStream  = await DatabaseMethods().getChatRooms();

   }
   onScreenLoded()async{
   getChatRooms();
   }

   void choiceAction(String choice ){
    if(choice == "Logout"){
      setState(() {
        AuthMethods().signOut().then((value) {
          Navigator.pop(context);
          Navigator.pushNamed(context, WelcomeScreen.id);});
      });
    }
    else {
      Navigator.pushNamed(context, SignUpPage.id);
    }
   }



@override
  Widget build(BuildContext context) {
  return Scaffold(


     body:  Container(
      decoration:   BoxDecoration(image: DecorationImage(image: AssetImage('images/chart.jpg'),fit: BoxFit.fill)),
      height: screenHeight(context,dividedBy: 1),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Chatterbox',style: TextStyle(color: Colors.white,fontSize:33,fontWeight: FontWeight.w900 ),),

                PopupMenuButton<String>(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0))
                  ),
                  elevation: 2,
                  icon: Icon(Icons.more_vert_outlined,color: Colors.white,),
                  onSelected: (result) => choiceAction(result)  ,
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: "Profile",
                      child: Text('Profile'),
                    ),
                    const PopupMenuItem<String>(
                      value: "Logout",
                      child: Text('Logout'),
                    ),
                  ],
                )
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
                    child:      isInternet
                    ?GetThings().usersList():     Center(child: Text(
                      "No internet connection....................."
                      ,style: TextStyle(color: Colors.white),))      ),


              ],
            ),
          ),
          isSearching ? MainContainer(height: screenHeight(context,dividedBy: 1.3),
              child: GetThings().searchUserLists(searchUsernameEditingController)) :

          Flexible(
            child: MainContainer(height:screenHeight(context,dividedBy: 1.3) ,
                child:        isInternet
                ?  GetThings().chatRoomsLists() :
                Container(
                  height: 300,width: 300,
                  child: Image.asset("images/noNet.jpg",fit: BoxFit.cover,),)
            )),





        ],
      ),
    )
    );



  }
}




