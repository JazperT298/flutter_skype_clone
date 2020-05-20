import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterskypeclone/resources/firebase_repository.dart';
import 'package:flutterskypeclone/screens/home_screen.dart';
import 'package:flutterskypeclone/screens/login_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

//    Firestore.instance.collection("users").document().setData({
//      "name":"metalman"
//    });

    FirebaseRepository _repository = FirebaseRepository();
    return MaterialApp(
      title: "Skype Clone",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
        future: _repository.getCurrentUser(),
        builder: (context, AsyncSnapshot<FirebaseUser> snapshot){
          if (snapshot.hasData){
            return HomeScreen();
          }else{
            return LoginScreen();
          }
        },
      ),
    );
  }
}
