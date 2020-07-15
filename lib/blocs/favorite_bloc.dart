import 'dart:async';
import 'dart:convert';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_client/models/video_model.dart';

class FavoriteBloc implements BlocBase {

  // Cria um mapa para os videos favoritados
  Map<String, Video> _favorites = {};

  final _favoriteStreamController = BehaviorSubject<Map<String, Video>>(seedValue: {}); // seedValue Substitui o initialData do StreamBuilder
  Stream<Map<String, Video>> get outFav => _favoriteStreamController.stream;

  // Construtor
  FavoriteBloc(){
    //Salva a lista no SharedPreferences
    SharedPreferences.getInstance().then((prefs) {
      // Se existe a lista de favoritos retorna a lista de favoritos
      if(prefs.getKeys().contains("favorites")){
        // Salva os favoritos em formato json
        this._favorites = json.decode(prefs.getString("favorites")).map((key, value){
          return MapEntry(key, Video.fromJson(value));
        }).cast<String, Video>();

        // Adiciona a lista de favoritos no _favoriteStreamController
        _favoriteStreamController.add(this._favorites);
      }
    });
  }

  void toggleFavorite(Video video){
    
    if(this._favorites.containsKey(video.id)){
      // Se o video já esta na lista de favoritos, remove o video da lista de favoritos
      this._favorites.remove(video.id);
    } else {
      // Caso contrario adiciona o video na lista de favoritos
      this._favorites[video.id] = video;
    }

    // Adiciona a lista atualizada de favoritos para o _favoriteStreamController
    _favoriteStreamController.sink.add(this._favorites);

    // Salva os favoritos
    _saveFav();
  }

  // Salva os favoritos
  void _saveFav(){
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString("favorites", json.encode(this._favorites));
    });
  }


  @override
  void dispose() {
    _favoriteStreamController.close();
  }

}