import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fludex/fludex.dart';
import 'package:movie/model/movie.dart';
import 'package:movie/utils/api.dart';

class HomeScreen extends StatelessWidget {
  static final String name = "HomeScreen";

  static final Reducer reducer =
  new Reducer(initState: initState, reduce: _reducer);

  static final FludexState<Map<String, dynamic>> initState =
    new FludexState<Map<String,dynamic>>(<String, dynamic>{
      "state": "Begin",
      "count": 0,
      "status": "FutureAction yet to be dispatched",
      "loading": false
    });

  static FludexState _reducer(FludexState _state, Action action) {
    Map<String, dynamic> state = _state.state;
    if (action.type == "CHANGE") {
      state["state"] = "Refreshed";
      state["count"]++;
    } else if (action.type is FutureFulfilledAction) {
      state["loading"] = false;
      state["status"] = action.type.result[1].title; // Result is be the value returned when a future resolves
      Navigator.of(action.payload["context"]).pop();
    } else if (action.type is FutureRejectedAction) {
      state["loading"] = false;
      state["status"] = "Error"; // Error is the reason the future failed
      Navigator.of(action.payload["context"]).pop();
    } else if (action.type == "FUTURE_DISPATCHED") {
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

  void _change() {
    new Store(null).dispatch(new Action<String, Object>(type: "CHANGE"));
  }

  void _delayedAction(BuildContext context) {

    final Future<String> dummyFuture = new Future<String>.delayed(
        new Duration(seconds: 5), () => "FutureAction Resolved");

    // An Action of type [FutureAction] that takes a Future
    // to be resolved and a initialAction which is dispatched immedietly.
    final Action asyncAction = new Action(
        type: new FutureAction<String>(
            dummyFuture,
            initialAction: new Action(type: "FUTURE_DISPATCHED", payload: {
              "result": "FutureAction Dispatched",
              "context": context
            })),
        payload: {"context": context});

    // Dispatching a FutureAction
    new Store(null).dispatch(asyncAction);
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
  Widget _buildText1() {

    final Map<String, dynamic> state = new Store(null).state[HomeScreen.name];
    final String value = state["state"] + " " + state["count"].toString();

    return new Container(
      padding: const EdgeInsets.all(20.0),
      child: new Text(value),
    );
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

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new Container(
            height: 250.0,
            child: new PageView(
              ,
              children: <Widget>[
                new Container(color: Colors.red),
                new Container(color: Colors.blue)
              ],
            ),
          ),
          new StoreWrapper(builder: _buildText1),
          new Text(
            "Dispatch a FutureAction that resolves after 5 seconds",
            textAlign: TextAlign.center,
          ),
          new StoreWrapper(builder: _buildText2),
          new FlatButton(
              onPressed: () => _fetchNowPlayingAction(context, 1),
              child: new Text("Dispatch a future action"))
        ],
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _change,
        tooltip: 'Refresh',
        child: new Icon(Icons.refresh),
      ),
    );
  }
}
