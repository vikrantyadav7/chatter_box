import 'package:chatter_box/components/rounded_button.dart';
import 'package:chatter_box/helperServices/sharedprefenreces.dart';
import 'package:chatter_box/screens/home.dart';
import 'package:chatter_box/screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'database.dart';


class AuthMethods   {
  final  FirebaseAuth auth = FirebaseAuth.instance;
bool invalid = false;
  //get current user
  getCurrentUser() async => auth.currentUser!.uid;

 existingUserDataUpdate(String userId, User user)async{
   final snapshot =  await  FirebaseFirestore.instance.collection("users").doc(userId).get();

   await SharedPreferenceHelper().saveUserEmail(snapshot["email"]);
   await SharedPreferenceHelper()
       .saveUserName(user.phoneNumber!);
 await  SharedPreferenceHelper().saveDisplayName(snapshot["name"]);
 await  SharedPreferenceHelper().saveUserProfileUrl(snapshot["profileURL"]);

 }


  Future<User?> signInWithGoogle(BuildContext context) async {
    final snackBar =  SnackBar(backgroundColor:Colors.blue ,
        elevation: 2,

        content: Text("Signing  in ....."
            " please wait ....",style: TextStyle(color: Colors.white),));

    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = new GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
    await _googleSignIn.signIn();

    final GoogleSignInAuthentication googleSignInAuthentication =
    await googleSignInAccount!.authentication;

    ScaffoldMessenger.of(context).showSnackBar(snackBar); // snackbar with some message

    final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    UserCredential result =
    await _firebaseAuth.signInWithCredential(credential);
    User? userDetails = result.user;


      SharedPreferenceHelper().saveUserEmail(userDetails!.email!);

      SharedPreferenceHelper().saveUserId(userDetails.uid);
      SharedPreferenceHelper()
          .saveUserName(userDetails.email!.replaceAll("@gmail.com", ""));
      SharedPreferenceHelper().saveDisplayName(userDetails.displayName!);
      SharedPreferenceHelper().saveUserProfileUrl(userDetails.photoURL!);

      Map<String,dynamic>userInfoMap = {
        'email':userDetails.email,
        'username':userDetails.email!.replaceAll('@gmail.com', ''),
        'name':userDetails.displayName,
        'profileURL':userDetails.photoURL
      };


    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    DatabaseMethods().addUserInfoToDB( userDetails.uid,userInfoMap).then((value) {

      Navigator.pushReplacementNamed(context, HomeScreen.id);
      });

  }

  Future signOut() async {
     GoogleSignIn _googleSignIn = GoogleSignIn();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    await auth.signOut();
    await _googleSignIn.signOut();

  }

  // this is for phone number login
  final _codeController = TextEditingController();

 Future signInWithNumber(String phoneNumber, BuildContext context,)async{
   final snackBar = SnackBar(backgroundColor:Colors.blue ,
       elevation: 2,

       content: Text("Sending OTP please wait ",style: TextStyle(color: Colors.white),));


   ScaffoldMessenger.of(context).showSnackBar(snackBar);
    auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential credential ) async {

      UserCredential authResult =  await auth.signInWithCredential(credential);
      User? user = authResult.user;

      String userId = user!.uid;
      SharedPreferenceHelper().saveUserId(userId);

       
            final snapshot =  await  FirebaseFirestore.instance.collection("users").doc(userId).get();
            if(snapshot.exists ){
            await existingUserDataUpdate(userId, user);
            Navigator.pushReplacementNamed(context, HomeScreen.id);
            }
            else{
              Navigator.of(context).pop();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen(userId, user.phoneNumber!)),
              );
            }
          

        },
        verificationFailed: (FirebaseAuthException exception){
          final snackBar = SnackBar(content: Text(exception.toString()));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);

        },

        // IF OTP IS NOT VERIFIED AUTOMATICALLY
        codeSent: (String verificationId, [ int? forceResendingToken  ]){
          final snackBar3 = SnackBar(elevation: 2,
              backgroundColor: Colors.blue,
              content: (Text('verifying OTP ',style: TextStyle(color: Colors.white),)));
          ScaffoldMessenger.of(context).showSnackBar(snackBar3);

          showDialog(context: context,barrierDismissible: false, builder: (context){
            return
              AlertDialog(
                title: Center(child: Text("Code Sent Successfully")),
                content: textItem( "ENTER OTP",
                    _codeController, false, invalid,context,TextInputType.numberWithOptions()),
                actions: [
                  TextButton(
                      onPressed: () async {
                        final code = _codeController.text.trim();
                            if (_codeController.text != "" && _codeController.text.length == 6){
                        AuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: code) ;
                        UserCredential result = await auth.signInWithCredential(credential);
                        User? user = result.user;
                        SharedPreferenceHelper().saveUserId(user!.uid);
                        invalid = false;

                        final snapshot =  await  FirebaseFirestore.instance.collection("users").doc(user.uid).get();
                        if(snapshot.exists ){
                        await  existingUserDataUpdate(user.uid, user);
                          Navigator.pop(context);
                          Navigator.pushReplacementNamed(context, HomeScreen.id); }
                        else{
                          Navigator.pop(context);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => LoginScreen(user.uid, user.phoneNumber!)),
                          );
                        }
                            }
                            else{
                              invalid =true;
                            }
                      }, child: Center(
                    child: Container(width:100,height:50,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),
                          color: Colors.blue
                      ),
                      child: Center(child: Text("Login",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),)),),
                  ))],
              );
          });
        }, codeAutoRetrievalTimeout: (String verificationId)async {  },
        );

 }
}