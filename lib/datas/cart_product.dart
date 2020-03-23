import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hawks_shop/datas/product_data.dart';

class CartProduct{

  String cartId;
  String categoryId;
  String productId;

  int amount;
  String size;

  ProductData product;

  CartProduct();

  CartProduct.fromDocument(DocumentSnapshot document){
    cartId = document.documentID;
    categoryId = document.data["categoryId"];
    productId = document.data["productId"];
    amount = document.data["amount"];
    size = document.data["size"];
  }

  Map<String, dynamic> toMap(){
    return {
      "categoryId": categoryId,
      "productId": productId,
      "amount": amount,
      "size": size,
      "product": product != null ? product.toResumedMap() : null
    };
  }
}