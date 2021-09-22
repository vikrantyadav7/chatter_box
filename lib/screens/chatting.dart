import 'dart:io';

import 'package:chatter_box/components/mainContainer.dart';
import 'package:chatter_box/components/tiles.dart';
import 'package:chatter_box/helperServices/database.dart';
import 'package:chatter_box/helperServices/Sharedprefenreces.dart';
import 'package:chatter_box/helperServices/gettingThings.dart';
import 'package:chatter_box/helperServices/userInfo.dart';
import 'package:chatter_box/screens/chat_screen.dart';
// import 'package:chatter_box/helperServices/splashScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:giphy_get/giphy_get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:chatter_box/components/imageShow.dart';

class Chatting extends StatefulWidget {

 final String chatWithName, username;
    int counter ;
Chatting(this.username, this.chatWithName, this.counter);


  @override
  _ChattingState createState() => _ChattingState();

}

class _ChattingState extends State<Chatting> {
  Stream? messageStream;
bool isImage = false;
  String ? chatRoomId ,url  ;
   String? myName ,
      myProfilePic ,
    myUserName,myEmail ;
   String  messageId = '' ;
  bool isInternet = false;




   TextEditingController  messageTextEditting  = TextEditingController();
   Widget chatMessages()  {
     return  StreamBuilder<QuerySnapshot>(
       stream: FirebaseFirestore.instance
           .collection("chatrooms")
           .doc(chatRoomId)
           .collection("chats").orderBy("ts",descending: true)
           .snapshots(),
       builder: (context, snapshot) {
         return snapshot.hasData ? ListView.builder(
             padding: EdgeInsets.only(bottom: 10,top: 16),
             itemCount: snapshot.data?.docs.length,
             reverse: true,
             itemBuilder: (context, index) {
               DocumentSnapshot ds = snapshot.data!.docs[index];

               return  Tiles().chatMessageTile(ds['message'] , myUserName == ds['sendBy'],ds['ts'],ds['isImage'],context);
             }) : Center(child: CircularProgressIndicator());
       },
     );
   }



getMyInfoFromPhone()async{
   myName = (await SharedPreferenceHelper().getDisplayName())!;
   myProfilePic = (await SharedPreferenceHelper().getUserProfileUrl())!;
   myEmail = (await SharedPreferenceHelper().getUserEmail())!;
   myUserName = (await SharedPreferenceHelper().getUserName())!;
   chatRoomId = await  GetThings().getChatRoomIdByUserName(myUserName!, widget.username) ;
   UserInfo().setOnlineInfo(chatRoomId!, myUserName);
}

 getAndSetMessages()async{
   messageStream = await DatabaseMethods().getChatRoomMessages(chatRoomId);
   setState(() {});
 }

 doThisOnLaunch() async{
  await getMyInfoFromPhone();
  if (getAndSetMessages() != null ){
    return getAndSetMessages();
  }
    else{Center(child: CircularProgressIndicator());}
  }
  File? _image;
  final picker = ImagePicker();
  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedFile!.path);
    });
  }

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
    doThisOnLaunch();
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
   super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        UserInfo().updateOnline(chatRoomId!, myUserName!);
        UserInfo().checkShow(myUserName!, chatRoomId!);
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(

        body: Container(padding: EdgeInsets.only(top: 20),
            decoration: BoxDecoration(image: DecorationImage(image: AssetImage('images/chart.jpg'),fit: BoxFit.fill)),
          child: Column(mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 9),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [TextButton(onPressed: (){
                    UserInfo().updateOnline(chatRoomId!, myUserName!);

                    UserInfo().checkShow(myUserName!, chatRoomId!);

                    Navigator.pop(context);
                    }, child: Text('Back',style: TextStyle(color: Colors.white,fontSize:20 ),)),
                  // TextButton(onPressed: (){
                  // }, child: Text('search',style: TextStyle(color: Colors.white,fontSize:20 ),))

                ],),
              ),
              Container(width: screenWidth(context,dividedBy: 1),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [Flexible(child: Text(widget.chatWithName,style: TextStyle(color: Colors.white,fontSize:30 ),)),
                    IconButton(onPressed: (){}, icon: Icon(Icons.call,color: Colors.white,)),
                      IconButton(onPressed: (){
                        Navigator.pushNamed(context, MyHomePage.id);
                      }, icon: Icon(Icons.video_call,color: Colors.white,))

                    ],),
                ),
              ),
              Flexible(
                child: MainContainer(height: screenHeight(context,dividedBy: 1.4),
                    child: isInternet
                    ?
                    chatMessages()  :
                    Container(
                      height: 300,width: 300,
                      child: Image.asset("images/noNet.jpg",fit: BoxFit.cover,),))
              ),
              Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                child: Row(
                  children: [
                    Container(padding: EdgeInsets.only(left: 14,right: 3),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(24),
                        color: Colors.black12
                      ),

                      child: Row(
                        children: [

                          SizedBox(width: screenWidth(context,dividedBy: 1.6 ),
                            child: TextField(
                                textInputAction: TextInputAction.go,
                                    onSubmitted:(value)async{
                                    widget.counter++;
                                    SetThings().addMessage(true,messageTextEditting,chatRoomId ,widget.counter,isImage);
                                    },
                                onChanged: (value){

                              },
                              controller: messageTextEditting ,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: '  Type a message'
                              ),
                            ),),
                          GestureDetector(
                            onTap: () async{
                             await getImage();
                            ImageShow().showMyDialog(context,_image!,widget.counter,chatRoomId);

                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 7),
                              decoration: BoxDecoration(shape: BoxShape.circle,
                                color: Color(0xff4A9BDC),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(4),
                                child: Icon(Icons.menu,color: Colors.white,),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              widget.counter++;
                              SetThings().addMessage(true,messageTextEditting,chatRoomId,widget.counter ,isImage);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 7),
                              decoration: BoxDecoration(shape: BoxShape.circle,
                                color: Color(0xff4A9BDC),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(4),
                                child: Icon(Icons.send_outlined,color: Colors.white,),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),

                  ],
                ),
              )
            ],
        ),),
      ),
    );
  }
}
