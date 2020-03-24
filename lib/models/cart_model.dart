import 'package:flutter/material.dart';
import 'package:hawks_shop/datas/cart_product.dart';
import 'package:hawks_shop/datas/cupon_data.dart';
import 'package:hawks_shop/datas/order_data.dart';
import 'package:hawks_shop/models/user_model.dart';
import 'package:hawks_shop/services/cart_service.dart';
import 'package:hawks_shop/services/order_service.dart';
import 'package:hawks_shop/services/user_service.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model{

  UserModel user;
  bool isLoading = false;

  CuponData cupon = CuponData(cuponCode: null,percent: 0);

  final CartService _cartService = CartService(); 
  final OrderService _orderService = OrderService();
  final UserService _userService = UserService();

  List<CartProduct> products;

  CartModel(this.user){
    _loadCartItens();
  }

  static CartModel of(BuildContext context){
    return ScopedModel.of<CartModel>(context);
  }

  void _loadCartItens() async{
    if(products == null && user.isLoggedIn()){
      products = await _cartService.getProducts(userId: user.userData.id);
      notifyListeners();
    }
  }

  void addCartItem(CartProduct cartProduct) async{
    try{
      CartProduct existingCartProduct = products.firstWhere((p) => _productExists(p,cartProduct));
      incProduct(existingCartProduct);
    }catch(IterableElementError){
      products.add(cartProduct);
      cartProduct.cartId = await _cartService.addCartItem(userId: user.userData.id, cartProduct: cartProduct);
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
    await _cartService.updateProduct(userId: user.userData.id, cartProduct: cartProduct);
    notifyListeners();
  }

  void decProduct(CartProduct cartProduct) async {
    cartProduct.amount--;
    await _cartService.updateProduct(userId: user.userData.id, cartProduct: cartProduct);
    notifyListeners();
  }

  void removeCartItem(CartProduct cartProduct) async {
    await _cartService.removeProduct(userId: user.userData.id, cartProduct: cartProduct);
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
        "clientID": user.userData.id,
        "products": products.map((product) => product.toMap()),
        "shipPrice": shipPrice,
        "discount": discount,
        "totalPrice": productsPrice - discount + shipPrice,
        "status": 1
      });
    String orderId = await _orderService.addOrder(orderData: orderData);

    await _userService.saveOrder(userId: user.userData.id, orderId: orderId);
    await _cartService.removeProducts(userId: user.userData.id);

    products.clear();
    cupon = CuponData(cuponCode: '',percent: 0);
    isLoading = false;
    notifyListeners();

    return orderId;

  }
}