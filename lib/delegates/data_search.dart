import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DataSearch extends SearchDelegate<String> {

  // Cria o x para limpar a pesquisa
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear), 
        onPressed: (){
          query = "";
        }
      )
    ];
  }
  
  // Exibe um icone antes do input
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow, 
        progress: transitionAnimation
      ), 
      onPressed: (){
        close(context, null);
      }
    );
  }
  
  // Constroi a tela com base no resultado da pesquisa
  @override
  Widget buildResults(BuildContext context) {  
    // Para retornar os dado em uma outra tela temos que fazer essa "gambiarra"  
    Future.delayed(Duration.zero).then((_) => close(context, query));
    return Container();
  }
  
  // Ao digitar exibe as sugestões de pesquisa na mesma tela 
  // Ao digitar qualquer coisa chama o buildSuggestions passando o query com o conteudo digitado
  @override
  Widget buildSuggestions(BuildContext context) { 

    if(query.isEmpty){
      return Container();
    } else {
      return FutureBuilder<List>(
        future: this.suggestions(query),
        builder: (context, snapshot){
          if(!snapshot.hasData){
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index){
                return ListTile(
                  title: Text(snapshot.data[index]),
                  leading: Icon(Icons.play_arrow),
                  onTap: (){
                    // Fecha a tela de sugestões e passa o dado digitado para o buildResults onde será contruido a tela
                    // com o resultado da pesquisa
                    close(context, snapshot.data[index]);
                  },
                );
              }
            );
          }
        }
      );
    }

  }

  Future<List> suggestions(String search) async {

    http.Response response = await http.get(
      "http://suggestqueries.google.com/complete/search?hl=en&ds=yt&client=youtube&hjson=t&cp=1&q=$search&format=5&alt=json"  
    );

    if(response.statusCode == 200){
      return json.decode(response.body)[1].map((v){
        return v[0];
      }).toList();

    } else {
      throw Exception("Falha ao carregar as sugestões");
    }

  }

}