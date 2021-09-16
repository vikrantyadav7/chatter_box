import 'dart:io';
import 'package:chatter_box/components/rounded_button.dart';
import 'package:chatter_box/helperServices/database.dart';
import 'package:chatter_box/helperServices/sharedprefenreces.dart';
import 'package:chatter_box/screens/home.dart';
import 'package:firebase_storage/firebase_storage.dart'; // For File Upload To Firestore
import 'package:path/path.dart' ;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class LoginScreen extends StatefulWidget {

  final String uid  , phoneNumber;


  const LoginScreen( this.uid, this.phoneNumber);
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
   bool invalidName = false;
   bool invalidEmail = false;
   bool invalidPic = false;

   Future uploadFile() async {
     String fileName = basename(_image!.path);
     var storageReference = FirebaseStorage.instance
         .ref()
         .child('profile/$fileName');
     var uploadTask = storageReference.putFile(_image!);
     await uploadTask.whenComplete(() =>
         storageReference.getDownloadURL().then((fileURL) {
           setState(() {
             _uploadedFileURL = fileURL;
           });


         }));

   }



  File? _image;
  final picker = ImagePicker();
  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedFile!.path);
    });
  }

  TextEditingController _controllerName = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  String _uploadedFileURL  = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              width: 139,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  _image == null
                      ? Positioned(
                    child: Container(
                      width: 210,
                      height: 220,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image:AssetImage('images/uploadpic.jpg'),
                              fit: BoxFit.fitWidth),
                          borderRadius: BorderRadius.all(
                              Radius.circular(15)),
                          border: Border.all(
                              color: invalidPic ? Colors.red :Colors.blue
                          )),

                    ),
                  )
                      : Container(
                    width: 210,
                    height: 220,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                        image: DecorationImage(
                            image: FileImage(_image!),
                            fit: BoxFit.fitWidth)),
                  ),
                  Positioned(
                    right: 50,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                              Radius.circular(5)),
                          color: invalidPic ? Colors.red : Colors.lightBlueAccent
                      ),
                      child: IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 17,
                          ),
                          onPressed: getImage),
                    ),
                  ),

                ],
              ),
            ),
            SizedBox(
              height: 48.0,
            ),
            textItem("Enter Your Name",_controllerName , false, invalidName, context ,TextInputType.text),
            SizedBox(
              height: 50.0,
            ),
            textItem("Enter Your Email ",_controllerEmail , false, invalidEmail, context ,TextInputType.emailAddress),

            SizedBox(
              height: 24.0,
            ),
            RoundButton(onPressed: ()async {
              final snackBar = SnackBar(backgroundColor:Colors.blue ,
                  elevation: 2,

                  content: Text("Logging in ....."
                      " please wait ....",style: TextStyle(color: Colors.white),));
             if(_controllerName.text != "" && _controllerEmail.text != "" && _image != null) {
                 await uploadFile();
               invalidName = false;
               invalidEmail = false;
               invalidPic = false;
                 ScaffoldMessenger.of(context).showSnackBar(snackBar); // snackbar with some message


                 SharedPreferenceHelper().saveUserEmail(_controllerEmail.text);
               SharedPreferenceHelper().saveUserId(widget.uid);
               SharedPreferenceHelper()
                   .saveUserName(widget.phoneNumber);
               SharedPreferenceHelper().saveDisplayName(_controllerName.text);
               SharedPreferenceHelper().saveUserProfileUrl(_uploadedFileURL);

               Map<String,dynamic>userInfoMap = {
                 'email': _controllerEmail.text,
                 'username': widget.phoneNumber,
                 'name': _controllerName.text,
                 'profileURL': _uploadedFileURL
               };
                 ScaffoldMessenger.of(context).hideCurrentSnackBar(); // snackbar with some message

                 DatabaseMethods().addUserInfoToDB( widget.uid,userInfoMap).then((value) {
             final snackBar2 =  SnackBar(backgroundColor:Colors.blue ,
                     elevation: 2,
                 duration: Duration(seconds: 2),
                     content: Text("Log in successful....."
                         ,style: TextStyle(color: Colors.white),));
             ScaffoldMessenger.of(context).showSnackBar(snackBar2); // snackbar with some message
                Navigator.pop(context);
             Navigator.pushNamed(context, HomeScreen.id);
               });

             }
             else if(_image == null){
               setState(() {
                 invalidPic= true;

               });
             }
             else if(_controllerEmail.text == ''){
              setState(() {
                invalidEmail= true;
               });
             }
             else {
               setState(() {
                 invalidName= true;
               });
             }
            }

              ,
              title: 'login',
              colour: Colors.lightBlueAccent,)

          ],
        ),
      ),
    );
  }
}


