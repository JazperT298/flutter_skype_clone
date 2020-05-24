import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterskypeclone/models/contact.dart';
import 'package:flutterskypeclone/provider/user_provider.dart';
import 'package:flutterskypeclone/resources/auth_methods.dart';
import 'package:flutterskypeclone/resources/chat_methods.dart';
import 'package:flutterskypeclone/screens/callscreens/pickup/pickup_layout.dart';
import 'package:flutterskypeclone/screens/pageviews/widgets/cantact_view.dart';
import 'package:flutterskypeclone/screens/pageviews/widgets/new_chat_button.dart';
import 'package:flutterskypeclone/screens/pageviews/widgets/quite_box.dart';
import 'package:flutterskypeclone/screens/pageviews/widgets/user_circle.dart';
import 'package:flutterskypeclone/utils/universal_variables.dart';
import 'package:flutterskypeclone/utils/utilities.dart';
import 'package:flutterskypeclone/widgets/appbar.dart';
import 'package:flutterskypeclone/widgets/custom_tile.dart';
import 'package:provider/provider.dart';

class ChatListScreen extends StatelessWidget {
  CustomAppBar customAppBar(BuildContext context) {
    return CustomAppBar(
      leading: IconButton(
        icon: Icon(
          Icons.notifications,
          color: Colors.white,
        ),
        onPressed: () {},
      ),
      title: UserCircle(),
      centerTitle: true,
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.search,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushNamed(context, "/search_screen");
          },
        ),
        IconButton(
          icon: Icon(
            Icons.more_vert,
            color: Colors.white,
          ),
          onPressed: () {},
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: Scaffold(
        backgroundColor: UniversalVariables.blackColor,
        appBar: customAppBar(context),
        floatingActionButton: NewChatButton(),
        body: ChatListContainer(),
      ),
    );
  }
}

class ChatListContainer extends StatelessWidget {
  final ChatMethods _chatMethods = ChatMethods();

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return Container(
      child: StreamBuilder<QuerySnapshot>(
          stream: _chatMethods.fetchContacts(
            userId: userProvider.getUser.uid,
          ),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var docList = snapshot.data.documents;

              if (docList.isEmpty) {
                return QuietBox();
              }
              return ListView.builder(
                padding: EdgeInsets.all(10),
                itemCount: docList.length,
                itemBuilder: (context, index) {
                  Contact contact = Contact.fromMap(docList[index].data);

                  return ContactView(contact);
                },
              );
            }

            return Center(child: CircularProgressIndicator());
          }),
    );
  }
}