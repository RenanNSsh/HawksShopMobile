import 'package:cloud_firestore/cloud_firestore.dart';

class PlaceData{

  String image;
  String title;
  String phone;
  String address;
  double latitude;
  double longitude;

  PlaceData.fromMap(Map<String, dynamic> placeMap){
    image = placeMap['image'];
    title = placeMap['title'];
    phone = placeMap['phone'];
    address = placeMap['address'];
    latitude = placeMap['latitude'];
    longitude = placeMap['longitude'];
  }

  factory PlaceData.fromFirebaseDocument(DocumentSnapshot firebasePlace) {
    return PlaceData.fromMap(firebasePlace.data);
  }
  
}