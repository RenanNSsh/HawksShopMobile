import 'package:flutter/material.dart';
import 'package:hawks_shop/models/user_model.dart';
import 'package:hawks_shop/screens/login_screen.dart';
import 'package:hawks_shop/tiles/drawer_tile.dart';
import 'package:scoped_model/scoped_model.dart';

class CustomDrawer extends StatelessWidget {

  final PageController pageController;

  CustomDrawer(this.pageController);

   Widget _buildBackgroundDrawer() => Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Color.fromARGB(255, 211, 118, 130),
          Color.fromARGB(255,253, 181, 168)
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter
      )
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
        children: <Widget>[
          _buildBackgroundDrawer(),
          ListView(
            padding: EdgeInsets.only(left:32.0, top: 30.0),
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 8.0),
                padding: EdgeInsets.fromLTRB(0.0, 16.0, 16.0, 8.0),
                height: 170.0,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      top: 8.0,
                      left: 0.0,
                      child: Text('Hawks Shop', style: TextStyle(fontSize: 34.0, fontWeight: FontWeight.bold, color: Colors.black87),),
                    ),
                    Positioned(
                      left: 0.0,
                      bottom: 0.0,
                      child: ScopedModelDescendant<UserModel>(
                        builder: (context, child, model){
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Olá, ${!model.isLoggedIn() ? "" : model.userData["name"].toString().split(' ')[0]}", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18.0),),
                              GestureDetector(
                                child: Text(
                                  !model.isLoggedIn() ? "Entre ou cadastre-se >" : "Sair", 
                                  style: TextStyle(color: Colors.white,fontSize: 16.0, fontWeight: FontWeight.bold)
                                ),
                                onTap: (){
                                  if(!model.isLoggedIn()){
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginScreen()));
                                  }else{
                                    model.signOut();
                                  }
                                },
                              )
                            ],
                          );
                        },
                      )
                    )
                  ],
                ),
              ),
            Divider(),
            DrawerTile(Icons.home,"Inicio",pageController,0),
            DrawerTile(Icons.list,"Produtos",pageController,1),
            DrawerTile(Icons.location_on,"Lojas",pageController,2),
            UserModel.of(context).isLoggedIn() ?
            DrawerTile(Icons.playlist_add_check,"Meus Pedidos",pageController,3) : Container(),
            ],
          )
        ],
      ),
    );
  }
}