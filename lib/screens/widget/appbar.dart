import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color backgroundColor;
  final List<Widget> actions;

  const CustomAppBar({
    required this.title,
    this.backgroundColor = Colors.blue,
    this.actions = const [],
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: Text(title, style: TextStyle(
          color: Colors.black,
        ),),
        // icon
        backgroundColor: Colors.green,
        leading: Image(
          image: AssetImage("images/parking.png"),
        ),
      //  actions be null
        actions: actions.isEmpty ? null : actions,
        
      );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}