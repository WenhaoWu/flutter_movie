import 'dart:async';

import 'package:fludex/fludex.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:movie/model/movie.dart';
import 'package:movie/utils/api.dart';

enum ListMode {
  Search, TopRated, NowPlaying, Upcoming
}

class MovieListPage extends StatelessWidget {
  static const String NAME = "MovieListPage";

  static const String LIST_STATE = "ListState";
  static const String LIST_LIST = "ListList";

  static final Reducer reducer =
    new Reducer(initState: _initState, reduce: _reducer);

  static final FludexState<Map<String, dynamic>> _initState
    = new FludexState<Map<String,dynamic>>(<String, dynamic>{
    LIST_STATE : "Begin",
    LIST_LIST: [],
  });

  static FludexState _reducer(FludexState _state, Action action) {
    Map<String, dynamic> state = _state.state;

    if (action.type == "FUTURE_BEGIN"){
      state[LIST_STATE] = "Fetching";
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

  Widget _stateSwitcher() {
    final Map<String, dynamic> state = new Store(null).state[MovieListPage.NAME];

    String listState = state[LIST_STATE];

    if (listState == "Begin"){
      _dispatchFetchList();
    }
    else if (listState == "Fetching"){
      return new Center(
        child: const CircularProgressIndicator(),
      );
    }
    else if (listState == "Success"){
      return new StoreWrapper(builder: _buildList);
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
      body: new PageView(
        children: <Widget>[
          new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text('Support page content')
            ],
          )
        ],
      ),
    );

  }

  void _dispatchFetchList() {
    Future<List<Movie>> moviesFuture = fetchMoviesPopular(1);

    final Action asyncAction = new Action(
        type: new FutureAction<List<Movie>>(
            moviesFuture,
            initialAction: new Action(
                type: "FUTURE_BEGIN",
            )
        ),
        payload:{"purpose" : "Search"}
    );

    new Store(null).dispatch(asyncAction);
  }


  Widget _buildList() {
    return new Center(
      child: new Text("Success", style: new TextStyle(color: Colors.white),),
    );
  }
}
