//Dependencies
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryData{
  String id;
  String icon;
  String title;

  CategoryData.fromFirebaseDocument(DocumentSnapshot firebaseDoc){
    icon = firebaseDoc.data["icon"];
    title = firebaseDoc.data["title"];
    id = firebaseDoc.documentID;
  }
}