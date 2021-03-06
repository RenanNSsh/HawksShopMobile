import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hawks_shop/datas/order_data.dart';

class OrderService{

  final String _orderCollection = "orders";

  Future<String> addOrder({@required OrderData orderData}) async{
    DocumentReference orderRef = await Firestore.instance.collection(_orderCollection)
                                                          .add(orderData.toMap());
    return orderRef.documentID;
  }

  Stream<OrderData> getStreamOrder({String orderId}) {
    Stream<DocumentSnapshot> firebaseOrders = Firestore.instance.collection("orders")
                                                                      .document(orderId)
                                                                      .snapshots();
    Stream<OrderData> ordersData = firebaseOrders.map(_firebaseOrderToOrderData);
    return ordersData;                         
  }

  OrderData _firebaseOrderToOrderData(DocumentSnapshot firebaseOrder){
    return OrderData.fromFirebaseDocument(firebaseOrder);
  }
}