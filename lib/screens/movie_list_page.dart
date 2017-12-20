import 'dart:async';

import 'package:movie/component/cardfour.dart';
import 'package:movie/component/cardone.dart';
import 'package:fludex/fludex.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:movie/model/movie.dart';
import 'package:movie/utils/api.dart';

enum ListMode {
  Search, TopRated, NowPlaying, Upcoming
}

class MovieListPage extends StatelessWidget{
  static const String NAME = "MovieListPage";

  static const String LIST_STATE = "ListState";
  static const String LIST_LIST = "ListList";
  static const String LIST_MODE = "ListMode";

  static final Reducer reducer =
    new Reducer(initState: _initState, reduce: _reducer);

  static final FludexState<Map<String, dynamic>> _initState
    = new FludexState<Map<String,dynamic>>(<String, dynamic>{
    LIST_STATE : "Begin",
    LIST_LIST: [],
    LIST_MODE: ""
  });

  static FludexState _reducer(FludexState _state, Action action) {
    Map<String, dynamic> state = _state.state;

    if (action.type == "SEARCH_BEGIN"){
      state[LIST_STATE] = "Fetching";
      state[LIST_MODE] = action.payload["mode"];
    }
    else if (action.type is FutureFulfilledAction){
      String purpose = action.payload["purpose"];
      if (purpose == "Search"){
        state[LIST_STATE] = "Success";
        state[LIST_LIST] = action.type.result;
      }
    }
    else if (action.type is FutureRejectedAction){
      state[LIST_STATE] = "Error";
    }

    return new FludexState<Map<String,dynamic>>(state);
  }

  final ListMode mode;

  MovieListPage({
    @required this.mode,
  });

  Widget _stateSwitcher(BuildContext context) {
    final Map<String, dynamic> state = new Store(null).state[MovieListPage.NAME];

    String listState = state[LIST_STATE];
    String listMode = state[LIST_MODE];

    print("stateMode: "+listMode);
    print("widgetMode: "+mode.toString());
    if (listMode.isNotEmpty && listMode != mode.toString()){
      listState = "Begin";
    }

    if (listState == "Begin"){
      _dispatchFetchList();
    }
    else if (listState == "Fetching"){
      return new Center(
        child: const CircularProgressIndicator(),
      );
    }
    else if (listState == "Success"){
      return new StoreWrapper(builder: ()=>_buildList(context));
    }

    return new Center(
      child: new Text("Error", style: new TextStyle(color: Colors.white),),
    );
  }

  @override
  Widget build(BuildContext context) {

    var title = "";

    switch (mode){
      case ListMode.NowPlaying:
        title = "Now Playing";
        break;
      case ListMode.TopRated:
        title = "Top Rated";
        break;
      case ListMode.Upcoming:
        title = "Upcoming";
        break;
      case ListMode.Search:
        title = "Search";
        break;
    }

    return new Scaffold(
      //App bar
      appBar: new AppBar(
        title: new Text(
          title,
          style: new TextStyle(
              fontSize: Theme.of(context).platform == TargetPlatform.iOS? 17.0 : 20.0
          ),
        ),
        elevation: Theme.of(context).platform == TargetPlatform.iOS? 0.0 : 4.0,
      ),

      //Content
      body: new StoreWrapper(builder: ()=>_stateSwitcher(context))
    );

  }

  void _dispatchFetchList() {

    String type = "";

    switch (mode){
      case ListMode.NowPlaying:
        type = "now_playing";
        break;
      case ListMode.TopRated:
        type = "top_rated";
        break;
      case ListMode.Upcoming:
        type = "upcoming";
        break;
      case ListMode.Search:
        break;
    }

    final Future<List<Movie>> moviesFuture = fetchMoviesList(type);

    final Action asyncAction = new Action(
        type: new FutureAction<List<Movie>>(
            moviesFuture,
            initialAction: new Action(
              type: "SEARCH_BEGIN",
              payload: {"mode": mode.toString()}
            )
        ),
        payload:{"purpose" : "Search"}
    );

    new Store(null).dispatch(asyncAction);
  }

  Widget _buildList(BuildContext context) {

    List<Movie> movies = new Store(null).state[MovieListPage.NAME][LIST_LIST];

    return new ListView.builder(
        itemCount: movies.length,
        itemBuilder: (BuildContext context, int index) {
          return new Container(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: CardFour.buildCarFour(context, movies[index]),
          );
        }
    );
  }
}
