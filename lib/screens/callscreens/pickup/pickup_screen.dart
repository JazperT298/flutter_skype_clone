import 'package:flutter/material.dart';
import 'package:flutterskypeclone/models/call.dart';
import 'package:flutterskypeclone/resources/call_methods.dart';
import 'package:flutterskypeclone/screens/callscreens/call_screen.dart';

class PickupScreen extends StatelessWidget {
  final Call call;
  final CallMethods callMethods = CallMethods();

  PickupScreen({@required this.call});

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
                fontSize: 30.0
              ),
            ),
            SizedBox(
              height: 50.0,
            ),
            Image.network(
              call.callerPic,
              height: 150,
              width: 150,
            ),
            SizedBox(
              height: 15.0,
            ),
            Text(
              call.callerName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0
              ),
            ),
            SizedBox(
              height: 75.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.call_end),
                  color: Colors.redAccent,
                  onPressed: () async {
                    await callMethods.endCall(call: call);
                  },
                ),
                SizedBox(
                  width: 25.0,
                ),
                IconButton(
                  icon: Icon(Icons.call),
                  color: Colors.green,
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CallScreen(call: call))),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
