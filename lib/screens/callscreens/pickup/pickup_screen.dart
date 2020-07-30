import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutterskypeclone/constants/strings.dart';
import 'package:flutterskypeclone/models/call.dart';
import 'package:flutterskypeclone/models/log.dart';
import 'package:flutterskypeclone/resources/call_methods.dart';
import 'package:flutterskypeclone/resources/local_db/repository/log_repository.dart';
import 'package:flutterskypeclone/screens/callscreens/call_screen.dart';
import 'package:flutterskypeclone/screens/chat_screen/widgets/cached_image.dart';
import 'package:flutterskypeclone/utils/permissions.dart';

class PickupScreen extends StatefulWidget {
  final Call call;

  PickupScreen({
    @required this.call,
  });

  @override
  _PickupScreenState createState() => _PickupScreenState();
}

class _PickupScreenState extends State<PickupScreen> {
  final CallMethods callMethods = CallMethods();

  bool isCallMissed = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    callbackDispatcher();
  }
  void callbackDispatcher() {
    print('callbackDispatcher');

    FlutterRingtonePlayer.play(
      android: AndroidSounds.ringtone,
      ios: IosSounds.glass,
      looping: true, // Android only - API >= 28
      volume: 0.1, // Android only - API >= 28
      asAlarm: false, // Android only - all APIs
    );
  }


  addToLocalStorage({@required String callStatus}){
    Log log = Log(
      callerName: widget.call.callerName,
      callerPic: widget.call.callerPic,
      receiverName: widget.call.receiverName,
      receiverPic: widget.call.receiverPic,
      timestamp: DateTime.now().toString(),
      callStatus: callStatus
    );

    //adds the data to database
    LogRepository.addLogs(log);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if(isCallMissed) {
      addToLocalStorage(callStatus: CALL_STATUS_MISSED);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Incoming...",
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            SizedBox(height: 50),
            CachedImage(
              widget.call.callerPic,
              isRound: true,
              radius: 180,
            ),
            SizedBox(height: 15),
            Text(
              widget.call.callerName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 75),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.call_end),
                  color: Colors.redAccent,
                  onPressed: () async {
                    FlutterRingtonePlayer.stop();
                    isCallMissed = false;
                    addToLocalStorage(callStatus: CALL_STATUS_RECEIVED);
                    await callMethods.endCall(call: widget.call);
                  },
                ),
                SizedBox(width: 25),
                IconButton(
                  icon: Icon(Icons.call),
                  color: Colors.green,
                  onPressed: () async {
                    isCallMissed = false;
                    FlutterRingtonePlayer.stop();
                    addToLocalStorage(callStatus: CALL_STATUS_RECEIVED);
                    await Permissions.cameraAndMicrophonePermissionsGranted()
                        ? Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CallScreen(call: widget.call),
                      ),
                    )
                        : () {};
                  }

                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
