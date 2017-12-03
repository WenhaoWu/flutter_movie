import 'package:flutter/material.dart';
import 'package:movie/model/movie_detail.dart';
import 'package:movie/utils/constans.dart';


class CardThree {

  static Widget buildCardThree(MovieDetail movieDetail){

    List<String> backdrops = movieDetail.backdrops;

    print(backdrops);

    return new Stack(
      alignment: const Alignment(0.0, 8.0),
      children: <Widget>[
        new Container(
          height: 250.0,
          child: new PageView.builder(
              itemCount: backdrops.length,
              itemBuilder: (BuildContext context, int index)=>
                  new Container(
                    decoration: new BoxDecoration(
//                      image: new DecorationImage(
//                          image: new NetworkImage(TMDB_IMAGE_342+backdrops[index])
//                      )
                    )
                  )
          ),
        ),
        new Container(
          height: 200.0,
          margin: const EdgeInsets.all(5.0),
          decoration: new BoxDecoration(
            border: new Border.all(color: Colors.white)
          ),
        )
      ],
    );

  }

}