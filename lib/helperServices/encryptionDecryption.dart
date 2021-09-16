import 'package:encrypt/encrypt.dart' as encrypt;
class MyEncryptionDecryption{

  ///for encrption

 static final key = encrypt.Key.fromLength(32);
 static final iv = encrypt.IV.fromLength(16);
 static final  encrypter = encrypt.Encrypter(encrypt.AES(key));


  static encryptAES(message ){

   final encrypted =  encrypter.encrypt(message ,iv: iv);

      return encrypted.base64;
  }
  static decryptedAES(message){

    return   encrypter.decrypt64(message,iv: iv);

  }

}