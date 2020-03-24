import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hawks_shop/datas/category_data.dart';

class CategoryService{

  final String  _collection = "products";
  
  Future<List<CategoryData>> getCategories() async{
    QuerySnapshot firebaseCategories = await Firestore.instance.collection(_collection).getDocuments();
    return firebaseCategories.documents.map(_firebaseCategoryToCategoryData).toList();
  }

  CategoryData _firebaseCategoryToCategoryData(DocumentSnapshot firebaseCategory){
    return CategoryData.fromFirebaseDocument(firebaseCategory);
  }

}