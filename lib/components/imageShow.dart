import 'dart:io';
import 'package:chatter_box/helperServices/gettingThings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' ;
class ImageShow{
 String? url ;
  Future uploadFile(File _image) async {
    String fileName = basename(_image.path);
    var storageReference = FirebaseStorage.instance
        .ref()
        .child('profile/$fileName');
    var uploadTask = storageReference.putFile(_image);
    await uploadTask.whenComplete(() =>
        storageReference.getDownloadURL().then((fileURL) {

          url = fileURL;
          print('uploded $url');
        }));

  }

  Future<void> showMyDialog(context,  File image, int count , chatRoomId ) async {
    return showCupertinoDialog<void>(
      barrierDismissible: true,
      context: context, 
        builder: (BuildContext context) {
        return AlertDialog(

          content: Image.file(image,fit:BoxFit.cover),
          actions: <Widget>[
            TextButton(
              child:  Text('Send'),
              onPressed: () async{
             await   uploadFile(image);
             count++;
              await  SetThings().addMessage(false, url, chatRoomId, count, true);

                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }


 Future<void> showMyImage(context,   image ) async {
   return showCupertinoDialog<void>(
     barrierDismissible: true,
     context: context,
     builder: (BuildContext context) {
       return AlertDialog(
         content: Image.network(image,fit:BoxFit.cover),
       );
     },
   );
 }


}