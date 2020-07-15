import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:youtube_client/blocs/favorite_bloc.dart';
import 'package:youtube_client/blocs/videos_bloc.dart';
import 'package:youtube_client/delegates/data_search.dart';
import 'package:youtube_client/models/video_model.dart';
import 'package:youtube_client/screens/favorites_screen.dart';
import 'package:youtube_client/widgets/video_tile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final blocVideo = BlocProvider.of<VideosBloc>(context);
    final blocFavorite = BlocProvider.of<FavoriteBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 25.0,
          child: Image.asset("images/yt_logo_rgb_dark.png")
        ),
        elevation: 0,
        backgroundColor: Colors.black87,
        actions: <Widget>[
          Align(
            alignment: Alignment.center,
            child: StreamBuilder<Map<String, Video>>(
              stream: blocFavorite.outFav,
              builder: (context, snapshot){
                if(snapshot.hasData){
                  return Text("${snapshot.data.length}");
                } else {
                  return Container();
                }
              }
            )
          ),
          IconButton(
            icon: Icon(Icons.star), 
            onPressed: (){
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => FavoritesScreen())
              );
            }
          ),
          IconButton(
            icon: Icon(Icons.search), 
            onPressed: () async {
              String result = await showSearch(context: context, delegate: DataSearch());
              if(result != null){
                blocVideo.inSearch.add(result);
              }
            }
          )
        ],
      ),
      backgroundColor: Colors.black87,
      body: StreamBuilder(
        initialData: [],
        stream: blocVideo.outVideos,
        builder: (context, snapshot){
          if(snapshot.hasData){
            print('length ${snapshot.data.length}');
            return ListView.builder(
              itemCount: snapshot.data.length + 1,
              itemBuilder: (context, index){
                if(index < snapshot.data.length){
                  return VideoTile(snapshot.data[index]);
                } else if (index > 1){
                  blocVideo.inSearch.add(null);
                  return Container(
                    height: 40,
                    width: 40,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.red)
                    )
                  );
                } else {
                  return Container();
                }
              }  
            );
          } else {
            return Container();
          }
        }
      )
    );
  }
}