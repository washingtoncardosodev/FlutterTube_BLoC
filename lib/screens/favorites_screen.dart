import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_youtube/flutter_youtube.dart';
import 'package:youtube_client/api.dart';
import 'package:youtube_client/blocs/favorite_bloc.dart';
import 'package:youtube_client/models/video_model.dart';


class FavoritesScreen extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {

    final blocFavorite = BlocProvider.of<FavoriteBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Favoritos"),
        centerTitle: true,
        backgroundColor: Colors.black87,
        elevation: 0,
      ),
      backgroundColor: Colors.black87,
      body: StreamBuilder<Map<String, Video>>(
        stream: blocFavorite.outFav,
        initialData: {},
        builder: (context, snapshot) {
          if(snapshot.hasData){
            return ListView(
              children: snapshot.data.values.map((v){
                return InkWell(
                  onTap: (){
                    FlutterYoutube.playYoutubeVideoById(apiKey: API_KEY, videoId: v.id);
                  },
                  onLongPress: (){
                    blocFavorite.toggleFavorite(v);
                  },
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 100.0,
                        height: 50.0,
                        child: Image.network(v.thumb)
                      ),
                      Expanded(
                        child: Text(v.title, style: TextStyle(color: Colors.white), maxLines: 2)
                      )
                    ]
                  ),
                );
              }).toList()
            );
          } else {

          }
        }
      ),
    );
  }
}