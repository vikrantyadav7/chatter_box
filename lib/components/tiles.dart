

import 'package:chatter_box/helperServices/database.dart';
import 'package:chatter_box/helperServices/gettingThings.dart';
import 'package:chatter_box/screens/chatting.dart' ;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Tiles{
  Widget chatMessageTile(String message ,bool sendByMe ){
    return Row(
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
          margin: EdgeInsets.symmetric(horizontal: 16,vertical: 4),
          padding: EdgeInsets.all(10),
          child: Text(message,style: TextStyle(color: Colors.white),),
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
        Navigator.push( context,MaterialPageRoute(builder: (context) => Chatting('ahyusagt', 'vikrantyadav190')) );
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



}



class ChatRoomListTile extends StatefulWidget {

  final String lastMessage , chatRoomId, myUsername;
  ChatRoomListTile(this.lastMessage, this.chatRoomId, this.myUsername,);

  @override
  _ChatRoomListTileState createState() => _ChatRoomListTileState();
}

class _ChatRoomListTileState extends State<ChatRoomListTile> {
  String profilePicUrl = 'https://miro.medium.com/max/875/0*H3jZONKqRuAAeHnG.jpg' , name = '' ;

  get username => widget.chatRoomId.replaceAll(widget.myUsername, "").replaceAll("_", "");



  getThisUserInfo() async {

    QuerySnapshot querySnapshot = await DatabaseMethods().getUserInfo(username);
    print(
        "something bla bla ${querySnapshot.docs[0].id} ${querySnapshot.docs[0]["name"]}  ${querySnapshot.docs[0]["profileURL"]}");
    name = "${querySnapshot.docs[0]["name"]}";
    profilePicUrl = "${querySnapshot.docs[0]["profileURL"]}";
    setState(() {});
  }






  @override
  void initState() {
    getThisUserInfo();
    // TODO: implement initState
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('name is $username and ${widget.myUsername}');
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Chatting(username, widget.myUsername)));
      },
      child: Container(
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
                SizedBox(width: 220,
                    child: Text(widget.lastMessage,overflow: TextOverflow.ellipsis)),

              ],
            )
          ],
        ),
      ),
    );
  }
}