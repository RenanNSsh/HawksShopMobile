import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hawks_shop/datas/product_data.dart';

class ProductService{

  final String _categoryCollection = "products";
  final String _productCollection = "items";
  
  Future<List<ProductData>> getProducts(String categoryId) async{
    QuerySnapshot firebaseProducts = await Firestore.instance.collection(_categoryCollection)
                                                    .document(categoryId)
                                                    .collection(_productCollection)
                                                    .getDocuments();
                                                  
    List<ProductData> products = firebaseProducts.documents.map(_firebaseProductToProductData).toList();
    return products;
  }

  ProductData _firebaseProductToProductData(DocumentSnapshot firebaseProduct){
    return ProductData.fromFirebaseDocument(firebaseProduct);
  }

  Future<ProductData> getProduct({@required String categoryId, @required String productId}) async{
    DocumentSnapshot firebaseProduct = await Firestore.instance.collection(_categoryCollection)
                                                               .document(categoryId)
                                                               .collection(_productCollection)
                                                               .document(productId)
                                                               .get();
    return _firebaseProductToProductData(firebaseProduct);
  }
}