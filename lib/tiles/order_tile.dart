import 'package:flutter/material.dart';
import 'package:hawks_shop/dao/order_dao.dart';
import 'package:hawks_shop/datas/cart_product.dart';
import 'package:hawks_shop/datas/order_data.dart';

class OrderTile extends StatelessWidget {

  final String orderId;

  const OrderTile(this.orderId);

  @override
  Widget build(BuildContext context) {
    OrderDAO orderDAO = OrderDAO();
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: StreamBuilder<OrderData>(
          stream: orderDAO.getStreamOrder(orderId: orderId),
          builder: (context,snapshot){
            if(!snapshot.hasData){
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            int status = snapshot.data.status;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Código do pedido: ${snapshot.data.id}", style: TextStyle(fontWeight: FontWeight.bold),),
                SizedBox(height: 4.0,),
                Text(_buildProductsText(snapshot.data)),
                SizedBox(height: 4.0,),
                
                Text("Status do pedido:", style: TextStyle(fontWeight: FontWeight.bold),),
                SizedBox(height: 4.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    _buildCircle(title: "1", subtitle: "Preparação",status: status, thisStatus: 1 ),
                    Container(
                      height: 1.0,
                      width: 40.0,
                      color: Colors.grey[500],
                    ),
                    _buildCircle(title: "2", subtitle: "Transporte",status: status, thisStatus: 2 ),
                    Container(
                      height: 1.0,
                      width: 40.0,
                      color: Colors.grey[500],
                    ),
                    _buildCircle(title: "3", subtitle: "Entrega",status: status, thisStatus: 3 ),
                  ],
                )
              ],
            );
          },
        ),
      ),
    );
  }

  String _buildProductsText(OrderData order){
    String text = "Descrição:\n";
    for(CartProduct p in order.products){
      text += "${p.amount} x ${p.product.title} R\$ ${p.product.price.toStringAsFixed(2)}\n";
    }
    text += "Total: R\$ ${order.totalPrice.toStringAsFixed(2)}";
    return text;

  }

  Widget _buildCircle({@required String title, @required String subtitle, @required int status, @required int thisStatus}){
    Color backColor;
    Widget child;

    if(status < thisStatus){
      backColor = Colors.grey;
      child = Text(title, style: TextStyle(color: Colors.white),);
    }else if(status == thisStatus){
      backColor = Colors.blue;
      child = Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Text(title, style: TextStyle(color: Colors.white),),
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          )
        ],
      );
    }else {
      backColor = Colors.green;
      child = Icon(Icons.check);
    }

    return Column(
      children: <Widget>[
        CircleAvatar(radius: 20.0, backgroundColor: backColor, child: child,),
        Text(subtitle)
      ],
    );

  }
}