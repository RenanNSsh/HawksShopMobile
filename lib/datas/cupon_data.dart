import 'package:cloud_firestore/cloud_firestore.dart';

class CuponData{
  int percent;
  String cuponCode;

  CuponData({this.percent, this.cuponCode});

  CuponData.fromMap(Map<String, dynamic> cuponMap){
    percent = cuponMap['percent'];
    cuponCode = cuponMap['cuponCode'];
  }

  factory CuponData.fromFirebaseDocument(DocumentSnapshot firebaseDocument){
    if(firebaseDocument.data != null){
      firebaseDocument.data['cuponCode'] = firebaseDocument.documentID;
      return CuponData.fromMap(firebaseDocument.data);
    }
    return null;
  }
}