import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hawks_shop/datas/cart_product.dart';

class CartService{

  final String _userCollection = "users";
  final String _cartCollection = "cart";

  Future<String> addCartItem({@required String userId, @required CartProduct cartProduct}) async{
    DocumentReference firebaseProduct = await Firestore.instance.collection(_userCollection)
              .document(userId)
              .collection(_cartCollection)
              .add(cartProduct.toMap());
    return firebaseProduct.documentID;
  }

  Future<void> updateProduct({@required String userId, @required CartProduct cartProduct}) {
    return Firestore.instance.collection(_userCollection)
             .document(userId)
             .collection(_cartCollection)
             .document(cartProduct.cartId)
             .updateData(cartProduct.toMap());
  }

  Future<void> removeProduct({@required String userId, @required CartProduct cartProduct}) {
    return Firestore.instance.collection(_userCollection)
             .document(userId)
             .collection(_cartCollection)
             .document(cartProduct.cartId).delete();
  }

  Future<List<CartProduct>> getProducts({@required String userId}) async{
    QuerySnapshot docProducts = await _getDocProducts(userId: userId);
    List<CartProduct> products = docProducts.documents.map(_cartProductFromFirebaseDocument).toList();
    return products;
  }

  Future<QuerySnapshot> _getDocProducts({@required String userId}) {
    return Firestore.instance.collection(_userCollection)
                              .document(userId)
                              .collection(_cartCollection)
                              .getDocuments();
  }

  CartProduct _cartProductFromFirebaseDocument(DocumentSnapshot firebaseDocument){
    return CartProduct.fromDocument(firebaseDocument);
  }

  Future<void> removeProducts({@required String userId}) async{
    QuerySnapshot products = await _getDocProducts(userId: userId);
    for(DocumentSnapshot product in products.documents){
      product.reference.delete();
    }
  }

  
}