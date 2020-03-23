import 'package:flutter/material.dart';
import 'package:hawks_shop/dao/category_dao.dart';
import 'package:hawks_shop/datas/category_data.dart';
import 'package:hawks_shop/tiles/category_tile.dart';

class ProductTab extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final CategoryDAO categoryDAO = CategoryDAO();
    return FutureBuilder<List<CategoryData>>(
      future: categoryDAO.getCategories(),
      builder: (context, snapshot){
        if(!snapshot.hasData){
          return Center(child: CircularProgressIndicator(),);
        }
        var dividedTiles = ListTile.divideTiles(tiles: snapshot.data.map(
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