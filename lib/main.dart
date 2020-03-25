//Flutter
import 'package:flutter/material.dart';

//Dependencies
import 'package:scoped_model/scoped_model.dart';

//Project
import 'package:hawks_shop/models/cart_model.dart';
import 'package:hawks_shop/models/user_model.dart';
import 'package:hawks_shop/screens/router_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
      model: UserModel(),
      child: _scopedModelDescendant()
    );
  }

  Widget _scopedModelDescendant(){
    return ScopedModelDescendant<UserModel>(
        builder: (context, child, model){
          return ScopedModel<CartModel>(
            model: CartModel(model),
            child: _app()
          );
        },
      );
  }

  Widget _app(){
    return MaterialApp(
      title: 'Hawks Shop',
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 130, 118, 211),
      ),
      home: RouterScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
