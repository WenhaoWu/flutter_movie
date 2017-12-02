import 'dart:async';

import 'package:fludex/fludex.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:movie/model/movie.dart';
import 'package:movie/utils/api.dart';

class MovieDetail extends StatelessWidget {

  static const String NAME = "MovieDetailScreen";
  static const String MOVIE_DETAIL_STATE = "MovieDetailState";
  static const String MOVIE_DETAIL_MOVIE = "Movie";
  static const String MOVIE_DETAIL_MOVIE_ID ="MovieID";

  final String movieID;

  MovieDetail({
    @required this.movieID,
  });

  static final Reducer reducer =
    new Reducer(initState: initState, reduce: _reducer);

  static final FludexState<Map<String, dynamic>> initState
    = new FludexState<Map<String,dynamic>>(<String, dynamic>{
      MOVIE_DETAIL_STATE: "Begin",
      MOVIE_DETAIL_MOVIE_ID: "",
      MOVIE_DETAIL_MOVIE : null,
  });

  static FludexState _reducer(FludexState _state, Action action) {
    Map<String, dynamic> state = _state.state;

//    print(action);
//
//    if (action.type is FutureFulfilledAction) {
////      state["movie"] = action.type.result;
//      state[MOVIE_DETAIL_STATE] = "Done";
//    }
//    else if (action.type is FutureRejectedAction) {
//      state[MOVIE_DETAIL_STATE] = "Error";
//    }
//    else if (action.type == "FETCH_MOVIE") {
//      state[MOVIE_DETAIL_STATE] = "Fetching";
//    }

    return new FludexState<Map<String,dynamic>>(state);
  }

  void _fetchMovieDetail() {

    final Future<Movie> movieFuture = fetchMovie(movieID);

    final Action asyncAction = new Action(
        type: new FutureAction<Movie>(
            movieFuture,
            initialAction: new Action(
                type: "FETCH_MOVIE"
            )
        ),
    );

    new Store(null).dispatch(asyncAction);
  }

  Widget _stateSwitcher(){
    String state = new Store(null).state[MovieDetail.NAME][MOVIE_DETAIL_STATE];

    print("State");
    print(state);

    if (state == "Begin"){
      _fetchMovieDetail();
    }
    else if (state == "Fetching"){
      return new Center(
        child:const CircularProgressIndicator(),
      );
    }
    else if (state == "Done"){
      return new StoreWrapper(builder: _buildMovie);
    }

    return new Center(
      child: new Text("Error",style: new TextStyle(
          fontSize: 18.0,
          color: Colors.white,
          fontWeight: FontWeight.bold
      )),
    );

  }

  Widget _buildMovie() {
    return new Container(
      height: 220.0,
      child: new Center(
        child: new Text(movieID, style: new TextStyle(color: Colors.white),)
      ));
  }

  @override
  Widget build(BuildContext context) {
    return new StoreWrapper(builder: _stateSwitcher);
  }
}