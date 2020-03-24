import 'package:flutter/material.dart';
import 'package:hawks_shop/models/cart_model.dart';
import 'package:hawks_shop/services/cupon_service.dart';

class DiscountCard extends StatelessWidget {
  const DiscountCard();

  @override
  Widget build(BuildContext context) {
    CuponService cuponService = CuponService();
    return Card(
      child: ExpansionTile(
        title: Text(
          "Cupom de Desconto", textAlign: TextAlign.start, style: TextStyle(
            fontWeight: FontWeight.w500, color: Colors.grey[700]
          ),
        ),
        leading: Icon(Icons.card_giftcard),
        trailing: Icon(Icons.add),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Digite seu Cupom"
              ),
              initialValue: CartModel.of(context).cupon != null ? CartModel.of(context).cupon.cuponCode : "",
              onFieldSubmitted: (text){
                cuponService.getCupon(text).then((cupon){
                  if(cupon != null){
                    CartModel.of(context).setCupom(cupon);
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text("Desconto de ${cupon.percent}% aplicado com suceso"),
                      backgroundColor: Theme.of(context).primaryColor,
                    ));
                  }else{
                    CartModel.of(context).setCupom(null);
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text("Cupom Inválido"),
                      backgroundColor: Colors.redAccent,
                    ));
                  }
                });
              },
            ),
          )
        ],
      ),
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
    );
  }
}