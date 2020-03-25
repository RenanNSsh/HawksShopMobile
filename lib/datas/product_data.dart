//Dependencies
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductData {

  String category;
  String id;

  String title;
  String description;
  double price;

  List images;
  List sizes;

  ProductData.fromMap(Map<String, dynamic> productMap){
    id = productMap["id"];
    title = productMap["title"];
    description = productMap["description"];
    price = productMap["price"] != null ? double.parse(productMap["price"].toString()) : null;
    images = productMap["images"];
    sizes = productMap["sizes"];
  }

  factory ProductData.fromFirebaseDocument(DocumentSnapshot document){
    document.data["id"] = document.documentID;
    return ProductData.fromMap(document.data);
  }

  Map<String, dynamic> toResumedMap() {
    return {
      "title": title,
      "description": description,
      "price": price
    };
  }
}