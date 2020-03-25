//Flutter
import 'package:flutter/material.dart';

//Dependencies
import 'package:carousel_pro/carousel_pro.dart';

//Project
import 'package:hawks_shop/datas/cart_product.dart';
import 'package:hawks_shop/datas/product_data.dart';
import 'package:hawks_shop/models/cart_model.dart';
import 'package:hawks_shop/models/user_model.dart';
import 'package:hawks_shop/screens/cart_screen.dart';
import 'package:hawks_shop/screens/login_screen.dart';

class ProductScreen extends StatefulWidget {

  final ProductData product;

  ProductScreen(this.product);

  @override
  _ProductScreenState createState() => _ProductScreenState(product);
}

class _ProductScreenState extends State<ProductScreen> {

  final ProductData product;
  String size;
  _ProductScreenState(this.product);

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: ListView(
        children: <Widget>[
          AspectRatio(aspectRatio: 1.0,
            child: Carousel(
              autoplay: false,
              dotSize: 5.0,
              dotSpacing: 15.0,
              dotColor: primaryColor,
              dotBgColor: Colors.transparent,
              images: product.images.map((imageURL){
                return NetworkImage(imageURL);
              }).toList(),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  product.title,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500
                  ),
                  maxLines: 3,
                ),
                Text(
                  "R\$ ${product.price.toStringAsFixed(2).replaceFirst('.', ',')}",
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: primaryColor
                  ),
                ),
                SizedBox(height: 16.0,),
                Text("Tamanho",style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500
                ),),
                SizedBox(
                  height: 34.0,
                  child: GridView(
                    padding: EdgeInsets.symmetric(vertical: 4.0),
                    scrollDirection: Axis.horizontal,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisSpacing: 8.0,
                      childAspectRatio: 0.5
                    ),
                    children: product.sizes.map((size){
                      return GestureDetector(
                        onTap: (){
                          setState(() {
                            this.size = size;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(4.0)),
                            border: Border.all(color: size == this.size? primaryColor : Colors.grey[500], width: 3.0)
                          ),
                          width: 50.0,
                          alignment: Alignment.center,
                          child: Text(size),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 16.0,),
                SizedBox(height: 44.0,child: RaisedButton(
                  onPressed: size != null ? (){
                    if(UserModel.of(context).isLoggedIn()){
                      CartProduct cartProduct = CartProduct();
                      cartProduct.size = size;
                      cartProduct.amount = 1;
                      cartProduct.productId = product.id;
                      cartProduct.product = product;
                      cartProduct.categoryId = product.category;

                      CartModel.of(context).addCartItem(cartProduct);
                      
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => CartScreen())
                      );
                    }else{
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => LoginScreen())
                      );
                    }
                  } : null,
                  textColor: Colors.white,
                  color: primaryColor,
                  child: Text(UserModel.of(context).isLoggedIn() ? "Adicionar ao Carrinho" : "Entre para comprar", style: TextStyle(fontSize: 18.0),),
                ),),
                SizedBox(height: 16.0,),
                Text("Descrição",style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold
                ),),
                Text(
                  product.description,
                  style: TextStyle(
                    fontSize: 16.0
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}