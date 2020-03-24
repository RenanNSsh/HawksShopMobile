import 'package:flutter/material.dart';
import 'package:hawks_shop/datas/place_data.dart';
import 'package:hawks_shop/services/place_service.dart';
import 'package:hawks_shop/tiles/place_tile.dart';

class PlacesTab extends StatelessWidget {
  const PlacesTab();

  @override
  Widget build(BuildContext context) {
    PlaceService placeService = PlaceService();
    return FutureBuilder<List<PlaceData>>(
      future: placeService.getPlaces(),
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