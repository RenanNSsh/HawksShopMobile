import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hawks_shop/tiles/category_tile.dart';

class ProductTab extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: Firestore.instance.collection("products").getDocuments(),
      builder: (context, snapshot){
        if(!snapshot.hasData){
          return Center(child: CircularProgressIndicator(),);
        }
        var dividedTiles = ListTile.divideTiles(tiles: snapshot.data.documents.map(
            (document){
              return CategoryTile(document);
            }
          ).toList(),
          color: Colors.grey
        ).toList();
        return ListView(
          children: dividedTiles
        );
      },
    );
  }
}