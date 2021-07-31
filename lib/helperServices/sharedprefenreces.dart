
import 'package:chatter_box/helperServices/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  static String userIdKey = "USERIDKEY";
  static String userNameKey = "USERNAMEKEY";
  static String displayNameKey = "USERDISPLAYNAME";
  static String userEmailKey = "USEREMAILKEY";
  static String userProfilePicKey = "USERPROFILEKEY";
  static String userProfile = "USERPROFILEKEY" ;
  static String counterKey = "COUNTERKEY" ;

  static String name = "" , profilePicUrl = "";

  storeUsersInfo()async{
    print('STORE CALLED');
    QuerySnapshot querySnapshot = await DatabaseMethods().getUsers();
    var length = querySnapshot.docs.length ;
    int i = 0 ;
    while (  i < length ) {
      name = "${querySnapshot.docs[i]["name"]}";
      profilePicUrl = "${querySnapshot.docs[i]["profileURL"]}";
      String userName = "${querySnapshot.docs[i]['username']}";
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.setString("name$i" , name);
      sharedPreferences.setString("profile$i" , profilePicUrl);
      sharedPreferences.setString("username$i" , userName);

      i++;
    }
  }

  //save data
  Future<bool> saveCounter(int counterNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setInt(counterKey, counterNumber);
  }

  Future<bool> saveUserName(String userName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userNameKey, userName);
  }

  Future<bool> saveUserEmail(String getUseremail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userEmailKey, getUseremail);
  }

  Future<bool> saveUserId(String getUserId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userIdKey, getUserId);
  }

  Future<bool> saveDisplayName(String getDisplayName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(displayNameKey, getDisplayName);
  }

  Future<bool> saveUserProfileUrl(String getUserProfile) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userProfilePicKey, getUserProfile);
  }

  //get data
  Future<String?> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userNameKey);
  }

  Future<String?> getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userEmailKey);
  }

  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userIdKey);
  }

  Future<String?> getDisplayName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(displayNameKey);
  }

  Future<String?> getUserProfileUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userProfilePicKey);
  }

  Future<String?> getProfileUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userProfile);
  }

  Future<int?> getCounterNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(counterKey);
  }

}