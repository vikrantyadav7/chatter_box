import 'package:chatter_box/helperServices/database.dart';
import 'package:chatter_box/helperServices/Sharedprefenreces.dart';
import 'package:chatter_box/helperServices/gettingThings.dart';
import 'package:chatter_box/screens/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class Chatting extends StatefulWidget {

 final String chatWithUserName, name;
Chatting(this.name, this.chatWithUserName);


  @override
  _ChattingState createState() => _ChattingState();
}

class _ChattingState extends State<Chatting> {
   Stream? messageStream;
  String ? chatRoomId   ;
   String? myName ,
      myProfilePic ,
    myUserName,myEmail ;
   String  messageId = '' ;


getMyInfoFromPhone()async{
   myName = (await SharedPreferenceHelper().getDisplayName())!;
   myProfilePic = (await SharedPreferenceHelper().getUserProfileUrl())!;
   myEmail = (await SharedPreferenceHelper().getUserEmail())!;
   myUserName = (await SharedPreferenceHelper().getUserName())!;
   chatRoomId =  GetThings().getChatRoomIdByUserName(widget.name, widget.chatWithUserName) ;

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

 @override
  void initState() {
   doThisOnLaunch();
    super.initState();


  }
  @override
  Widget build(BuildContext context) {
  print('this samne vala ${widget.name}and is ${widget.chatWithUserName} and ye h chatroomid$chatRoomId');
    return Scaffold(

      body: Container(
          decoration: BoxDecoration(image: DecorationImage(image: AssetImage('images/chart.jpg'),fit: BoxFit.fill)),
        child: Column(mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 9),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [TextButton(onPressed: (){Navigator.pop(context,HomeScreen.id);}, child: Text('back',style: TextStyle(color: Colors.white,fontSize:20 ),)),
                TextButton(onPressed: (){}, child: Text('search',style: TextStyle(color: Colors.white,fontSize:20 ),))

              ],),
            ),
            Container(width: screenWidth(context,dividedBy: 1),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text(widget.name, overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.white,fontSize:30 ),),
                  IconButton(onPressed: (){}, icon: Icon(Icons.call,color: Colors.white,)),
                    IconButton(onPressed: (){}, icon: Icon(Icons.video_call,color: Colors.white,))

                  ],),
              ),
            ),
            Flexible(
              child: Container(height: screenHeight(context,dividedBy: 1.4),
                decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topRight: Radius.circular(30),topLeft: Radius.circular(30),)
                  ),
                  child: GetThings().chatMessages()),
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
                        SizedBox(width: screenWidth(context,dividedBy: 1.3 ),
                          child: TextField(
                            onChanged: (value){

                            },
                            controller: SetThings().messageTextEditting ,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: '  Type a message'
                            ),
                          ),),
                        GestureDetector(
                          onTap: () {
                            SetThings().addMessage(true);
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
    );
  }
}
