//Dependencies
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeData{
  String image;
  int x;
  int y;
  int pos;

  HomeData.fromMap(Map<String, dynamic> homeDataMap){
    image = homeDataMap['image'];
    x = homeDataMap['x'];
    y = homeDataMap['y'];
    pos = homeDataMap['pos'];
  }

  factory HomeData.fromFirebaseDocument(DocumentSnapshot firebaseDocument){
    return HomeData.fromMap(firebaseDocument.data);
  }
}