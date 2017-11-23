import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fludex/fludex.dart';
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
      "now_playing_index": 0,
      "status": "FutureAction yet to be dispatched",
      "loading": false
    });

  static FludexState _reducer(FludexState _state, Action action) {
    Map<String, dynamic> state = _state.state;
    if (action.type == "CHANGE_NOW_PLAYING") {
      state["now_playing_index"]++;
    }
    else if (action.type is FutureFulfilledAction) {
      state["loading"] = false;
      state["status"] = action.type.result[1].title; // Result is be the value returned when a future resolves
      state["now_playing_list"] = action.type.result;
      Navigator.of(action.payload["context"]).pop();
    }
    else if (action.type is FutureRejectedAction) {
      state["loading"] = false;
      state["status"] = "Error"; // Error is the reason the future failed
      Navigator.of(action.payload["context"]).pop();
    }
    else if (action.type == "FUTURE_DISPATCHED") {
      state["status"] = action.payload["result"];
      state["loading"] = true;
      _onLoading(action.payload["context"]);
    }

    return new FludexState<Map<String,dynamic>>(state);
  }

  static void _onLoading(BuildContext context) {
    showDialog<dynamic>(
        context: context,
        barrierDismissible: false,
        child: new Container(
          padding: const EdgeInsets.all(10.0),
          child: new Dialog(
            child: new Padding(
              padding: const EdgeInsets.all(15.0),
              child:new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const CircularProgressIndicator(),
                  new Text("Loading"),
                ],
              ),
            )
          ),
        ));
  }

  void _fetchNowPlayingAction(BuildContext context, int page) {

    final Future<List<Movie>> moviesFuture = fetchNowPlaying(page);

    final Action asyncAction = new Action(
        type: new FutureAction<List<Movie>>(
          moviesFuture,
          initialAction: new Action(
              type: "FUTURE_DISPATCHED",
              payload: {
                "result": "FutureMovie Dispatched",
                "context": context
              }
          )
        ),
        payload: {"context": context}
    );

    new Store(null).dispatch(asyncAction);

  }

  // Builds a Text widget based on state
  Widget _buildText2() {

    final bool loading = new Store(null).state[HomeScreen.name]["loading"];

    return new Center(
      child: new Text(
        "Status: " + new Store(null).state[HomeScreen.name]["status"],
        style:
        new TextStyle(color: loading ? Colors.red : Colors.green),
      ),
    );
  }

  Widget _buildNowPlaying() {
    List<Movie> nowPlayList = new Store(null).state[HomeScreen.name]['now_playing_list'];

    print(nowPlayList.length);

    return new Container(
      height: 220.0,
      child: new PageView.builder(
          itemCount: nowPlayList.length,
          itemBuilder: (BuildContext context, int index)=>
          new Container(
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new NetworkImage(TMDB_IMAGE_342+nowPlayList[index].posterPath),
                fit: BoxFit.cover,
                colorFilter: new ColorFilter.mode(Colors.black26, BlendMode.dstIn)
              )
            ),
            child: new Center(
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Container(
                      height: 190.0,
                      width: 140.0,
                      decoration: new BoxDecoration(
                        image: new DecorationImage(
                          image: new NetworkImage(TMDB_IMAGE_185+nowPlayList[index].posterPath)
                        )
                      ),
                    ),
                    new Container(
                      width: 200.0,
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          new Text(
                            nowPlayList[index].title,
                            style: new TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                )
            )
          )
      ),
    );

  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new StoreWrapper(builder: _buildNowPlaying),
          new StoreWrapper(builder: _buildText2),
        ],
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: ()=>_fetchNowPlayingAction(context, 1),
        tooltip: 'Refresh',
        child: new Icon(Icons.refresh),
      ),
    );
  }
}
