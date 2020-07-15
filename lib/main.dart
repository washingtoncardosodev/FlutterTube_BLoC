import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:youtube_client/blocs/favorite_bloc.dart';
import 'package:youtube_client/blocs/videos_bloc.dart';
import 'package:youtube_client/screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: VideosBloc(), 
      child: BlocProvider(
        bloc: FavoriteBloc(),
        child: MaterialApp(
          title: 'YouTube Client Demo',
          theme: ThemeData(        
            primarySwatch: Colors.blue,        
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: HomeScreen(),
          debugShowCheckedModeBanner: false,
        )
      )
    );
  }
}


