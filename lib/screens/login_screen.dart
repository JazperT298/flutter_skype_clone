import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterskypeclone/resources/firebase_repository.dart';
import 'package:flutterskypeclone/screens/home_screen.dart';
import 'package:flutterskypeclone/utils/universal_variables.dart';
import 'package:shimmer/shimmer.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FirebaseRepository _repository = FirebaseRepository();

  bool isLoginPressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      body: Stack(
        children: <Widget>[
          Center(
            child: loginButton(),
          ), isLoginPressed ? Center(
            child: CircularProgressIndicator(),
          ) : Container(),
        ],
      ),
    );
  }

  Widget loginButton(){
    return Shimmer.fromColors(
      baseColor: Colors.white,
      highlightColor: UniversalVariables.senderColor,
      child: FlatButton(
        padding: EdgeInsets.all(35.0),
        child: Text(
          "LOGIN",
          style: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2
          ),
        ),
        onPressed: (){
          performLogin();
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

  void performLogin(){

    setState(() {
      isLoginPressed = true;
    });

    _repository.signIn().then((FirebaseUser user){
      if (user != null){
        authenticateUser(user);
      }else{
        print("There was an error");
      }
    });
  }

  void authenticateUser(FirebaseUser user){
    _repository.authenticateUser(user).then((isNewUser){
      setState(() {
        isLoginPressed = false;
      });

      if (isNewUser){
        _repository.addDataToDb(user).then((value){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
        });
      }else{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
      }
    });
  }
}
