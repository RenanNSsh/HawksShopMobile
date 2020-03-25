//Dependencies
import 'package:cloud_firestore/cloud_firestore.dart';

//Project
import 'package:hawks_shop/datas/cupon_data.dart';

class CuponService{

  final String _cuponCollection = 'cupons';

  Future<CuponData> getCupon(String cuponId) async {
    DocumentSnapshot docCupon  = await Firestore.instance.collection(_cuponCollection).document(cuponId).get();
    CuponData cuponData = _firebaseCuponToCuponData(docCupon);
    return cuponData;
  }

  CuponData _firebaseCuponToCuponData(DocumentSnapshot firebaseCupon) {
    return CuponData.fromFirebaseDocument(firebaseCupon);
  }

}