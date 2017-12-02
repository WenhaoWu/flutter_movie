import 'dart:async';

import 'package:fludex/fludex.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:movie/model/movie_detail.dart';
import 'package:movie/utils/api.dart';

class SecondPage extends StatelessWidget {

  static const String NAME = "Seconde";

  static const String MOVIE_DETAIL_STATE = "MovieDetailState";
  static const String MOVIE_DETAIL_MOVIE = "Movie";
  static const String MOVIE_DETAIL_MOVIE_ID ="MovieID";

  static final Reducer reducer =
  new Reducer(initState: initState, reduce: _reducer);

  static final FludexState<Map<String, dynamic>> initState
  = new FludexState<Map<String,dynamic>>(<String, dynamic>{
    MOVIE_DETAIL_STATE : "Begin",
    MOVIE_DETAIL_MOVIE_ID: "",
    MOVIE_DETAIL_MOVIE : null
  });

  final String movieID;

  SecondPage({
    @required this.movieID,
  });

  static FludexState _reducer(FludexState _state, Action action) {
    Map<String, dynamic> state = _state.state;

    if (action.type == "FUTURE_BEGIN"){
      String movieID = action.payload["movieID"];
      state[MOVIE_DETAIL_STATE] = "Fetching";
      state[MOVIE_DETAIL_MOVIE_ID] = movieID;
    }
    else if (action.type is FutureFulfilledAction){
      String purpose = action.payload["purpose"];
      if (purpose == "MovieDetail"){
        state[MOVIE_DETAIL_STATE] = "Success";
        state[MOVIE_DETAIL_MOVIE] = action.type.result;
      }
    }
    else if (action.type is FutureRejectedAction){
      state[MOVIE_DETAIL_STATE] = "Error";
    }

    return new FludexState<Map<String,dynamic>>(state);
  }

  void _dispatchFetchMovie(){
    Future<MovieDetail> movieFuture = fetchMovie(movieID);

    final Action asyncAction = new Action(
        type: new FutureAction<MovieDetail>(
          movieFuture,
          initialAction: new Action(
            type: "FUTURE_BEGIN",
            payload: {"movieID": movieID}
          )
        ),
        payload:{"purpose" : "MovieDetail"}
    );

    new Store(null).dispatch(asyncAction);
  }

  Widget _buildMovie(){
    MovieDetail movie = new Store(null).state[SecondPage.NAME][MOVIE_DETAIL_MOVIE];

    return new Center(
      child: new Text(movie.title, style: new TextStyle(color: Colors.white)),
    );
  }

  Widget _stateSwitcher() {
    final Map<String, dynamic> state = new Store(null).state[SecondPage.NAME];

    String movieState = state[MOVIE_DETAIL_STATE];
    String stateMovieID = state[MOVIE_DETAIL_MOVIE_ID];

    if (stateMovieID != movieID){
      movieState = "Begin";
    }

    if (movieState == "Begin"){
      _dispatchFetchMovie();
    }
    else if (movieState == "Fetching"){
      return new Center(
        child: const CircularProgressIndicator(),
      );
    }
    else if (movieState == "Success"){
      return new StoreWrapper(builder: _buildMovie);
    }

    return new Center(
      child: new Text("Error", style: new TextStyle(color: Colors.white),),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new StoreWrapper(builder: _stateSwitcher);
  }
}