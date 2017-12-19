import 'package:flutter/material.dart';
import 'package:movie/model/movie.dart';
import 'package:movie/utils/constans.dart';


class CardOne {

  static Widget buildCardOne(BuildContext context, Movie movie,{bool whiteBackground = false})=>
    new Container(
      decoration: new BoxDecoration(
        image: !whiteBackground
            ? new DecorationImage(
                  image: new NetworkImage(TMDB_IMAGE_342+movie.posterPath),
                  fit: BoxFit.cover,
                  colorFilter: new ColorFilter.mode(Colors.black26, BlendMode.dstIn)
              )
            : null,
        color: whiteBackground ? Colors.white : null
      ),
      child: new Center(
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new Container(
                width: 140.0,
                decoration: new BoxDecoration(
                    image: new DecorationImage(
                      image: new NetworkImage(TMDB_IMAGE_154+movie.posterPath),
                      fit: BoxFit.fitHeight
                    )
                ),
              ),
              new Container(
                width: 200.0,
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    new Text(
                      movie.title,
                      style: new TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                      ),
                    )
                  ],
                ),
              ),
            ],
          )
      )
    );

}