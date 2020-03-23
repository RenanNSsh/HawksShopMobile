import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hawks_shop/dao/cart_dao.dart';
import 'package:hawks_shop/datas/cart_product.dart';
import 'package:hawks_shop/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model{

  UserModel user;
  bool isLoading = false;

  String cuponCode;
  int discountPercentage = 0;
  final CartDAO _cartDAO = CartDAO(); 

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
      products = await _cartDAO.getProducts(userId: user.firebaseUser.uid);
      notifyListeners();
    }
  }

  void addCartItem(CartProduct cartProduct) async{
    try{
      CartProduct existingCartProduct = products.firstWhere((p) => _productExists(p,cartProduct));
      incProduct(existingCartProduct);
    }catch(IterableElementError){
      products.add(cartProduct);
      cartProduct.cartId = await _cartDAO.addCartItem(userId: user.firebaseUser.uid, cartProduct: cartProduct);
      notifyListeners();
    }
  }

  bool _productExists(CartProduct productList, CartProduct productSearch){
    bool sameId = productList.productId == productSearch.productId;
    bool sameSize = productList.size == productSearch.size;
    return sameId && sameSize;
  }

  void incProduct(CartProduct cartProduct) async{
    cartProduct.amount++;
    await _cartDAO.updateProduct(userId: user.firebaseUser.uid, cartProduct: cartProduct);
    notifyListeners();
  }

  void decProduct(CartProduct cartProduct) async {
    cartProduct.amount--;
    await _cartDAO.updateProduct(userId: user.firebaseUser.uid, cartProduct: cartProduct);
    notifyListeners();
  }

  void removeCartItem(CartProduct cartProduct) async {
    await _cartDAO.removeProduct(userId: user.firebaseUser.uid, cartProduct: cartProduct);
    products.remove(cartProduct);
    notifyListeners();
  }

  void setCupom(String couponCode, int discountPercentage){
    this.cuponCode = couponCode;
    this.discountPercentage = discountPercentage;
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
    await _cartDAO.removeProducts(userId: user.firebaseUser.uid);

    products.clear();
    discountPercentage = 0;
    cuponCode = null;
    isLoading = false;
    notifyListeners();

    return refOrder.documentID;

  }
}