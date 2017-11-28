import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class MovieDetail extends StatelessWidget {

  final String movieID;

  MovieDetail({
    @required this.movieID
  });

  @override
  Widget build(BuildContext context) => new Scaffold(

    //App bar
    appBar: new AppBar(
      title: new Text(
        movieID,
        style: new TextStyle(
            fontSize: Theme.of(context).platform == TargetPlatform.iOS? 17.0 : 20.0
        ),
      ),
      elevation: Theme.of(context).platform == TargetPlatform.iOS? 0.0 : 4.0,
    ),


    //Content
    body: new PageView(
      children: <Widget>[
        new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text('Movie page content')
          ],
        )
      ],
    ),
  );
}