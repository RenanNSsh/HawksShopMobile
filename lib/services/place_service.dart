//Dependencies
import 'package:cloud_firestore/cloud_firestore.dart';

//Project
import 'package:hawks_shop/datas/place_data.dart';

class PlaceService{

  final String _placesCollection = "places";

  Future<List<PlaceData>> getPlaces() async{
    QuerySnapshot placesDoc = await Firestore.instance.collection(_placesCollection).getDocuments();
    List<PlaceData> places = placesDoc.documents.map(_firebasePlaceToPlaceData).toList();
    return places;
  }

  PlaceData _firebasePlaceToPlaceData(DocumentSnapshot firebasePlace){
    return PlaceData.fromFirebaseDocument(firebasePlace);
  }
}