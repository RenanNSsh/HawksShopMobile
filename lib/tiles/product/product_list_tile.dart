import 'package:flutter/material.dart';
import 'package:hawks_shop/datas/product_data.dart';

class ProductListTile extends StatelessWidget {
  
  final ProductData product;
  
  const ProductListTile(this.product);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){},
      child: Card(
        child: Row(
          children: <Widget>[
            Flexible(
              flex: 1,
              child: Image.network(product.images[0],fit: BoxFit.cover, height: 250.0,),
            ),
            Flexible(
              flex: 1,
              child: Container(
                padding: EdgeInsets.all(8.0),
                
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(product.title, style: TextStyle(fontWeight: FontWeight.w500),),
                    Text("R\$ ${product.price.toStringAsFixed(2).replaceFirst('.', ',')}", style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),)
                  ],
                ),
              ),
            )
          ],
        ),
      )
    );
  }
}