import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fludex/fludex.dart';
import 'package:movie/component/cardone.dart';
import 'package:movie/component/cardtwo.dart';
import 'package:movie/model/movie.dart';
import 'package:movie/utils/api.dart';
import 'package:movie/utils/constans.dart';

class HomeScreen extends StatelessWidget {
  static final String name = "HomeScreen";

  static final Reducer reducer =
  new Reducer(initState: initState, reduce: _reducer);

  static final FludexState<Map<String, dynamic>> initState =
    new FludexState<Map<String,dynamic>>(<String, dynamic>{
      "state": "Begin",
      "now_playing_list": new List<Movie>(),
    });

  static FludexState _reducer(FludexState _state, Action action) {
    Map<String, dynamic> state = _state.state;
    if (action.type is FutureFulfilledAction) {
      state["state"] = "Success";
      state["now_playing_list"] = action.type.result;
    }
    else if (action.type is FutureRejectedAction) {
      state["state"] = "Error";
    }
    else if (action.type == "FUTURE_DISPATCHED") {
      state["state"] = "Fetching";
    }

    return new FludexState<Map<String,dynamic>>(state);
  }

  void _fetchNowPlayingAction(int page) {

    final Future<List<Movie>> moviesFuture = fetchMoviesNowPlaying(page);

    final Action asyncAction = new Action(
        type: new FutureAction<List<Movie>>(
          moviesFuture,
          initialAction: new Action(
              type: "FUTURE_DISPATCHED"
          )
        ),
    );

    new Store(null).dispatch(asyncAction);
  }

  Widget _buildNowPlaying() {
    List<Movie> nowPlayList = new Store(null).state[HomeScreen.name]['now_playing_list'];

    return new Container(
      height: 220.0,
      child: new PageView.builder(
          itemCount: nowPlayList.length,
          itemBuilder: (BuildContext context, int index)=>
            CardOne.buildCardOne(context, nowPlayList[index])
      ),
    );

  }

  Widget _buildPopular() {
    List<Movie> popularList = new Store(null).state[HomeScreen.name]['now_playing_list'];
    print(popularList.length);

    return new Container(
      height: 200.0,
      child: new ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index)=>
            CardTwo.buildCardTwo(context, popularList[index])
      ),
    );
  }

  Widget _stateSwitcher(){
    String state = new Store(null).state[HomeScreen.name]['state'];

    if (state == "Begin"){
      _fetchNowPlayingAction(1);
    }
    else if (state == "Fetching"){
      return new Center(
        child:const CircularProgressIndicator(),
      );
    }
    else if (state == "Success"){
      return new Scaffold(
        body: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new StoreWrapper(builder: _buildNowPlaying),
            new Padding(
              padding: const EdgeInsets.fromLTRB(20.0,30.0, 20.0, 20.0),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Text("Popular",style: new TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                  ),),
                  new Text("See all", style: new TextStyle(
                      fontSize: 14.0,
                      color: Colors.white,
                      fontStyle: FontStyle.italic
                  ),)
                ],
              ),
            ),
            new StoreWrapper(builder: _buildPopular)
          ],
        )
      );
    }

    return new Center(
      child: new Text("Error",style: new TextStyle(
          fontSize: 18.0,
          color: Colors.white,
          fontWeight: FontWeight.bold
      )),
    );

  }

  @override
  Widget build(BuildContext context) {
    return new StoreWrapper(builder: _stateSwitcher);
  }
}
