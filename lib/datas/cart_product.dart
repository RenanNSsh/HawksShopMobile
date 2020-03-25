//Dependencies
import 'package:cloud_firestore/cloud_firestore.dart';

//Project
import 'package:hawks_shop/datas/product_data.dart';

class CartProduct{

  String cartId;
  String categoryId;
  String productId;

  int amount;
  String size;

  ProductData product;

  CartProduct();

  CartProduct.fromMap(Map<String, dynamic> products){
    cartId = products["cartId"];
    categoryId = products["categoryId"];
    productId = products["productId"];
    amount = products["amount"];
    product = ProductData.fromMap(Map<String, dynamic>.from(products["product"]));
    size = products["size"];

  }

  factory CartProduct.fromDocument(DocumentSnapshot document){
    document.data["cartId"] = document.documentID;
    return CartProduct.fromMap(document.data);
  }

  Map<String, dynamic> toMap(){
    return {
      "cartId": cartId,
      "categoryId": categoryId,
      "productId": productId,
      "amount": amount,
      "size": size,
      "product": product != null ? product.toResumedMap() : null
    };
  }
}