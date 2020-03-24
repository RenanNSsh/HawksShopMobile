import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hawks_shop/dao/home_dao.dart';
import 'package:hawks_shop/datas/home_data.dart';
import 'package:transparent_image/transparent_image.dart';

class HomeTab extends StatelessWidget {

  Widget _buildBodyBack() => Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Color.fromARGB(255, 211, 118, 130),
          Color.fromARGB(255,253, 181, 168)
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight
      )
    ),
  );

  @override
  Widget build(BuildContext context) {
    HomeDAO homeDAO = HomeDAO();
    return Stack(
      children: <Widget>[
        _buildBodyBack(),
        CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              floating: true,
              snap: true,
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              flexibleSpace: FlexibleSpaceBar(
                title: const Text("Novidades"),
                centerTitle: true,
              ),
            ),
            FutureBuilder<List<HomeData>>(
              future: homeDAO.getHomeData(),
              builder: (context, snapshot){
                if(!snapshot.hasData){
                  return SliverToBoxAdapter(
                    child: Container(
                      height: 200,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    ),
                  );
                }else{
                  return SliverStaggeredGrid.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 1.0,
                    crossAxisSpacing: 1.0,
                    staggeredTiles: snapshot.data.map((homeDataDoc){
                      return StaggeredTile.count(homeDataDoc.x, homeDataDoc.y);
                    }).toList(),
                    children: snapshot.data.map((homeDataDoc){
                      return FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                        image: homeDataDoc.image,
                        fit: BoxFit.cover,
                      );
                    }).toList(),
                  );
                }
              },
            )
          ],
        )
      ],
    );
  }
}