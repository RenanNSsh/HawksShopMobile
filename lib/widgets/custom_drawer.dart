//Flutter
import 'package:flutter/material.dart';

//Dependencies
import 'package:scoped_model/scoped_model.dart';

//Project
import 'package:hawks_shop/models/user_model.dart';
import 'package:hawks_shop/screens/login_screen.dart';
import 'package:hawks_shop/tiles/drawer_tile.dart';
import 'package:hawks_shop/widgets/gradient_background.dart';

class CustomDrawer extends StatelessWidget {

  final PageController pageController;

  CustomDrawer(this.pageController);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
        children: <Widget>[
          GradientBackground(),
          _drawerContent(context)
        ],
      ),
    );
  }

  Widget _drawerContent(BuildContext context){
    return ListView(
        padding: EdgeInsets.only(left:32.0, top: 30.0),
        children: <Widget>[
          _headerContent(),
          Divider(),
          DrawerTile(Icons.home,"Inicio",pageController,0),
          DrawerTile(Icons.list,"Produtos",pageController,1),
          DrawerTile(Icons.location_on,"Lojas",pageController,2),
          UserModel.of(context).isLoggedIn() ?
          DrawerTile(Icons.playlist_add_check,"Meus Pedidos",pageController,3) : Container(),
        ],
      );
  }

  Widget _headerContent(){
    return Container(
      margin: EdgeInsets.only(bottom: 8.0),
      padding: EdgeInsets.fromLTRB(0.0, 16.0, 16.0, 8.0),
      height: 170.0,
      child: Stack(
        children: <Widget>[
          _headerTitle('Hawks Shop'),
          _headerBody()
        ],
      ),
    );
  }

  Widget _headerTitle(String title){
    return Positioned(
      top: 8.0,
      left: 0.0,
      child: Text(title, style: TextStyle(fontSize: 34.0, fontWeight: FontWeight.bold, color: Colors.black87),),
    );
  }

  Widget _headerBody(){
    return Positioned(
      left: 0.0,
      bottom: 0.0,
      child: ScopedModelDescendant<UserModel>(
        builder: (context, child, model){
          bool userIsLoggedIn = model.isLoggedIn();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Olá, ${!userIsLoggedIn ? 'Visitante' : model.userData.name.split(' ')[0]}", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18.0),),
              _signInSignUp(userIsLoggedIn: userIsLoggedIn,context: context,user: model),
            ],
          );
        },
      )
    );
  }

  Widget _signInSignUp({@required bool userIsLoggedIn, @required BuildContext context, @required UserModel user}){
    return GestureDetector(
      child: Text(
        !userIsLoggedIn ? "Entre ou cadastre-se >" : "Sair", 
        style: TextStyle(color: Colors.white,fontSize: 16.0, fontWeight: FontWeight.bold)
      ),
      onTap: (){
        if(!userIsLoggedIn){
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginScreen()));
        }else{
          user.signOut();
        }
      },
    );
  }
}