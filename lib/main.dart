import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterskypeclone/provider/image_upload_provider.dart';
import 'package:flutterskypeclone/provider/user_provider.dart';
import 'package:flutterskypeclone/resources/firebase_repository.dart';
import 'package:flutterskypeclone/screens/home_screen.dart';
import 'package:flutterskypeclone/screens/login_screen.dart';
import 'package:flutterskypeclone/screens/search_screen.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseRepository _repository = FirebaseRepository();
  @override
  Widget build(BuildContext context) {

//    Firestore.instance.collection("users").document().setData({
//      "name":"metalman"
//    });

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ImageUploadProvider(),),
        ChangeNotifierProvider(create: (_) => UserProvider(),)
      ],
      child: MaterialApp(
        title: "Skype Clone",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          //primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/search_screen': (context) => SearchScreen(),
        },
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
      ),
    );
  }
}
