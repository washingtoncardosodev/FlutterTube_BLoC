import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_youtube/flutter_youtube.dart';
import 'package:youtube_client/api.dart';
import 'package:youtube_client/blocs/favorite_bloc.dart';
import 'package:youtube_client/models/video_model.dart';

class VideoTile extends StatelessWidget {
  
  final Video video;

  VideoTile(this.video);

  @override
  Widget build(BuildContext context) {

    final blocFavorite = BlocProvider.of<FavoriteBloc>(context);

    return InkWell(
      onTap: (){
        FlutterYoutube.playYoutubeVideoById(apiKey: API_KEY, videoId: video.id);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4.0),
        child: Column(
          children: <Widget>[
            AspectRatio(
              aspectRatio: 16.0/9.0,
              child: Image.network(video.thumb, fit: BoxFit.cover),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                        child: Text(video.title, style: TextStyle(color: Colors.white, fontSize: 16.0), maxLines: 2),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(video.channel, style: TextStyle(color: Colors.white, fontSize: 16.0)),
                      )
                    ],
                  )
                ),
                StreamBuilder<Map<String, Video>>(
                  stream: blocFavorite.outFav,
                  builder: (context, snapshot) {
                    if(snapshot.hasData){
                      return IconButton(
                      // Verifica se o video do youtube já esta na lista de favoritos
                      icon: Icon(snapshot.data.containsKey(this.video.id) ? Icons.star : Icons.star_border), 
                      color: Colors.white,
                      iconSize: 30.0,
                      onPressed: (){
                        // Adiciona ou remove o video da lista de favoritos  
                        blocFavorite.toggleFavorite(video);
                      }
                    );
                    } else {
                      return CircularProgressIndicator();
                    }
                  }
                )
              ]
            )
          ]
        ),      
      ),
    );
  }
}