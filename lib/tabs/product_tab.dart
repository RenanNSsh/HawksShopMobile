//Flutter
import 'package:flutter/material.dart';

//Project
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
        var tiles = snapshot.data.map(_categoryDataToTile).toList();
        return ListView(children: _dividedTiles(tiles:tiles));
      },
    );
  }
  
  CategoryTile _categoryDataToTile(CategoryData data){
    return CategoryTile(data);
  }

  List<Widget> _dividedTiles({List<Widget> tiles}){
    return ListTile.divideTiles(
      tiles: tiles,
      color: Colors.red
    ).toList();
  }
}