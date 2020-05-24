import 'package:flutterskypeclone/models/user.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterskypeclone/resources/auth_methods.dart';

class UserProvider with ChangeNotifier {
  User _user;
  AuthMethods _authMethods = AuthMethods();

  User get getUser => _user;
  //wait for this function to finish its execution inside the post frame callback with the help of await keyboard
  Future<void> refreshUser() async {
    //fetch the user details asynchronously which means user class object is initially null until the user details are fully fetch
    User user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }

}