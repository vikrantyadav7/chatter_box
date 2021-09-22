import 'dart:io';
import 'package:chatter_box/components/rounded_button.dart';
import 'package:chatter_box/helperServices/splashScreen.dart';
import 'package:chatter_box/helperServices/database.dart';
import 'package:chatter_box/helperServices/gettingThings.dart';
import 'package:chatter_box/helperServices/sharedprefenreces.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' ;
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:image_picker/image_picker.dart';

class SignUpPage extends StatefulWidget {
  static const String id = "profileUpdate";

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  firebase_auth.FirebaseAuth firebaseAuth = firebase_auth.FirebaseAuth.instance;
  TextEditingController _nameController = TextEditingController();
 bool isInternet = false;
 String? url ;
 bool invalid = false;
  bool circular = false;
String id = '' ;
getKey()async{

  id = (await SharedPreferenceHelper().getUserId())!;
  myName = (await SharedPreferenceHelper().getDisplayName())!;
  myProfilePic = (await SharedPreferenceHelper().getUserProfileUrl())!;

}
  showDialogBox(context)async{
    bool updateName = await
      showDialog(context: context ,barrierDismissible: false, builder: (context)
      {
        return AlertDialog(
          title: Center(child: Text("Enter your name",style: TextStyle(color: invalid ? Colors.red : Colors.black),)),
          content: textItem("Name",
              _nameController, false, invalid, context, TextInputType.text),
          actions: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                    onPressed: () async {
                      if(_nameController.text != ""){

                          invalid = false;
                          print(invalid);
                          setState(() {
                          });

                        Map<String,dynamic>updateNameMap = {'name': _nameController.text,};
                        await DatabaseMethods().updateName(id, updateNameMap);
                        await SharedPreferenceHelper().saveDisplayName(_nameController.text);
                        Navigator.pop(context,true);

                      }
                      else{

                          invalid  = true;
                          print(invalid);
                          setState(() {

                          });
                        }
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
                      Navigator.pop(context,true);

                      _nameController.text = "";
                      invalid  = false ;
                      print(invalid);
                      setState(() {

                      });

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

    setState(() {
      updateName ? getKey() : "" ;
    });
  }
  File? _image;
  final picker = ImagePicker();
  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedFile!.path);
    });
  }
  Future uploadFile() async {
    String fileName = basename(_image!.path);
    var storageReference = FirebaseStorage.instance
        .ref()
        .child('profile/$fileName');
    var uploadTask = storageReference.putFile(_image!);
    await uploadTask.whenComplete(() =>
        storageReference.getDownloadURL().then((fileURL) {

            url = fileURL;
            print("fileupated $url");
        }));

  }
  Future<bool> connectivityChecker() async {
    var connected = false;
    print("Checking internet...");
    try {
      final result = await InternetAddress.lookup('google.com');
      final result2 = await InternetAddress.lookup('facebook.com');
      final result3 = await InternetAddress.lookup('microsoft.com');
      if ((result.isNotEmpty && result[0].rawAddress.isNotEmpty) ||
          (result2.isNotEmpty && result2[0].rawAddress.isNotEmpty) ||
          (result3.isNotEmpty && result3[0].rawAddress.isNotEmpty)) {
        print('connected..');
        connected = true;
        setState(() {
          isInternet = true;
        });


      } else {
        print("not connected from else..");
        connected = false;

        setState(() {
          isInternet = false;
        });

      }
    } on SocketException catch (_) {
      print('not connected...');
      connected = false;

      setState(() {
        isInternet = false;
      });

    }
    return connected;
  }

  @override
  void initState() {
  getKey();
  connectivityChecker();
  var subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
    // Got a new connectivity status!
    connectivityChecker();
  });
// Be sure to cancel subscription after you are done
    @override
    dispose() {
      super.dispose();
      subscription.cancel();
    }
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // connectivityChecker();
    return Scaffold(
      appBar: AppBar(title: Text("Profile"),),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding:  EdgeInsets.symmetric(vertical: 50,horizontal: 10),
            child: Column(
              children: [
                Stack(alignment: AlignmentDirectional.bottomEnd,
                  children :[
                    GestureDetector(
                    onTap:(){
                      showDialog(context: context, builder: (context){
                        return AlertDialog(elevation: 2,
                        content: Image.network(myProfilePic,fit: BoxFit.cover,),
                        ) ;
                      });
                    } ,
                  child: ClipRRect(
                   borderRadius: BorderRadius.circular(120),
                     child:     isInternet
                    ?   Image.network(myProfilePic,width: 200,height: 200,fit:BoxFit.cover,)
                         : Image.asset("images/noNet.jpg",width: 200,height: 200,fit: BoxFit.cover,)),
             ),
                  Container(
                    decoration: BoxDecoration(shape: BoxShape.circle,color: Colors.blue),
                      child: IconButton(onPressed:()async{
                        await getImage();
                        await uploadFile();
                        await SharedPreferenceHelper().saveUserProfileUrl(url!);
                        String? img = await SharedPreferenceHelper().getUserProfileUrl();
                        print(img);
                        getKey();
                        setState(() {
                        });
                        Map<String,dynamic>updateProfilePicMap = {'profileURL': url,};
                        await DatabaseMethods().updateProfilePic(id, updateProfilePicMap);
                      },

                          icon: Icon(Icons.camera_alt_outlined,color: CupertinoColors.white,)))
                  ]
                ),
              SizedBox(height: 50,),
            GestureDetector(
              onTap: () async {
                showDialogBox(context);

              },
              child: Column(
                children: [


                  Container(
                    margin: EdgeInsets.symmetric(vertical: 18,horizontal: 10),
                    child: Column(mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        SizedBox(width: 12),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment:CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.person,color: Colors.blue,),
                              SizedBox(width: 20,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Name",
                                    style: TextStyle(fontSize: 16,color: Colors.grey),
                                  ),
                                  Text(myName)
                                ],
                              ),
                              SizedBox(width: 50,),

                              Icon(Icons.edit,color: Colors.grey,)
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 13.0,vertical: 0),
                          child: Text("this is your username which is visible to the person you are chatting with",style: TextStyle(color: Colors.grey),),
                        ),

                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Divider(thickness: 0.5 ,),
                  ),


                ],
              ),
            )

            ],),
          ),
        ),
      ),
    );
  }

}