import 'package:flutter/material.dart';

class DrawerTile extends StatelessWidget {

  final IconData icon;
  final String text;
  final PageController pageController;
  final int page;

  const DrawerTile(this.icon, this.text, this.pageController,this.page);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: (){
          Navigator.of(context).pop();
          pageController.jumpToPage(page);
        },
        child: Container(
          height: 60.0,
          child: Row(
            children: <Widget>[
              Icon(icon,color:  page == pageController.page.round() ? Colors.white : Colors.black, size: 32.0,),
              SizedBox(width: 32.0),Text(text, style: TextStyle(fontSize: 16.0, color: page == pageController.page.round() ? Colors.white : Colors.black)),
            ],
          )
        )
      ),
    );
  }
}