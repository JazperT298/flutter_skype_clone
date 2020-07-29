import 'package:flutterskypeclone/models/log.dart';
import 'package:flutterskypeclone/resources/local_db/interface/log_interface.dart';

class HiveMethods implements LogInterface{
  @override
  addLogs(Log log) {
    // TODO: implement addLogs
    print("Adding values to hive db");
    return null;
  }

  @override
  close() {
    // TODO: implement close
    return null;
  }

  @override
  deleteLogs(int logId) {
    // TODO: implement deleteLogs
    return null;
  }

  @override
  Future<List<Log>> getLogs() {
    // TODO: implement getLogs
    return null;
  }

  @override
  init() {
    // TODO: implement init
    print("Initialized hive db");
    return null;
  }

}