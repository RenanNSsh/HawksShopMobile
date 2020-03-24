import 'package:flutter/material.dart';
import 'package:hawks_shop/dao/cart_dao.dart';
import 'package:hawks_shop/dao/order_dao.dart';
import 'package:hawks_shop/dao/user_dao.dart';
import 'package:hawks_shop/datas/cart_product.dart';
import 'package:hawks_shop/datas/cupon_data.dart';
import 'package:hawks_shop/datas/order_data.dart';
import 'package:hawks_shop/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model{

  UserModel user;
  bool isLoading = false;

  CuponData cupon = CuponData(cuponCode: null,percent: 0);

  final CartDAO _cartDAO = CartDAO(); 
  final OrderDAO _orderDAO = OrderDAO();
  final UserDAO _userDAO = UserDAO();

  List<CartProduct> products;

  CartModel(this.user){
    _loadCartItens();
  }

  static CartModel of(BuildContext context){
    return ScopedModel.of<CartModel>(context);
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

  void setCupom(CuponData cupon){
    if(cupon == null){
      this.cupon = CuponData(cuponCode: '',percent: 0);
    }else{
      this.cupon = cupon;
    }
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
    double discount = getProductsPrice() * cupon.percent / 100;
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

    OrderData orderData = OrderData.fromMap({
        "clientID": user.firebaseUser.uid,
        "products": products.map((product) => product.toMap()),
        "shipPrice": shipPrice,
        "discount": discount,
        "totalPrice": productsPrice - discount + shipPrice,
        "status": 1
      });
    String orderId = await _orderDAO.addOrder(orderData: orderData);

    await _userDAO.saveOrder(userId: user.firebaseUser.uid, orderId: orderId);
    await _cartDAO.removeProducts(userId: user.firebaseUser.uid);

    products.clear();
    cupon = CuponData(cuponCode: '',percent: 0);
    isLoading = false;
    notifyListeners();

    return orderId;

  }
}