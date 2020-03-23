import 'package:flutter/material.dart';
import 'package:hawks_shop/datas/product_data.dart';
import 'package:hawks_shop/screens/product_screen.dart';

class ProductGridTile extends StatelessWidget {

  final ProductData product;
  
  const ProductGridTile(this.product);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => ProductScreen(product))
        );
      },
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 0.8,
              child: Image.network(
                product.images[0],
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Text(product.title, style: TextStyle(fontWeight: FontWeight.w500),),
                    Text("R\$ ${product.price.toStringAsFixed(2).replaceFirst('.', ',')}", style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}