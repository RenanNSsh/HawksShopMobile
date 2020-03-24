import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserData{
  String id;
  String name;
  String address;
  String email;

  UserData.fromMap(Map<String,dynamic> userMap){
    id = userMap['id'];
    name = userMap['name'];
    email = userMap['email'];
    address = userMap['address'];
  }

  factory UserData.fromFirebaseDocument(DocumentSnapshot userDocument){
    userDocument.data['id'] = userDocument.documentID;
    return UserData.fromMap(userDocument.data);
  }

  UserData.fromFirebaseUser(FirebaseUser user) {
    if(user != null){
      id = user.uid;
      
    }
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "email": email,
      "address": address
    };
  }
}