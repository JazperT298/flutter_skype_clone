import 'package:flutter/material.dart';
import 'package:flutterskypeclone/models/contact.dart';
import 'package:flutterskypeclone/models/user.dart';
import 'package:flutterskypeclone/provider/user_provider.dart';
import 'package:flutterskypeclone/resources/auth_methods.dart';
import 'package:flutterskypeclone/resources/chat_methods.dart';
import 'package:flutterskypeclone/screens/chat_screen/chat_screen.dart';
import 'package:flutterskypeclone/screens/chat_screen/widgets/cached_image.dart';
import 'package:flutterskypeclone/screens/pageviews/chats/widgets/online_dot_indicator.dart';
import 'package:flutterskypeclone/utils/universal_variables.dart';
import 'package:flutterskypeclone/widgets/custom_tile.dart';
import 'package:provider/provider.dart';

import 'last_message_container.dart';

class ContactView extends StatelessWidget {
  final Contact contact;
  final AuthMethods _authMethods = AuthMethods();

  ContactView(this.contact);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: _authMethods.getUserDetailsById(contact.uid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          User user = snapshot.data;

          return ViewLayout(
            contact: user,
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class ViewLayout extends StatelessWidget {
  final User contact;
  final ChatMethods _chatMethods = ChatMethods();

  ViewLayout({
    @required this.contact,
  });

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return CustomTile(
      mini: false,
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              receiver: contact,
            ),
          )),
      title: Text(
        //?. = Conditional Member Access Operator
        //contact?.name the same as contact != null ? contact.name : null

        //?? = If Null Operator
        //contact.name ?? ".." the same as contact.name != null ? contact.name : ".."

        (contact != null ? contact.name : null) != null ? contact.name : "..",
        style:
        TextStyle(color: Colors.white, fontFamily: "Arial", fontSize: 19),
      ),
      subtitle: LastMessageContainer(
        stream: _chatMethods.fetchLastMessageBetween(
          senderId: userProvider.getUser.uid,
          receiverId: contact.uid,
        ),
      ),
      leading: Container(
        constraints: BoxConstraints(maxHeight: 60, maxWidth: 60),
        child: Stack(
          children: <Widget>[
            CachedImage(
              contact.profilePhoto,
              radius: 80,
              isRound: true,
            ),
            OnlineDotIndicator(
              uid: contact.uid,
            ),
          ],
        ),
      ),
    );
  }
}
