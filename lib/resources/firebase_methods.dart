import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutterskypeclone/constants/strings.dart';
import 'package:flutterskypeclone/models/message.dart';
import 'package:flutterskypeclone/models/user.dart';
import 'package:flutterskypeclone/provider/image_upload_provider.dart';
import 'package:flutterskypeclone/utils/utilities.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseMethods{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  static final Firestore firestore = Firestore.instance;

  StorageReference _storageReference;

  //user class
  User user = User();

  Future<FirebaseUser> getCurrentUser()async {
    FirebaseUser currentUser;
    currentUser = await _auth.currentUser();
    return currentUser;
  }

  Future<FirebaseUser> signIn() async{
    GoogleSignInAccount _signInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication _signInAuthentication = await _signInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: _signInAuthentication.idToken,
        accessToken: _signInAuthentication.accessToken
    );

    FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
    return user;
  }

  Future<bool> authenticateUser(FirebaseUser user) async{
    QuerySnapshot result = await firestore.collection(USERS_COLLECTION).where(EMAIL_FIELD, isEqualTo: user.email).getDocuments();

    final List<DocumentSnapshot> docs = result.documents;

    //if user is registered then length of list > 0 or else less than 0
    return docs.length == 0 ? true : false;
  }

  Future<void> addDataToDb(FirebaseUser currentUser) async{
    String username = Utils.getUsername(currentUser.email);

    user = User(
      uid: currentUser.uid,
      email: currentUser.email,
      name: currentUser.displayName,
      profilePhoto: currentUser.photoUrl,
      username:username
    );
    firestore.collection(USERS_COLLECTION).document(currentUser.uid).setData(user.toMap(user));
  }

  Future<void> signOut() async {
    await _googleSignIn.disconnect();
    await _googleSignIn.signOut();
    return await _auth.signOut();
  }

  Future<List<User>> fetchAllUsers(FirebaseUser currentUser) async {
    List<User> userList = List<User>();

    QuerySnapshot querySnapshot = await firestore.collection(USERS_COLLECTION).getDocuments();
    for(var i = 0; i < querySnapshot.documents.length; i++){
      if(querySnapshot.documents[i].documentID != user.uid){
        userList.add(User.fromMap(querySnapshot.documents[i].data));
      }
    }
    return userList;
  }

  Future<void> addMessageToDb(Message message, User sender, User receiver) async {
    var map = message.toMap();

    await firestore.collection(MESSAGES_COLLECTION).document(message.senderId).collection(message.receiverId).add(map);

    return await firestore.collection(MESSAGES_COLLECTION).document(message.receiverId).collection(message.senderId).add(map);
  }

  Future<String> uploadImageToStorage(File image) async {
    try{
      _storageReference = FirebaseStorage.instance.ref().child('${DateTime.now().millisecondsSinceEpoch}');

      StorageUploadTask _storageUploadTask = _storageReference.putFile(image);
      var url = await (await _storageUploadTask.onComplete).ref.getDownloadURL();
      return url;
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  void setImageMessage(String url, String receiverId, String senderId)async {
    Message _message;

    _message = Message.imageMessage(
      message: "IMAGE",
      receiverId: receiverId,
      senderId: senderId,
      timestamp: Timestamp.now(),
      photoUrl: url,
      type: 'image',
    );

    var map = _message.toImageMap();
    //Set the data to database
    await firestore.collection(MESSAGES_COLLECTION).document(_message.senderId).collection(_message.receiverId).add(map);

    await firestore.collection(MESSAGES_COLLECTION).document(_message.receiverId).collection(_message.senderId).add(map);
  }

  void uploadImage(File image, String receiverId, String senderId, ImageUploadProvider imageUploadProvider) async {
    //set some loading value to db and show it to user
    imageUploadProvider.setToLoading();
    //get url from the image bucket
    String url = await uploadImageToStorage(image);
    //hide loading
    imageUploadProvider.setToIdle();

    setImageMessage(url, receiverId, senderId);
  }

}