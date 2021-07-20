import 'package:chatter_box/components/tiles.dart';
import 'package:chatter_box/helperServices/database.dart';
import 'package:chatter_box/helperServices/sharedprefenreces.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
bool isSearching = false;

String chatRoomId = '',
    messageId= '',
    myName = '' ,
    myProfilePic = '',
    myEmail = '';
String?  myUserName;

Stream? userStream , chatRoomStream ,usersStream ;
class GetThings{

  getMyInfoFromPhone()async{

    myName = (await SharedPreferenceHelper().getDisplayName())!;
    myProfilePic = (await SharedPreferenceHelper().getUserProfileUrl())!;
    myEmail = (await SharedPreferenceHelper().getUserEmail())!;

    myUserName = (await SharedPreferenceHelper().getUserName())!;
       print('USERNAME MIL GYA $myUserName');

  }

  getChatRoomIdByUserName(String a ,b){
    if(a.substring(0,1).codeUnitAt(0) > b.substring(0,1).codeUnitAt(0))
    {
      return '$b\_$a';}
    else { return '$a\_$b'; }
  }



  Widget chatRoomsLists() {
    return StreamBuilder<QuerySnapshot>(
        stream:  FirebaseFirestore.instance
            .collection('chatrooms').orderBy("lastMessageSendTs", descending: true)
            .where("users", arrayContains:myUserName)
            .snapshots(),
        builder: (context, snapshot){
          return snapshot.hasData ? ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context,index){
                DocumentSnapshot ds = snapshot.data!.docs[index];

                return
                ChatRoomListTile(ds['lastMessage'], ds.id, myUserName!,ds['lastMessageSendTs'] );

              }) : Center(child: CircularProgressIndicator());
        }) ;
  }



  Widget searchUserLists(  searchUsernameEditingController) {
     print(searchUsernameEditingController);

    return StreamBuilder<QuerySnapshot>(
        stream:  FirebaseFirestore.instance
            .collection('users').where('username' ,isEqualTo :searchUsernameEditingController.text )
            .snapshots(),
        builder: (context, snapshot){
          return snapshot.hasData ? ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context,index){
                DocumentSnapshot ds = snapshot.data!.docs[index];
                return
                Tiles().searchListUserTile(ds['profileURL'], ds['name'], ds['email'], ds['username'], context) ;

              }) : Center(child: CircularProgressIndicator());
        }) ;
  }

  Widget usersList(){
    return
      StreamBuilder<QuerySnapshot>(
        stream:  FirebaseFirestore.instance
            .collection('users')
            .snapshots(),
        builder: (context, snapshot){
          return snapshot.hasData ? ListView.builder(
            scrollDirection: Axis.horizontal,
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context,index){
                DocumentSnapshot ds = snapshot.data!.docs[index];

                return
                Tiles().usersTile(ds['profileURL'], ds['username'], context);

              }) : Center(child: CircularProgressIndicator());
        }) ;
  }


}






class SetThings {



  addMessage(bool sendClicked,messageTextEditting,chatRoomId) {
    if (messageTextEditting.text != "") {
      String message = messageTextEditting.text;

      var lastMessageTs = DateTime.now();

      Map<String, dynamic> messageInfoMap = {
        "message": message,
        "sendBy": myUserName,
        "ts": lastMessageTs,
        "imgUrl": myProfilePic
      };

      //messageId
      if (messageId == "") {
        messageId = randomAlphaNumeric(12);
      }

      DatabaseMethods()
          .addMessage(chatRoomId, messageId, messageInfoMap)
          .then((value) {
        Map<String, dynamic> lastMessageInfoMap = {
          "lastMessage": message,
          "lastMessageSendTs": lastMessageTs,
          "lastMessageSendBy": myUserName
        };

        DatabaseMethods().updateLastMessageSend(chatRoomId, lastMessageInfoMap);

        if (sendClicked) {
          // remove the text in the message input field
          messageTextEditting.text = "";
          // make message id blank to get regenerated on next message send
          messageId = "";
        }
      });
    }
  }
}