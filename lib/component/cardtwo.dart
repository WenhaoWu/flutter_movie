import 'package:flutter/material.dart';
import 'package:movie/model/movie.dart';
import 'package:movie/utils/constans.dart';


class CardTwo {

  static Widget buildCardTwo(BuildContext context, Movie movie)=>
      new Container(
          height: 200.0,
          width: 140.0,
          margin: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
          alignment: Alignment.bottomCenter,
          decoration: new BoxDecoration(
            image: new DecorationImage(
                image: new NetworkImage(TMDB_IMAGE_342+movie.posterPath),
                fit: BoxFit.cover,
            ),
            borderRadius: new BorderRadius.all(const Radius.circular(10.0))
          ),
          child: new Container(
            width: 140.0,
            height: 40.0,
            alignment: Alignment.center,
            child: new Text(movie.title, textAlign: TextAlign.center,),
            decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.vertical(bottom: const Radius.circular(10.0))
            ),
          )
      );

}