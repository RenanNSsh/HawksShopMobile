import 'package:flutter/material.dart';
import 'package:hawks_shop/datas/category_data.dart';
import 'package:hawks_shop/services/category_service.dart';
import 'package:hawks_shop/tiles/category_tile.dart';

class ProductTab extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final CategoryService categoryService = CategoryService();
    return FutureBuilder<List<CategoryData>>(
      future: categoryService.getCategories(),
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