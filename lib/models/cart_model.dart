import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hawks_shop/datas/cart_product.dart';
import 'package:hawks_shop/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model{

  UserModel user;
  bool isLoading = false;

  String cuponCode;
  int discountPercentage = 0;

  List<CartProduct> products;

  CartModel(this.user){
    _loadCartItens();
  }

  static CartModel of(BuildContext context){
    return ScopedModel.of<CartModel>(context);
  }

  @override
  void addListener(listener) {
    super.addListener(listener);
    _loadCartItens();
  }

  void _loadCartItens() async{
    if(products == null && user.isLoggedIn()){
       QuerySnapshot docProducts = await Firestore.instance.collection("users")
                                                  .document(user.firebaseUser.uid)
                                                  .collection("cart")
                                                  .getDocuments();
      products = docProducts.documents.map((docProduct){
        return CartProduct.fromDocument(docProduct);
      }).toList();
      notifyListeners();
    }
  }

  void addCartItem(CartProduct cartProduct) async {
    try{
      CartProduct existingCartProduct = products.firstWhere((element )=>  element.productId == cartProduct.productId && element.size == cartProduct.size);
      await incProduct(existingCartProduct);
    }catch(IterableElementError){
      products.add(cartProduct);
      await Firestore.instance.collection("users")
              .document(user.firebaseUser.uid)
              .collection("cart")
              .add(cartProduct.toMap()).then((doc){
                cartProduct.cartId = doc.documentID;
              });
      notifyListeners();
    }
  }

  void removeCartItem(CartProduct cartProduct)async {
    await Firestore.instance.collection("users")
             .document(user.firebaseUser.uid)
             .collection("cart")
             .document(cartProduct.cartId).delete();
    products.remove(cartProduct);
    notifyListeners();
  }

  void decProduct(CartProduct cartProduct) {
    cartProduct.amount--;
    Firestore.instance.collection("users")
             .document(user.firebaseUser.uid)
             .collection("cart")
             .document(cartProduct.cartId)
             .updateData(cartProduct.toMap());
    notifyListeners();
  }

  void setCupom(String couponCode, int discountPercentage){
    this.cuponCode = couponCode;
    this.discountPercentage = discountPercentage;
  }

  void incProduct(CartProduct cartProduct) async{
    cartProduct.amount++;
    await Firestore.instance.collection("users")
             .document(user.firebaseUser.uid)
             .collection("cart")
             .document(cartProduct.cartId)
             .updateData(cartProduct.toMap());
    notifyListeners();
  }

  double getProductsPrice(){ 
    double price = 0.0; 
    for(CartProduct cartProduct in products){
      if(cartProduct.product != null){
        price += cartProduct.product.price * cartProduct.amount;
      }
    }
    return price;
  }

  double getDiscount(){
    double discount = getProductsPrice() * discountPercentage / 100;
    notifyListeners();
    return discount;

  }

  double getShipPrice(){
    return 9.99;
  }

  Future<String> finishOrder() async{
    if(products.length == 0) return null;

    isLoading = true;

    double productsPrice = getProductsPrice();
    double shipPrice = getShipPrice();
    double discount = getDiscount();

    DocumentReference refOrder = await Firestore.instance.collection("orders").add(
      {
        "clientID": user.firebaseUser.uid,
        "products": products.map((cartProduct) => cartProduct.toMap()).toList(),
        "shipPrice": shipPrice,
        "discount": discount,
        "totalPrice": productsPrice - discount + shipPrice,
        "status": 1
      }
    );

    await Firestore.instance.collection("users").document(user.firebaseUser.uid)
             .collection("orders").document(refOrder.documentID).setData(
              {
                "orderId": refOrder.documentID
              });
    QuerySnapshot query = await Firestore.instance.collection("users").document(user.firebaseUser.uid).collection("cart").getDocuments();

    for(DocumentSnapshot doc in query.documents){
      doc.reference.delete();
    }

    products.clear();
    discountPercentage = 0;
    cuponCode = null;
    isLoading = false;
    notifyListeners();

    return refOrder.documentID;

  }
}