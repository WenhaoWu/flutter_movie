import 'package:flutter/material.dart';
import 'package:movie/model/movie.dart';
import 'package:movie/screens/movie_page.dart';
import 'package:movie/utils/constans.dart';


class CardOne {

  static Widget buildCardOne(BuildContext context, Movie movie,{bool whiteBackground = false})=>
    new Scaffold(
      body: new Container(
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
                    padding: const EdgeInsets.all(10.0),
                    width: 200.0,
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Text(
                          movie.title,
                          style: new TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        new Text(
                          movie.releaseDate.substring(0,4),
                          style: new TextStyle(
                              color: Colors.white,
                              fontSize: 12.0
                          ),
                        ),
                        new Container(
                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
                          child: new Row(
                            children: <Widget>[
                              new Icon(Icons.star, size: 14.0,color: Colors.orange,),
                              new Container(width: 5.0,),
                              new Text(movie.rate.toString(), style: new TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.0
                              ),)
                            ],
                          ),
                        ),
                        new Text(
                          movie.overview,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: new TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                          ),
                        ),
                        new RaisedButton(
                            onPressed: (){
                              String id = movie.id;
                              Navigator.push(context, new MaterialPageRoute(
                                  builder: (BuildContext context)=> new MoviePage(movieID: id)));
                            },
                            color: Colors.red,
                            child: new Text('View Details', style: new TextStyle(color: Colors.white),)
                        )
                      ],
                    ),
                  ),
                ],
              )
          )
      )
    );
}