import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hawks_shop/dao/place_dao.dart';
import 'package:hawks_shop/datas/place_data.dart';
import 'package:hawks_shop/tiles/place_tile.dart';

class PlacesTab extends StatelessWidget {
  const PlacesTab();

  @override
  Widget build(BuildContext context) {
    PlaceDAO placeDAO = PlaceDAO();
    return FutureBuilder<List<PlaceData>>(
      future: placeDAO.getPlaces(),
      builder: (context, snapshot){
        if(!snapshot.hasData){
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView(
          children: snapshot.data.map((doc) => PlaceTile(doc)).toList(),
        );
      },
    );
  }
}