import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hawks_shop/datas/home_data.dart';

class HomeService{

  final String _homeCollecion = "home";

  Future<List<HomeData>> getHomeData() async{
    QuerySnapshot homeDataDocList = await Firestore.instance.collection(_homeCollecion)
                                                            .orderBy("pos")
                                                            .getDocuments();
    List<HomeData> homeDataList = homeDataDocList.documents.map(_firebaseHomeToHomeData).toList();
    return homeDataList;
  }

  HomeData _firebaseHomeToHomeData(DocumentSnapshot firebaseHome){
    return HomeData.fromFirebaseDocument(firebaseHome);
  }
}