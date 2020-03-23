import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserDAO{

  final String _userCollection = "users";

  Future<Map<String, dynamic>> getUser({@required String userId}) async{
     DocumentSnapshot docUser = await Firestore.instance.collection(_userCollection)
                                                        .document(userId)
                                                        .get();
     return docUser.data;
  }

  Future<Null> saveUserData({@required String userId,@required Map<String, dynamic> userData}) {
    return Firestore.instance.collection(_userCollection)
                             .document(userId)
                             .setData(userData);
  }
}