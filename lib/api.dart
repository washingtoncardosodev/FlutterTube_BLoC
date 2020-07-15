import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:youtube_client/models/video_model.dart';

const API_KEY = "AIzaSyDFqccjW58CdF88WFAymeCXPiBgzfxbTWI";

class Api {

  // Armazena os dados da pesquisa
  String _search;
  // Armazena o token
  String _nextToken;

  Future<List<Video>>search(String search) async {
    // Armazena os dados da pesquisa
    this._search = search;

    http.Response response = await http.get(
      "https://www.googleapis.com/youtube/v3/search?part=snippet&q=$search&type=video&key=$API_KEY&maxResults=10"
    );

    return this.decode(response);    
  }

  List<Video> decode(http.Response response) {

    if(response.statusCode == 200){

      var decoded = json.decode(response.body);

      // Armazena o token
      _nextToken = decoded["nextPageToken"];

      List<Video> videos = decoded["items"].map<Video>((map) {
        // Pega cada mao e transforma em um objeto video
        return Video.fromJson(map); 
        // No final transforma em uma lista de video
      }).toList(); 
      // Retorna os videos
      return videos;
    } else {
      // Caso erro retorna um erro
      throw Exception("Falha ao carregar os videos");
    }
  }

  Future<List<Video>>nextPage() async {
    http.Response response = await http.get(
      "https://www.googleapis.com/youtube/v3/search?part=snippet&q=$_search&type=video&key=$API_KEY&maxResults=10&pageToken=$_nextToken"
    );

    return decode(response);  
  }

  
}