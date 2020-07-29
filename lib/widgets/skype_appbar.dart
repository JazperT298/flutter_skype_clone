import 'package:flutter/material.dart';
import 'package:flutterskypeclone/widgets/appbar.dart';

class SkypeAppBar extends StatelessWidget implements PreferredSizeWidget{
  final dynamic title;
  final List<Widget> actions;

  const SkypeAppBar({Key key, @required this.title, @required this.actions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      leading: IconButton(
        icon: Icon(
          Icons.notifications,
          color: Colors.white,
        ),
        onPressed: (){},
      ),
      centerTitle: true,
      title: title is String
        ? Text(
          title,
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold
          ),
      ) : title,  actions: actions,
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 10);
}
