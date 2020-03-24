import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hawks_shop/datas/home_data.dart';
import 'package:hawks_shop/services/home_service.dart';
import 'package:hawks_shop/widgets/gradient_background.dart';
import 'package:hawks_shop/widgets/shop_sliver_appbar.dart';
import 'package:transparent_image/transparent_image.dart';

class HomeTab extends StatelessWidget {

  final HomeService homeService = HomeService();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        GradientBackground(),
        _buildContent(),
      ],
    );
  }

  Widget _buildContent(){
    return CustomScrollView(
      slivers: <Widget>[
        ShopSliverAppBar(title: const Text("Novidades"),),
        FutureBuilder<List<HomeData>>(
          future: homeService.getHomeData(),
          builder: (context, snapshot){
            if(!snapshot.hasData){
              return _loadingSliver();
            }else{
              return _imageGridSliver(snapshot.data);
            }
          },
        )
      ],
    );
  }

  Widget _loadingSliver(){
    return SliverToBoxAdapter(
      child: Container(
        height: 200,
        alignment: Alignment.center,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        )
      ),
    );
  }

  Widget _imageGridSliver(List<HomeData> homeData){
      return SliverStaggeredGrid.count(
        crossAxisCount: 2,
        mainAxisSpacing: 1.0,
        crossAxisSpacing: 1.0,
        staggeredTiles: homeData.map((homeDataDoc){
          return StaggeredTile.count(homeDataDoc.x, homeDataDoc.y);
        }).toList(),
        children: homeData.map((homeDataDoc){
          return FadeInImage.memoryNetwork(
            placeholder: kTransparentImage,
            image: homeDataDoc.image,
            fit: BoxFit.cover,
          );
        }).toList(),
      );
  }

}