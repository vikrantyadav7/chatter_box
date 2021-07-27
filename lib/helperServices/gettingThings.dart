import 'package:chatter_box/components/rounded_button.dart';
import 'package:chatter_box/components/tiles.dart';
import 'package:chatter_box/helperServices/database.dart';
import 'package:chatter_box/helperServices/sharedprefenreces.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
// import 'package:string_encryption/string_encryption.dart';

bool isSearching = false;

String chatRoomId = '',
    messageId= '',
    myName = '' ,
    myProfilePic = '',
    myEmail = '';
String?  myUserName ;

Stream? userStream , chatRoomStream ,usersStream ;
class GetThings{

  getMyInfoFromPhone()async{
    print("info called ");
    myName = (await SharedPreferenceHelper().getDisplayName())!;
    myProfilePic = (await SharedPreferenceHelper().getUserProfileUrl())!;
    myEmail = (await SharedPreferenceHelper().getUserEmail())!;
    myUserName = (await SharedPreferenceHelper().getUserName())!;


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
                ChatRoomListTile(ds['lastMessage'], ds.id, myUserName!,ds['lastMessageSendTs'] ,ds["readStatus"], ds["lastMessageSendBy"],ds["count"]);

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
            .collection('users').where("username" , isNotEqualTo: myUserName )
            .snapshots(),
        builder: (context, snapshot){
          return snapshot.hasData ? ListView.builder(
            scrollDirection: Axis.horizontal,
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context,index){
                DocumentSnapshot ds = snapshot.data!.docs[index];

                return
                Tiles().usersTile(ds['profileURL'], ds['username'], ds["name"],context) ;


              }) : Center(child: CircularProgressIndicator());
        }) ;
  }


}





class SetThings {

  getMyInfoFromPhone()async{

    myName = (await SharedPreferenceHelper().getDisplayName())!;
    myProfilePic = (await SharedPreferenceHelper().getUserProfileUrl())!;
    myEmail = (await SharedPreferenceHelper().getUserEmail())!;
    myUserName = (await SharedPreferenceHelper().getUserName())!;

  }




  addMessage(bool sendClicked,messageTextEditting,chatRoomId ,int count) async{

    if (messageTextEditting.text != "") {


      String message = messageTextEditting.text;

      var lastMessageTs = DateTime.now();

     // print(number);




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
          "lastMessageSendBy": myUserName,
          "readStatus" : false ,
          "count" : count,
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

  TextEditingController _nameController = TextEditingController();
  bool invalid = false;

   updateName(String id ,context ){
    showDialog(context: context,barrierDismissible: false, builder: (context)
    {
      return AlertDialog(
        title: Center(child: Text("Enter your name")),
        content: textItem("Name",
            _nameController, false, invalid, context, TextInputType.text),
        actions: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                  onPressed: () async {
                    if(_nameController.text != ""){
                      invalid = false;
                      Map<String,dynamic>updateNameMap = {'name': _nameController.text,};
                     await DatabaseMethods().updateName(id, updateNameMap);
                      await SharedPreferenceHelper().saveDisplayName(_nameController.text);
                          Navigator.pop(context,"call getKey");

                    }
                    else{
                      invalid  = true;}
                  },
                  child: Center(
                    child: Container(width: 80, height: 40,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),
                          color: Colors.blue
                      ),
                      child: Center(child: Text("ok", style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),)),),
                  )),
              TextButton(
                  onPressed: () async {
                    Navigator.pop(context,"call getKey");

                    _nameController.text = "";
                    invalid  = false ;

                  },
                  child: Center(
                    child: Container(width: 80, height: 40,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),
                          color: Colors.blue
                      ),
                      child: Center(child: Text("cancel", style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),)),),
                  ))
            ],
          ),

        ],

      );

    });
  }



}