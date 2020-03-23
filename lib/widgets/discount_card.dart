import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hawks_shop/models/cart_model.dart';

class DiscountCard extends StatelessWidget {
  const DiscountCard();

  @override
  Widget build(BuildContext context) {
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
              initialValue: CartModel.of(context).cuponCode ?? "",
              onFieldSubmitted: (text){
                Firestore.instance.collection("cupons").document(text).get().then((docCupon){
                  if(docCupon.data != null){
                    CartModel.of(context).setCupom(text, docCupon.data['percent']);
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text("Desconto de ${docCupon.data['percent']}% aplicado com suceso"),
                      backgroundColor: Theme.of(context).primaryColor,
                    ));
                  }else{
                    CartModel.of(context).setCupom(null, 0);
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text("Cupom Inválido"),
                      backgroundColor: Colors.redAccent,
                    ));
                  }
                }).catchError((){

                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text("Ocorreu um erro ao aplicar cupom"),
                      backgroundColor: Colors.redAccent,
                    ));
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