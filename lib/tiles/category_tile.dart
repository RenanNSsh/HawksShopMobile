import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hawks_shop/screens/category_screen.dart';

class CategoryTile extends StatelessWidget {

  final DocumentSnapshot snapshot;

  CategoryTile(this.snapshot);

  @override
  Widget build(BuildContext context) {
    print(snapshot.data["icon"]);
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: ListTile(
      leading: CircleAvatar(
        radius: 25.0, 
        backgroundColor: Colors.transparent, 
        child: SvgPicture.network(
          snapshot.data["icon"],
          placeholderBuilder: (context) => CircularProgressIndicator(),
        ),
      ),
      title: Text(snapshot.data["title"]),
      trailing: Icon(Icons.keyboard_arrow_right),
      onTap: (){
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => CategoryScreen(snapshot))
        );
      },
    ));
  }
}