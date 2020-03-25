//Flutter
import 'package:flutter/material.dart';

//Project
import 'package:hawks_shop/tabs/home_tab.dart';
import 'package:hawks_shop/tabs/orders_tab.dart';
import 'package:hawks_shop/tabs/places_tab.dart';
import 'package:hawks_shop/tabs/product_tab.dart';
import 'package:hawks_shop/widgets/cart_button.dart';
import 'package:hawks_shop/widgets/custom_drawer.dart';
import 'package:hawks_shop/widgets/shop_appbar.dart';

class RouterScreen extends StatelessWidget {

  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: NeverScrollableScrollPhysics(),
      children: _routes(context),
    );
  }

  List<Widget> _routes(BuildContext context){
    return [
        _homeRoute(),
        _productsRoute(context),
        _placesRoute(),
        _ordersRoute()
    ];
  }

  Widget _homeRoute(){
    return Scaffold(
      drawer: CustomDrawer(_pageController),
      body: HomeTab(),
      floatingActionButton: CartButton(),
    );
  }

  Widget _productsRoute(BuildContext context){
    return Scaffold(
        drawer: CustomDrawer(_pageController),
        body: ProductTab(),
        floatingActionButton: CartButton(),
        appBar: ShopAppBar(title: Text("Produtos")),
      );
  }

  Widget _placesRoute(){
    return Scaffold(
      drawer: CustomDrawer(_pageController),
      body: PlacesTab(),
      appBar: ShopAppBar(title: Text("Lojas")),
    );
  }

  Widget _ordersRoute(){
    return Scaffold(
      drawer: CustomDrawer(_pageController),
      body: OrdersTab(),
      appBar: ShopAppBar(title: Text("Meus Pedidos")),
    );
  }
}