//Flutter
import 'package:flutter/material.dart';

//Project
import 'package:hawks_shop/datas/cart_product.dart';
import 'package:hawks_shop/datas/product_data.dart';
import 'package:hawks_shop/models/cart_model.dart';
import 'package:hawks_shop/services/product_service.dart';

class CartTile extends StatelessWidget {
  
  final CartProduct cartProduct;
  
  const CartTile(this.cartProduct);

  @override
  Widget build(BuildContext context) {
    final ProductService productService = ProductService();
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4.0,horizontal: 8.0),
      child: cartProduct.product.images == null ? FutureBuilder<ProductData>(
        future: productService.getProduct(categoryId: cartProduct.categoryId, productId: cartProduct.productId),
        builder: (context, snapshot){
          if(snapshot.hasData){
            cartProduct.product = snapshot.data;
            return _buildContent(context);
          }else{
            return Container(
              height: 30.0,
              child: CircularProgressIndicator(),
              alignment: Alignment.center,
            );
          }

        },
      ) : _buildContent(context)
    );
  }
  
  Widget _buildContent(BuildContext context){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 80.0,
          child: Image.network(cartProduct.product.images[0], fit: BoxFit.cover,),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  cartProduct.product.title,
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17.0),
                ),
                Text(
                  "Tamanho: ${cartProduct.size}",
                  style: TextStyle(
                    fontWeight: FontWeight.w300
                  ),
                ),
                Text(
                  "R\$ ${cartProduct.product.price.toStringAsFixed(2)}",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.remove),
                      color: Theme.of(context).primaryColor,
                      onPressed: cartProduct.amount > 1 ? (){
                        CartModel.of(context).decProduct(cartProduct);
                      } : null,
                    ),
                    Text(cartProduct.amount.toString()),
                    IconButton(
                      icon: Icon(Icons.add),
                      color: Theme.of(context).primaryColor,
                      onPressed: (){
                        CartModel.of(context).incProduct(cartProduct);

                      },
                    ),
                    FlatButton(
                      child: Text("Remover"),
                      textColor: Colors.grey[500],
                      onPressed: (){
                        CartModel.of(context).removeCartItem(cartProduct);
                      },
                    )
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}