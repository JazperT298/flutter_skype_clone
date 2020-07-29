import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterskypeclone/models/log.dart';
import 'package:flutterskypeclone/resources/local_db/repository/log_repository.dart';
import 'package:flutterskypeclone/utils/universal_variables.dart';

class LogScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      body: Center(
        child: FlatButton(
          child: Text(
            "Click Me"
          ),
          onPressed: () {
            LogRepository.init(isHive: true);
            LogRepository.addLogs(Log());
          },
        ),
      ),
    );
  }

}