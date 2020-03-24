import 'package:flutter/material.dart';
import 'package:hawks_shop/datas/category_data.dart';
import 'package:hawks_shop/datas/product_data.dart';
import 'package:hawks_shop/services/product_service.dart';
import 'package:hawks_shop/tiles/product/product_grid_tile.dart';
import 'package:hawks_shop/tiles/product/product_list_tile.dart';

class CategoryScreen extends StatelessWidget {

  final CategoryData category; 
  CategoryScreen(this.category);


  @override
  Widget build(BuildContext context) {
    final ProductService productService = ProductService();
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(category.title),
          centerTitle: true,
          bottom: TabBar(
            tabs: <Widget>[
              Tab(icon: Icon(Icons.grid_on),),
              Tab(icon: Icon(Icons.list),)
            ],
          ),
        ),
        body: FutureBuilder<List<ProductData>>(
          future: productService.getProducts(category.id),
          builder: (context, snapshot){
            if(!snapshot.hasData){
              return Center(child: CircularProgressIndicator(),);
            }
            return TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                snapshot.data.length != 0 ? GridView.builder(
                  padding: EdgeInsets.all(4.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 4.0,
                    crossAxisSpacing: 4.0,
                    childAspectRatio: 0.65
                  ),
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index){
                      ProductData productData = snapshot.data[index];
                      productData.category = category.id;
                      return ProductGridTile(productData);
                  }
                ): Center(child: Text("Não há nenhum item desta categoria no momento", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15.0),)),
                snapshot.data.length != 0 ? ListView.builder(
                  padding: EdgeInsets.all(4.0),
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index){
                    ProductData productData = snapshot.data[index];
                    productData.category = category.id;
                    return ProductListTile(productData);
                }): Center(child: Text("Não há nenhum item desta categoria no momento", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15.0),)),
              ],
            );
          },
        ) 
        
      ),
    );
  }
}