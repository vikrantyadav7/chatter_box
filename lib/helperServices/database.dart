
import 'dart:ui';
import 'package:chatter_box/helperServices/sharedprefenreces.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';



Size screenSize(BuildContext context) {
  return MediaQuery.of(context).size;
}
double screenHeight(BuildContext context, {double dividedBy = 1}) {
  return screenSize(context).height / dividedBy;
}
double screenWidth(BuildContext context, {double dividedBy = 1}) {
  return screenSize(context).width / dividedBy;
}


class DatabaseMethods{
  addUserInfoToDB(String userId,Map<String,dynamic>userInfoMap, )async{
   return await FirebaseFirestore.instance.collection('users').doc(userId).set(userInfoMap);

  }


 Future addMessage(String chatRoomId , String messageId,messageInfoMap) async {
   return await FirebaseFirestore.instance.
   collection("chatrooms").
   doc(chatRoomId).collection('chats').doc(messageId).set(messageInfoMap);
 }
  Future personInfo(String chatRoomId , String username,personInfoMap) async {
    return await FirebaseFirestore.instance.
    collection("chatrooms").
    doc(chatRoomId).collection('information').doc(username).set(personInfoMap);
  }
 updateLastMessageSend(String chatRoomId, lastMessageInfoMap){
   return FirebaseFirestore
       .instance.collection('chatrooms').doc(chatRoomId)
       .update(lastMessageInfoMap);
 }
 createChatRoom(String chatRoomId , chatRoomInfoMap)async{
   final snapshot = await FirebaseFirestore.instance
       .collection('chatrooms')
       .doc(chatRoomId)
       .get();
   if (snapshot.exists){
     //chat already exists
     return true;}
   else{
     // create a chat room
     return FirebaseFirestore.instance
         .collection('chatrooms')
         .doc(chatRoomId)
         .set(chatRoomInfoMap);
   }

 }
  Future<Stream<QuerySnapshot>> getChatRoomMessages(chatRoomId) async {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("ts",descending: true)
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getChatRooms() async {
    String? myUsername = await SharedPreferenceHelper().getUserName();
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .orderBy("ts", descending: true)
        .where("users", arrayContains: myUsername)
        .snapshots();
  }

  Future<QuerySnapshot> getUserInfo(String username) async {
    return await FirebaseFirestore.instance
        .collection("chatrooms")
        .where("username", isEqualTo: username)
        .get();
  }


  Future<QuerySnapshot> getUsers() async {
    return await FirebaseFirestore.instance
        .collection("users")
        .get();
  }

   updateName(String uid ,updateNameMap )async{
   return await  FirebaseFirestore.instance.collection('users').doc(uid).update(updateNameMap);

   }

  updateProfilePic(String uid ,updateProfilePicMap )async{
   return await FirebaseFirestore.instance.collection('users').doc(uid).update(updateProfilePicMap);

  }
  updateToken(String uid ,updateTokenMap )async{
    return await FirebaseFirestore.instance.collection('users').doc(uid).update(updateTokenMap);

  }
  deleteData(String id )async{
     await FirebaseFirestore.instance.collection("chatrooms").doc(id).delete();


  }

}



