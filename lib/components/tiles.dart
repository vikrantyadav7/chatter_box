import 'package:chatter_box/helperServices/database.dart';
import 'package:chatter_box/helperServices/gettingThings.dart';
import 'package:chatter_box/screens/chatting.dart' ;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';


class Tiles{

  Widget chatMessageTile(String message ,bool sendByMe,Timestamp time ){


    return Column(crossAxisAlignment: sendByMe? CrossAxisAlignment.end :CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: sendByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [

            Container( constraints: BoxConstraints( maxWidth: 280),
              decoration: BoxDecoration(
                color:  sendByMe ? Colors.blue : Colors.lightBlueAccent,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  bottomLeft:sendByMe ? Radius.circular(24) : Radius.circular(0),
                  topRight: Radius.circular(24),
                  bottomRight: sendByMe ? Radius.circular(0) : Radius.circular(24),
                ),

              ),
              margin: EdgeInsets.symmetric(horizontal: 6,vertical: 4),
              padding: EdgeInsets.all(10),
              child: Text(message,style: TextStyle(color: Colors.white),),
            ),

          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Text(DateFormat.jm().format(time.toDate()),style: TextStyle(color: Colors.black,fontSize: 8),),
        ),
      ],
    );
  }

  Widget searchListUserTile (String profileURL,name,email,username ,context ){

    return GestureDetector(
      onTap:(){
        print('this value is $myUserName $username');
        var chatRoomId = GetThings().getChatRoomIdByUserName(username, myUserName);
        print('and this is  $chatRoomId');
        Map<String ,dynamic > chatRoomInfoMap = {
          'users' : [myUserName , username]
        };
        DatabaseMethods().createChatRoom(chatRoomId, chatRoomInfoMap)!;
        Navigator.push( context,MaterialPageRoute(builder: (context) => Chatting(myUserName!, username)) );
      } ,
      child: Row(
        children: [
          ClipRRect(borderRadius: BorderRadius.circular(40),
              child: Image.network(profileURL,width: 30,height: 30,)),
          SizedBox(width: 12,),
          Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name),
              Text(email)
            ],
          )

        ],),
    );
  }

  Widget usersTile(String url , username , context
      ){
    return GestureDetector(
      onTap: (){
        var chatRoomId = GetThings().getChatRoomIdByUserName(username, myUserName);
        print('and this is  $chatRoomId');
        Map<String ,dynamic > chatRoomInfoMap = {
          'users' : [myUserName , username]
        };
        DatabaseMethods().createChatRoom(chatRoomId, chatRoomInfoMap)!;
        Navigator.push( context,MaterialPageRoute(builder: (context) => Chatting(username, myUserName!)) );
      },
      child: Container(padding: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: Image.network(url)),
            SizedBox(width: 10,),
          ],
        ),
      ),
    );
  }

}



class ChatRoomListTile extends StatefulWidget {

  final String lastMessage , chatRoomId, myUsername;
  final Timestamp time ;

  ChatRoomListTile(this.lastMessage, this.chatRoomId, this.myUsername, this.time);

  @override
  _ChatRoomListTileState createState() => _ChatRoomListTileState();
}

class _ChatRoomListTileState extends State<ChatRoomListTile> {
  String profilePicUrl = 'https://miro.medium.com/max/875/0*H3jZONKqRuAAeHnG.jpg' , name = ''  ,username = "";



  getThisUserInfo() async {
    print('userinfo called');
     username = widget.chatRoomId.replaceAll(widget.myUsername, "").replaceAll("_", "");
    QuerySnapshot querySnapshot = await DatabaseMethods().getUserInfo(username);
    // print("something bla bla ${querySnapshot.docs[0].id} ${querySnapshot.docs[0]["name"]}  ${querySnapshot.docs[0]["profileURL"]}");
    name = "${querySnapshot.docs[0]["name"]}";
    profilePicUrl = "${querySnapshot.docs[0]["profileURL"]}";
    setState(() {});

  }

  @override
  void initState() {
    getThisUserInfo();
    super.initState();

  }



  @override
  Widget build(BuildContext context) {
String newTime = DateFormat.jm().format(widget.time.toDate()) ;
   return GestureDetector(
      onTap: () {

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Chatting(username, widget.myUsername)));
      },
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.network(profilePicUrl,

                    height: 40,
                    width: 40,
                  ),
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 3),
                    SizedBox(width: 210,
                        child: Text(widget.lastMessage,overflow: TextOverflow.ellipsis)),
                  ],
                ),
                Text(newTime),

              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Divider(thickness: 0.5 ,),
          )
        ],
      ),
    );
  }
}