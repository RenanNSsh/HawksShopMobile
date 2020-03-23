import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hawks_shop/datas/product_data.dart';
import 'package:hawks_shop/tiles/product/product_grid_tile.dart';
import 'package:hawks_shop/tiles/product/product_list_tile.dart';

class CategoryScreen extends StatelessWidget {

  const CategoryScreen(this.snapshot);

  final DocumentSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(snapshot.data["title"]),
          centerTitle: true,
          bottom: TabBar(
            tabs: <Widget>[
              Tab(icon: Icon(Icons.grid_on),),
              Tab(icon: Icon(Icons.list),)
            ],
          ),
        ),
        body: FutureBuilder<QuerySnapshot>(
          future: Firestore.instance.collection("products").document(snapshot.documentID).collection("items").getDocuments(),
          builder: (context, snapshot){
            if(!snapshot.hasData){
              return Center(child: CircularProgressIndicator(),);
            }
            return TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                snapshot.data.documents.length != 0 ? GridView.builder(
                  padding: EdgeInsets.all(4.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 4.0,
                    crossAxisSpacing: 4.0,
                    childAspectRatio: 0.65
                  ),
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index){
                      ProductData productData = ProductData.fromFirebaseDocument(snapshot.data.documents[index]);
                      productData.category = this.snapshot.documentID;
                      return ProductGridTile(productData);
                    
                  }
                ): Center(child: Text("Não há nenhum item desta categoria no momento", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15.0),)),
                snapshot.data.documents.length != 0 ?ListView.builder(
                  padding: EdgeInsets.all(4.0),
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index){
                    ProductData productData = ProductData.fromFirebaseDocument(snapshot.data.documents[index]);
                    productData.category = this.snapshot.documentID;
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