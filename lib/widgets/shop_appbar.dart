//Flutter
import 'package:flutter/material.dart';

class ShopAppBar extends StatelessWidget implements PreferredSizeWidget{

  final Widget title;

  const ShopAppBar({this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      title: title,
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}