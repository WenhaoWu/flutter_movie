import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:movie/model/movie.dart';
import 'package:movie/screens/second.dart';
import 'package:movie/utils/constans.dart';


class CardTwo extends StatefulWidget {

  final Movie movie;

  CardTwo({
    @required this.movie
  });

  @override
  _CardTwoState createState() => new _CardTwoState(movie);
}

class _CardTwoState extends State<CardTwo> {

  Movie _movie;
  ColorFilter _filter = new ColorFilter.mode(Colors.white, BlendMode.dstIn);

  _CardTwoState(Movie movie){
    _movie = movie;
  }

  void onCardTapDown(){
    setState((){
      _filter = new ColorFilter.mode(Colors.white, BlendMode.softLight);
    });
  }

  void onCardTapUp(){
    setState((){
      _filter = new ColorFilter.mode(Colors.white, BlendMode.dstIn);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTapDown: (TapDownDetails detail){
        onCardTapDown();
      },
      onTapUp: (TapUpDetails detail){
        onCardTapUp();
      },
      onTap: (){
        String id = _movie.id;
        Navigator.push(context, new MaterialPageRoute(
            builder: (BuildContext context)=> new SecondPage(movieID: id)));
      },
      child: new Container(
        width: 140.0,
        margin: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
        alignment: Alignment.bottomCenter,
        decoration: new BoxDecoration(
            image: new DecorationImage(
              image: new NetworkImage(TMDB_IMAGE_342+_movie.posterPath),
              colorFilter: _filter,
              fit: BoxFit.cover,
            ),
            borderRadius: new BorderRadius.all(const Radius.circular(3.0))
        ),
        child: new Container(
          width: 140.0,
          height: 40.0,
          alignment: Alignment.center,
          child: new Text(_movie.title, textAlign: TextAlign.center,),
          decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.vertical(bottom: const Radius.circular(3.0))
          ),
        ),
      ),
    );
  }

}