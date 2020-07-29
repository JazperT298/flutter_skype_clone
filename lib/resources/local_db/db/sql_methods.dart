import 'dart:io';

import 'package:flutterskypeclone/models/log.dart';
import 'package:flutterskypeclone/resources/local_db/interface/log_interface.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqliteMethods implements LogInterface{

  Database _db;

  String databaseName = "LogDB";

  String tableName = "Call_Logs";

  //columns
  String logId = 'log_id';
  String callerName = 'caller_name';
  String callerPic = 'caller_pic';
  String receiverName = 'receiver_name';
  String receiverPic  = 'receiver_pic';
  String callStatus = 'call_status';
  String timestamp = 'timestamp';

  Future<Database> get db async {
    if (_db != null){
      return _db;
    }
    print("db was null, now waiting it");
    _db = await init();
    return _db;
  }

  @override
  init() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, databaseName);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    String createTableQuery = "CREATE TABLE $tableName ($logId INTEGER PRIMARY KEY, $callerName TEXT, $callerPic TEXT, "
        "$receiverName TEXT, $receiverPic TEXT, $callStatus TEXT, $timestamp TEXT)";

    await db.execute(createTableQuery);
    print("table created");
  }

  @override
  addLogs(Log log) async {
    var dbClient = await db;
    await dbClient.insert(tableName, log.toMap(log));
  }

  @override
  deleteLogs(int logId) async{
    var dbClient = await db;
    return await dbClient.delete(tableName, where: '$logId = ?', whereArgs: [logId]);
  }

  updateLogs(Log log) async {
    var dbClient = await db;

    await dbClient.update(
      tableName,
      log.toMap(log),
      where: '$logId = ?',
      whereArgs: [log.logId],
    );
  }

  @override
  Future<List<Log>> getLogs() async {
    try{
      var dbClient = await db;

      //List<Map> maps = await dbClient.rawQuery("SELECT * FROM $tableName");
      List<Map> maps = await dbClient.query(
        tableName,
        columns: [
          logId,
          callerName,
          callerPic,
          receiverName,
          receiverPic,
          callStatus,
          timestamp
        ]
      );

      List<Log> logList = [];

      if(maps.isNotEmpty){
        for(Map map in maps){
          logList.add(Log.fromMap(map));
        }
      }
      return logList;
    }catch(e){
      print(e);
      return null;
    }
  }

  @override
  close() async{
    var dbClient = await db;
    dbClient.close();
  }

}