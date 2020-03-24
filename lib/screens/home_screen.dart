import 'package:flutter/material.dart';
import 'package:hawks_shop/tabs/home_tab.dart';
import 'package:hawks_shop/tabs/orders_tab.dart';
import 'package:hawks_shop/tabs/places_tab.dart';
import 'package:hawks_shop/tabs/product_tab.dart';
import 'package:hawks_shop/widgets/cart_button.dart';
import 'package:hawks_shop/widgets/custom_drawer.dart';

class HomeScreen extends StatelessWidget {

  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        Scaffold(
          drawer: CustomDrawer(_pageController),
          body: HomeTab(),
          floatingActionButton: CartButton(),
        ),
        Scaffold(
          drawer: CustomDrawer(_pageController),
          floatingActionButton: CartButton(),
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            title: Text("Produtos"),
            centerTitle: true,
          ),
          body: ProductTab()
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Lojas"),
            centerTitle: true,
          ),
          drawer: CustomDrawer(_pageController),
          body: PlacesTab(),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Meus Pedidos"),
            centerTitle: true,     
          ),
          drawer: CustomDrawer(_pageController),
          body: OrdersTab()
        )
      ],);
  }
}