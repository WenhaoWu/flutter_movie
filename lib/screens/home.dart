import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fludex/fludex.dart';

class Home extends StatelessWidget {

  static final String name = "HomeScreen";

  static final Reducer reducer =
      new Reducer(initState: initState, reduce: _reducer);

  static final Map<String, dynamic> initState = <String, dynamic>{
    "state" : "Begin",
    "count" : 0,
    "status" : "FutureAction yet to be dispatched",
    "loading" : false
  };

  static Map<String, dynamic> _reducer(Map<String, dynamic> state, Action action) {
    if (action.type == "CHANGE") {
      state["state"] = "Refreshed";
      state["count"]++;
    }
    else if (action.type is FutureFulfilledAction) {
      state["loading"] = false;
      state["status"] = action.type.result;
      Navigator.of(action.payload["context"]).pop();
    }
    else if (action.type is FutureRejectedAction) {
      state["loading"] = true;
      state["status"] = action.type.error;
      Navigator.of(action.payload["context"]).pop();
    }
    else if (action.type == "FUTURE_DISPATHCED"){
      state["loading"] = true;
      state["status"] = action.payload["result"];
      _onLoading(action.payload["context"]);
    }

    return state;
  }

  static void _onLoading(BuildContext context){
    showDialog<dynamic>(
      context: context,
      barrierDismissible: false,
      child: new Container(
        padding: const EdgeInsets.all(10.0),
        child: new Dialog(
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              const CircularProgressIndicator(),
              const Text("Loading")
            ],
          ),
        ),
      )
    );
  }

  void _change(){
    new Store(null).dispatch(new Action(type: "CHANGE"));
  }

  // Builds and dispatches a FutureAction
  void _delayedAction(BuildContext context) {

    // A dummyFuture that resolves after 5 seconds
    final Future<String> dummyFuture = new Future<String>.delayed(
        new Duration(seconds: 5), () => "FutureAction Resolved");

    // An Action of type [FutureAction] that takes a Future to be resolved and a initialAction which is dispatched immedietly.
    final Action asyncAction = new Action(
        type: new FutureAction<String>(dummyFuture,
            initialAction: new Action(type: "FUTURE_DISPATCHED", payload: {
              "result": "FutureAction Dispatched",
              "context": context
            })),
        payload: {"context": context});

    // Dispatching a FutureAction
    new Store(null).dispatch(asyncAction);
  }

  // Builds a Text widget based on state
  Widget _buildText1() {

    final Map<String, dynamic> state = new Store(null).state[Home.name];
    final String value = state["state"] + " " + state["count"].toString();

    return new Container(
      padding: const EdgeInsets.all(20.0),
      child: new Text(value),
    );
  }

  // Builds a Text widget based on state
  Widget _buildText2() {

    final bool loading = new Store(null).state[Home.name]["loading"];

    return new Center(
      child: new Text(
        "Status: " + new Store(null).state[Home.name]["status"],
        style:
        new TextStyle(color: loading ? Colors.red : Colors.green),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text("SecondScreen"),
      ),
      body: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new StoreWrapper(builder: _buildText1),
          const Text(
            "Dispatch a FutureAction that resolves after 5 seconds",
            textAlign: TextAlign.center,
          ),
          new StoreWrapper(builder: _buildText2),
          new FlatButton(
              onPressed: () => _delayedAction(context),
              child: const Text("Dispatch a future action"))
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