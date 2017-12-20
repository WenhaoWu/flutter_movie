import 'package:flutter/material.dart';
import 'package:movie/model/movie.dart';
import 'package:movie/utils/constans.dart';


class CardFour {

  static Widget buildCarFour(BuildContext context, Movie movie)=>
      new Container(
          decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: new BorderRadius.circular(5.0)
          ),
          child: new Center(
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Container(
                    height: 185.0,
                    width: 123.0,
                    decoration: new BoxDecoration(
                      image: new DecorationImage(
                        image: new NetworkImage(TMDB_IMAGE_185+movie.posterPath),
                        fit: BoxFit.fitHeight,
                        alignment: Alignment.topLeft
                      ),
                      borderRadius: new BorderRadius.circular(5.0)
                    ),
                  ),
                  new Expanded(
                    child: new Container(
                      padding: const EdgeInsets.all(10.0),
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Text(
                            movie.title,
                            style: new TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          new Text(
                            movie.releaseDate.substring(0,4),
                            style: new TextStyle(
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
                                    fontSize: 12.0
                                ),)
                              ],
                            ),
                          ),
                          new Text(
                            movie.overview,
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                            style: new TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                        ],
                      ),
                    )
                  ),
                ],
              )
          )
      );

}