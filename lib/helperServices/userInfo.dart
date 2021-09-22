

import 'package:chatter_box/helperServices/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


Map<String,dynamic>showMap = {'show': false,};
Map<String,dynamic>updatePersonInfoMap = {'online': false,};
Map<String,dynamic>personInfoMap = {'online': true,};


 class UserInfo {


 setOnlineInfo(String chatRoomId, myUserName){
   DatabaseMethods().personInfo(chatRoomId, myUserName, personInfoMap);

 }


  updateOnline(String chatRoomId, myUserName){
    FirebaseFirestore.instance.
    collection("chatrooms").
    doc(chatRoomId).collection('information').doc(myUserName).update(updatePersonInfoMap);
  }


  checkShow(String myUserName , chatRoomId)async{
    DocumentSnapshot ds = await  FirebaseFirestore.instance.collection("chatrooms").doc(chatRoomId!).get();
    if(ds["lastMessageSendBy"] != myUserName) {
      FirebaseFirestore.instance.collection("chatrooms").doc(chatRoomId).update(showMap);

    }
  }
}