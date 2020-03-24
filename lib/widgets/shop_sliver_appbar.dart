import 'package:flutter/material.dart';

class ShopSliverAppBar extends StatelessWidget {

  final Widget title;

  const ShopSliverAppBar({@required this.title});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: true,
      snap: true,
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      flexibleSpace: FlexibleSpaceBar(
        title: title,
        centerTitle: true,
      ),
    );
  }
}