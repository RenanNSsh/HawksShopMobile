import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hawks_shop/datas/user_data.dart';

class UserService{

  final String _userCollection = "users";
  final String _orderCollection = "orders";

  Future<UserData> getUser({@required String userId}) async{
    DocumentSnapshot docUser = await Firestore.instance.collection(_userCollection)
                                                        .document(userId)
                                                        .get();
    UserData user =  UserData.fromFirebaseDocument(docUser);
    return user;
  }

  Future<void> saveUserData(UserData userData) {
    Map<String, dynamic> userMap = userData.toMap();
    return Firestore.instance.collection(_userCollection)
                             .document(userData.id)
                             .setData(userMap);
  }

  Future<void> saveOrder({@required String userId, @required String orderId}){
    return Firestore.instance.collection(_userCollection).document(userId)
                             .collection(_orderCollection).document(orderId).setData({
                                "orderId": orderId
                              });
  }

  Future<List<String>> getOrders({@required String userId}) async{
    QuerySnapshot firebaseOrders = await Firestore.instance.collection(_userCollection)
                                                     .document(userId)
                                                     .collection(_orderCollection)
                                                     .getDocuments();
    List<String> ordersIds = firebaseOrders.documents.map(_firebaseOrderToOrderData).toList();
    return ordersIds;
  }

  String _firebaseOrderToOrderData(DocumentSnapshot firebaseOrder){
    return firebaseOrder.data["orderId"];
  }
  
}