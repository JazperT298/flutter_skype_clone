import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterskypeclone/models/user.dart';
import 'package:flutterskypeclone/utils/universal_variables.dart';
import 'package:flutterskypeclone/widgets/appbar.dart';
import 'package:flutterskypeclone/widgets/custom_tile.dart';
class ChatScreen extends StatefulWidget {
  final User receiver;
  ChatScreen({this.receiver});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  TextEditingController textEditingController = TextEditingController();

  bool isWriting = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      appBar: customAppBar(context),
      body: Column(
        children: <Widget>[
          Flexible(
            child: messageList(),
          ),
          chatControls(),
        ],
      ),
    );
  }

  Widget messageList(){
    return ListView.builder(
      padding: EdgeInsets.all(10.0),
      itemCount: 6,
      itemBuilder: (context, index) {
        return chatMessageItem();
      },
    );
  }

  Widget chatMessageItem() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      child: Container(
        alignment: Alignment.centerRight,
        child: senderLayout(),
      ),
    );
  }


  Widget senderLayout() {
    Radius messageRadius = Radius.circular(10);

    return Container(
      margin: EdgeInsets.only(top: 12),
      constraints:
      BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
      decoration: BoxDecoration(
        color: UniversalVariables.senderColor,
        borderRadius: BorderRadius.only(
          topLeft: messageRadius,
          topRight: messageRadius,
          bottomLeft: messageRadius,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Text(
          "Hello",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget receiverLayout(){
    Radius messageRadius = Radius.circular(10.0);

    return Container(
      margin: EdgeInsets.only(top: 12.0),
      constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.65
      ),
      decoration: BoxDecoration(
        color: UniversalVariables.receiverColor,
        borderRadius: BorderRadius.only(
            bottomRight: messageRadius,
            topRight: messageRadius,
            bottomLeft: messageRadius
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Text(
          "Hello",
          style: TextStyle(
              color: Colors.white,
              fontSize: 16.0
          ),
        ),
      ),
    );
  }


  Widget chatControls() {
    setWritingTo(bool val){
      setState(() {
        isWriting =  val;
      });
    }
    addMediaModal(context){
      showModalBottomSheet(
          context: context,
          elevation: 0,
          backgroundColor: UniversalVariables.blackColor,
          builder: (context){
            return Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    children: <Widget>[
                      FlatButton(
                        child: Icon(
                          Icons.close,
                        ),
                        onPressed: () => Navigator.maybePop(context),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Content and tools",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: ListView(
                    children: <Widget>[
                      ModalTile(
                        title: "Media",
                        subtitle: "Share Photos and Video",
                        icon: Icons.image,
                      ),
                      ModalTile(
                        title: "File",
                        subtitle: "Share Files",
                        icon: Icons.tab,
                      ),
                      ModalTile(
                        title: "Contact",
                        subtitle: "Share Contacts",
                        icon: Icons.contacts,
                      ),
                      ModalTile(
                        title: "Location",
                        subtitle: "Share a location",
                        icon: Icons.add_location,
                      ),
                      ModalTile(
                        title: "Schedule Call",
                        subtitle: "Arrange a skype call and get reminders",
                        icon: Icons.schedule,
                      ),
                      ModalTile(
                        title: "Create Poll",
                        subtitle: "Share Poll",
                        icon: Icons.poll,
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
      );
    }
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () => addMediaModal(context),
            child: Container(
              padding: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                gradient: UniversalVariables.fabGradient,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add
              ),
            ),
          ),
          SizedBox(
            width: 5.0,
          ),
          Expanded(
            child: TextField(
              controller: textEditingController,
              style: TextStyle(
                color: Colors.white
              ),
              onChanged: (val){
                (val.length > 0 && val.trim() != "") ? setWritingTo(true) : setWritingTo(false);
              },
              decoration: InputDecoration(
                hintText: "Type a message",
                hintStyle: TextStyle(
                  color: UniversalVariables.greyColor,
                ),
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(50.0),
                  ),
                  borderSide: BorderSide.none
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 20.0, vertical: 5.0
                ),
                filled: true,
                fillColor: UniversalVariables.separatorColor,
                suffixIcon: GestureDetector(
                  onTap: () {},
                  child: Icon(
                    Icons.face
                  ),
                ),
              ),
            ),
          ),
          isWriting ? Container() : Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Icon(
                Icons.record_voice_over
            ),
          ),
          isWriting ? Container() : Icon(
            Icons.camera_alt
          ),
          isWriting ? Container(
            margin: EdgeInsets.only(left: 10.0),
            decoration: BoxDecoration(
              gradient: UniversalVariables.fabGradient,
              shape: BoxShape.circle
            ),
            child: IconButton(
              icon: Icon(
                Icons.send,
                size: 15.0,
              ),
              onPressed: () => {},
            ),
          ) : Container(),
        ],
      ),
    );
  }

  CustomAppBar customAppBar(context){
    return CustomAppBar(
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
//          color: Colors.white,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      centerTile: false,
      title: Text(
        widget.receiver.name,
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.video_call
          ),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(
              Icons.phone
          ),
          onPressed: () {},
        ),
      ],
    );
  }
}

class ModalTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const ModalTile({@required this.title, @required this.subtitle, @required this.icon});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: CustomTile(
        mini: false,
        leading: Container(
          margin: EdgeInsets.only(right: 10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: UniversalVariables.receiverColor,
          ),
          padding: EdgeInsets.all(10.0),
          child: Icon(
            icon,
            color: UniversalVariables.greyColor,
            size: 38,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: UniversalVariables.greyColor,
            fontSize: 14.0
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 18.0
          ),
        ),
      ),
    );
  }
}

