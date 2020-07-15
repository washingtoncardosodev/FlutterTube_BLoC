

import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:youtube_client/api.dart';
import 'package:youtube_client/models/video_model.dart';

class VideosBloc implements BlocBase {

  Api api;

  List<Video> videos;

  // Cria o StreamController para os videos
  final _videosStreamController = StreamController<List<Video>>();
  // Cria a saida para os videos
  Stream get outVideos => _videosStreamController.stream;

  // Cria o StreamController para as pesquisas
  final _searchStreamController = StreamController<String>();
  // Adiciona dados para o _searchStreamController
  Sink get inSearch => _searchStreamController.sink;

  // Construtor
  VideosBloc(){
    api = Api();

    // Fica observando o que vai sair do _searchStreamController
    // Sempre que for notificado chama o metodo _search
    _searchStreamController.stream.listen(_search);
  }

  void _search(String search) async {
    if(search != null){
      _videosStreamController.sink.add([]);
      this.videos = await api.search(search);
    } else {
      this.videos += await api.nextPage();
    }
    // Adiciona os videos no _videosStreamController
    _videosStreamController.sink.add(videos);
  }

  @override
  void dispose() {
    _videosStreamController.close();
    _searchStreamController.close();
  }


}