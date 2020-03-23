import 'package:flutter/material.dart';
import 'package:hawks_shop/models/cart_model.dart';
import 'package:hawks_shop/models/user_model.dart';
import 'package:hawks_shop/screens/home_screen.dart';
import 'package:scoped_model/scoped_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
      model: UserModel(),
      child: ScopedModelDescendant<UserModel>(
        builder: (context, child, model){
          return ScopedModel<CartModel>(
            model: CartModel(model),
            child: MaterialApp(
              title: 'Hawks Shop',
              theme: ThemeData(
                primaryColor: Colors.purple,
                
              ),
              home: HomeScreen(),
              debugShowCheckedModeBanner: false,
            ));
        },
      )
    );
  }
}
