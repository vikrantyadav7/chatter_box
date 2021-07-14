import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chatter_box/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Chat extends StatefulWidget {
  static const String id = 'Chat_screen';



  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
 final messageTextController = TextEditingController();
  // FirebaseAuth _auth = FirebaseAuth.instance;
   CollectionReference messages = FirebaseFirestore.instance.collection('messages');

  timestamp() {
    var now = new DateTime.now();

    String formattedTime = DateFormat('kk:mm:a').format(now);

    return formattedTime;

  }
  // getMessages()async {
  //   final messages = await FirebaseFirestore.instance.collection('messages').get();
  //   for ( var message in  messages.docs){
  //     print(message.data());
  //   }
  // }
  // void messageStream() async {
  //   await for (var snapshot in FirebaseFirestore.instance.collection('messages').snapshots() )
  //     {for (var message in snapshot.docs){
  //       print(message.data());
  //     } }
  // }

  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('messages').snapshots();

 final FirebaseAuth auth = FirebaseAuth.instance;

  inputData() {
   final user = auth.currentUser;

   return user;
 }
  late String messageText ;
   
  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                inputData();
                // auth.signOut();
                // Navigator.pop(context);
                // getMessages();
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              decoration: kMessageContainerDecoration,

            ),

            Flexible(
              child: Container(height: 600,
                child: StreamBuilder<QuerySnapshot>(
                stream: _usersStream,
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                      return Text('Something went wrong');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text("Loading");
                      }

                      return new ListView(
                        reverse: true,

                      children: snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                      return new ListTile(
                      title: MessageBubble(text: 'text',data: data,),

                          );
                          }).toList(),);
                          },
                          ),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller:messageTextController ,
                    onChanged: (value) {
                      messageText = value ;
                    },
                    decoration: kMessageTextFieldDecoration,
                  ),
                ),
                TextButton(
                  onPressed: () async{
                    await messages.add({
                      'text': messageText,
                      'sender': timestamp(),
                      'id': 'as@af.com',

                    }).then((value) => print(timestamp()));
                    messageTextController.clear();
                  },
                  child: Text(
                    'Send',
                    style: kSendButtonTextStyle,
                  ),
                ),
              ],
            ),
          ]
        )

      )
    );
  }
}




class MessageBubble extends StatelessWidget {
  MessageBubble({required this.data,required this.text});
late final dynamic data;
late final String text;

  @override
  Widget build(BuildContext context) {
    return   Padding(
      padding:  EdgeInsets.all(18.0),
      child: Column(
        children: [
          Material( elevation: 5,
              borderRadius: BorderRadius.circular(30),
              color: Colors.lightBlueAccent,
              child:  Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                child: Text( data[text],
                 style: TextStyle(color: Colors.white),

                ),
              )),
          Text(data['sender'],style: TextStyle(color: Colors.black,fontSize: 12),),
        ],
      ),
    );
  }
}



