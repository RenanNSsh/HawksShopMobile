//Flutter
import 'package:flutter/material.dart';

//Dependencies
import 'package:flutter_svg/flutter_svg.dart';

//Project
import 'package:hawks_shop/datas/category_data.dart';
import 'package:hawks_shop/screens/category_screen.dart';

class CategoryTile extends StatelessWidget {

  final CategoryData category;

  CategoryTile(this.category);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: ListTile(
      leading: CircleAvatar(
        radius: 25.0, 
        backgroundColor: Colors.transparent, 
        child: SvgPicture.network(
          category.icon,
          placeholderBuilder: (context) => CircularProgressIndicator(),
        ),
      ),
      title: Text(category.title),
      trailing: Icon(Icons.keyboard_arrow_right),
      onTap: (){
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => CategoryScreen(category))
        );
      },
    ));
  }
}