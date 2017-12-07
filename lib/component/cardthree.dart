import 'package:flutter/material.dart';
import 'package:movie/model/movie_detail.dart';
import 'package:movie/utils/constans.dart';


class CardThree {

  static Widget buildCardThree(MovieDetail movieDetail){

    List<String> backdrops = movieDetail.backdrops;

    return new Scaffold(
      body: new Stack(
        alignment: const Alignment(0.0, 6.0),
        children: <Widget>[
          new Container(
            height: 250.0,
            child: new PageView.builder(
                itemCount: backdrops.length,
                itemBuilder: (BuildContext context, int index)=>
                new Container(
                    decoration: new BoxDecoration(
                        image: new DecorationImage(
                            image: new NetworkImage(TMDB_IMAGE_500+backdrops[index])
                        )
                    )
                )
            ),
          ),
          new Container(
            height: 200.0,
            margin: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 15.0),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Image(
                  height: 200.0,
                  width: 130.0,
                  image: new NetworkImage(TMDB_IMAGE_185+movieDetail.posterPath)
                ),
                new Container(
                  width: 10.0,
                ),
                new Expanded(
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text(movieDetail.title,
                        style: new TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold),
                      ),
                      new Text(movieDetail.tagline,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: new TextStyle(
                            color: Colors.white,
                            fontSize: 16.0),
                      ),
                      new Text(movieDetail.genres,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: new TextStyle(
                            color: Colors.white,
                            fontSize: 14.0),
                      ),
                      new Container(
                        height: 5.0,
                      ),
                      new Row(
                        children: <Widget>[
                          new Icon(Icons.star, size: 14.0,color: Colors.yellow,),
                          new Container(width: 5.0,),
                          new Text(movieDetail.rate.toString(), style: new TextStyle(
                            fontSize: 12.0, color: Colors.white
                          ),)
                        ],
                      )
                    ],
                  )
                )
              ],
            ),
          )
        ],
      )
    );


  }

}