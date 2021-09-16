import 'dart:ui';
import 'package:chatter_box/components/imageShow.dart';
import 'package:chatter_box/helperServices/database.dart';
import 'package:chatter_box/helperServices/encryptionDecryption.dart';
import 'package:chatter_box/helperServices/gettingThings.dart';
import 'package:chatter_box/helperServices/sharedprefenreces.dart';
import 'package:chatter_box/screens/chatting.dart' ;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';




class Tiles{



  Widget chatMessageTile(String message ,bool sendByMe,Timestamp time,bool isImage ,context) {
  String ses = MyEncryptionDecryption.decryptedAES(message);

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
              child: isImage ?
              GestureDetector(
                onTap: (){
                  ImageShow().showMyImage(context, ses);},
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.network(ses),),
              )

                  :Text(ses,style: TextStyle(color: Colors.white),),
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
        var chatRoomId = GetThings().getChatRoomIdByUserName(myUserName!, username);
        print('and this is  $chatRoomId');
        Map<String ,dynamic > chatRoomInfoMap = {
          'users' : [myUserName , username]
        };
        DatabaseMethods().createChatRoom(chatRoomId, chatRoomInfoMap)!;
        Navigator.push( context,MaterialPageRoute(builder: (context) => Chatting(username, name,0)) );
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

  Widget usersTile(String url , username , name,context
      ){
    return GestureDetector(
      onTap: (){
        var chatRoomId = GetThings().getChatRoomIdByUserName(myUserName!,username );
        print('and this is  $chatRoomId');
        Map<String ,dynamic > chatRoomInfoMap = {
          'users' : [myUserName ,username ]
        };
        DatabaseMethods().createChatRoom(chatRoomId, chatRoomInfoMap)!;
        Navigator.push( context,MaterialPageRoute(builder: (context) => Chatting(username, name,0)) );
      },
      onLongPress: (){
        showDialog(context: context, builder: (context){
          return AlertDialog(
            title: Text("Name :  $name"),
            content: Image.network(url,fit: BoxFit.cover,),
          );
        });
      },
      child: Container(padding: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: Image.network(url,fit: BoxFit.cover,height: 40,
                  width: 40,)),
            SizedBox(width: 10,),
          ],
        ),
      ),
    );
  }

}



class ChatRoomListTile extends StatefulWidget {

  final String lastMessage , chatRoomId, myUserName ,sendBy ;
  final Timestamp time ;
 final  bool read  ;
  int count;
bool show , isImage ;
  ChatRoomListTile(this.lastMessage, this.chatRoomId, this.myUserName, this.time, this.read, this.sendBy, this.count, this.show ,this.isImage);

  @override
  _ChatRoomListTileState createState() => _ChatRoomListTileState();

}


class _ChatRoomListTileState extends State<ChatRoomListTile> {
  String profilePicUrl = 'https://miro.medium.com/max/875/0*H3jZONKqRuAAeHnG.jpg' , name = ''  ;
  get  userName =>   widget.chatRoomId.replaceAll(widget.myUserName, "").replaceAll("_", "");

  String get newTime => DateFormat.jm().format(widget.time.toDate()) ;
   String get aes => MyEncryptionDecryption.decryptedAES(widget.lastMessage);
 int? counter = 0 ;
  test<bool>(){
   if(widget.sendBy == myUserName){
     return false;
   }
   else return true;
  }
 counterTest<bool>(){
    if ("${widget.count- counter!}" == "0"){
      return false;
    }else return true;
 }

   data(){
    return StreamBuilder<QuerySnapshot>(
        stream:  FirebaseFirestore.instance
            .collection('users').where("username" , isEqualTo: userName )
            .snapshots(),
        builder: (context, snapshot){
          return snapshot.hasData ? ListView.builder(
            shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),

              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context,index){
                DocumentSnapshot ds = snapshot.data!.docs[index];
                  return GestureDetector(
                    onTap: ()async{
                      counter = widget.count;
                      SharedPreferenceHelper().saveCounter(counter!);
                       if (widget.read == false){
                               if(test() == true){
                         Map<String,dynamic>readMap = {'readStatus': true,};
                      FirebaseFirestore.instance.collection("chatrooms").doc(widget.chatRoomId).update(readMap); }}
                       int counters = (await  SharedPreferenceHelper().getCounterNumber())!;

                       Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Chatting(userName, ds["name"], counters)));

                    },
                    child: Column(
                      children: [
                        Container(color:  Colors.white ,
                          margin: EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              GestureDetector(
                                    onTap: (){showDialog(context: context, builder: (context){
                                      return AlertDialog(elevation: 2,
                                        content: Image.network(ds["profileURL"],fit: BoxFit.cover,),
                                      ) ;
                                    });
                                    },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: Image.network( ds["profileURL"],
                                    fit: BoxFit.cover,
                                    height: 50,
                                    width: 50,
                                  ),
                                ),
                              ),
                              SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                       ds["name"] ,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  SizedBox(height: 3),
                                  SizedBox(width: screenWidth(context,dividedBy: 1.9),
                                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          widget.isImage?
                                          Row(
                                            children: [
                                              Icon(Icons.photo),
                                              SizedBox(width: 10,),
                                              Text("Photo")
                                            ],
                                          )
                                              :
                                          Text(aes, overflow: TextOverflow.ellipsis),

                                        ],
                                      )),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(newTime,style: TextStyle(color: widget.show?  test()?
                                  counterTest()?
                                  Colors.lightBlue:  Colors.white    : Colors.white : Colors.white ),),
                                  SizedBox(height: 5,),
                                  Container(height: 20,width: 20,
                                    decoration: BoxDecoration(shape: BoxShape.circle,
                                        color: widget.show ? test()? counterTest()?
                                        Colors.lightBlue:  Colors.white    : Colors.white : Colors.white),
                                    child: Center(
                                      child: Text(
                                        widget.show ?
                                        test()?
                                        counterTest()?
                                        '${widget.count-counter!}':  ""     :"" :''
                                        ,

                                        style: TextStyle(color: Colors.white,fontSize: 15),),
                                    ),
                                  )
                                ],
                              ),

                            ],
                          ),
                        ),

                      ],
                    ),
                  );

              }) : Center(child: CircularProgressIndicator());
        }) ;
  }

  @override
  Widget build(BuildContext context) {

      if(widget.read == true){
        counter = widget.count;
        SharedPreferenceHelper().saveCounter(counter!);
      }


    return


      Container(
        width: screenWidth(context, dividedBy: 1),
        height: 82,
        child:  data(),
      );
  }

}