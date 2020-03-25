//Dependencies
import 'package:cloud_firestore/cloud_firestore.dart';

//Project
import 'package:hawks_shop/datas/cart_product.dart';

class OrderData{

  String id;
  String clientID;
  List<CartProduct> products;
  double shipPrice;
  double discount;
  double totalPrice;
  int status;
  
  OrderData();

  factory OrderData.fromFirebaseDocument(DocumentSnapshot firebaseDocument){
    firebaseDocument.data["id"] = firebaseDocument.documentID;
    return OrderData.fromMap(firebaseDocument.data);
  }

  OrderData.fromMap(Map<String, dynamic> orderMap){
    id = orderMap["id"];
    clientID = orderMap["clientID"];
    products = orderMap["products"]
                      .map((productMap) => CartProduct.fromMap(Map<String, dynamic>.from(productMap)))
                                                      .toList()
                                                      .cast<CartProduct>(); 
    shipPrice = orderMap["shipPrice"];
    discount = orderMap["discount"];
    totalPrice = orderMap["totalPrice"];
    status = orderMap["status"];
  }

  Map<String, dynamic> toMap(){
    return  {
        "clientID": clientID,
        "products": products.map((product) => product.toMap()).toList(),
        "shipPrice": shipPrice,
        "discount": discount,
        "totalPrice": totalPrice,
        "status": status
      };
  }
}