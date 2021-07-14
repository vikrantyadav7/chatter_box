import 'package:chatter_box/helperServices/sharedprefenreces.dart';
import 'package:chatter_box/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'database.dart';

class AuthMethods   {
  final  FirebaseAuth auth = FirebaseAuth.instance;

  //get current user
  getCurrentUser() async => auth.currentUser!.uid;

  Future<User?> signInWithGoogle(BuildContext context) async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = new GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
    await _googleSignIn.signIn();

    final GoogleSignInAuthentication googleSignInAuthentication =
    await googleSignInAccount!.authentication;

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



     DatabaseMethods().addUserInfoToDB( userDetails.uid,userInfoMap).then((value) {
      Navigator.pushNamed(context, HomeScreen.id);
      });

  }

  Future signOut() async {
     GoogleSignIn _googleSignIn = GoogleSignIn();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    await auth.signOut();
    await _googleSignIn.signOut();

  }
}