import 'package:flutter/material.dart';

class Movie extends StatelessWidget {

  @override
  Widget build(BuildContext context) => new Scaffold(

    //App bar
    appBar: new AppBar(
      title: new Text(
        'Support',
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