import 'package:flutter/material.dart';
import 'package:hawks_shop/models/cart_model.dart';
import 'package:hawks_shop/models/user_model.dart';
import 'package:hawks_shop/screens/login_screen.dart';
import 'package:hawks_shop/screens/order_screen.dart';
import 'package:hawks_shop/tiles/cart_tile.dart';
import 'package:hawks_shop/widgets/cart_price.dart';
import 'package:hawks_shop/widgets/discount_card.dart';
import 'package:hawks_shop/widgets/ship_card.dart';
import 'package:scoped_model/scoped_model.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meu carrinho"),
        actions: <Widget>[
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(right: 8.0),
            child: ScopedModelDescendant<CartModel>(
              builder: (context,child, model){
                int productsAmount = model.products != null ? model.products.length : 0;
                return Text(
                  "${productsAmount ?? 0} ${productsAmount == 1 ? "ITEM" : "ITENS"}",style: TextStyle(fontSize: 17.0),
                );
              },
            ),
          )  
        ],
      ),
      body: ScopedModelDescendant<CartModel>(
        builder: (context,child, model){
          if(model.isLoading && UserModel.of(context).isLoggedIn()){
            return Center(child: CircularProgressIndicator(),);
          }
          if(!UserModel.of(context).isLoggedIn()){
            return Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Icon(Icons.remove_shopping_cart, size: 80.0, color: Theme.of(context).primaryColor,),
                  SizedBox(height: 16.0,),
                  Text("Faça o login para adicionar produtos!",style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                  SizedBox(height: 16.0,),
                  RaisedButton(
                    child: Text("Entrar", style: TextStyle(fontSize: 18.0)),
                    textColor: Colors.white,
                    color: Theme.of(context).primaryColor,
                    onPressed: (){
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => LoginScreen() )
                      );
                    },
                  )
                ],
              ),
            );
          }
          if(model.products == null || model.products.length == 0){
            return Center(child: Text("Nenhum produto no carrinho!",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),textAlign: TextAlign.center,),);
          }
          return ListView(
            children: <Widget>[
              Column(
                children: model.products.map((product){
                  return CartTile(product);
                }).toList(),
              ),
              DiscountCard(),
              ShipCard(),
              CartPrice(() async{
                String orderId = await model.finishOrder();
                if(orderId != null){
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> OrderScreen(orderId)));
                }else{
                  Scaffold.of(context).showSnackBar(SnackBar(content: Text("Ocorreu um erro ao finalizar o pedido"),backgroundColor: Colors.redAccent,));
                }
              })
            ],
          );
        },
      ),
    );
  }
}