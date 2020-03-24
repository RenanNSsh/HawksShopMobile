import 'package:flutter/material.dart';
import 'package:hawks_shop/dao/user_dao.dart';
import 'package:hawks_shop/models/user_model.dart';
import 'package:hawks_shop/screens/login_screen.dart';
import 'package:hawks_shop/tiles/order_tile.dart';

class OrdersTab extends StatelessWidget {
  const OrdersTab({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserDAO userDAO = UserDAO();
    if(UserModel.of(context).isLoggedIn()){
      String userId = UserModel.of(context).firebaseUser.uid;
      
      return FutureBuilder<List<String>>(
        future: userDAO.getOrders(userId: userId),
        builder: (context, snapshot){
          if(!snapshot.hasData){
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView(
            children: snapshot.data.map((orderId){
              return OrderTile(orderId);
            }
            ).toList().reversed.toList(),
          );
        },
      );
    }else{
      return Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Icon(Icons.view_list, size: 80.0, color: Theme.of(context).primaryColor,),
                  SizedBox(height: 16.0,),
                  Text("Você não tem acesso a esta area.\n Faça login!",style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                  SizedBox(height: 16.0,),
                  RaisedButton(
                    child: Text("Entrar", style: TextStyle(fontSize: 18.0)),
                    textColor: Colors.white,
                    color: Theme.of(context).primaryColor,
                    onPressed: (){
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => LoginScreen() )
                      );
                    },
                  )
                ],
              ),
            );
    }
  }
}