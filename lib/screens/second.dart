import 'package:fludex/fludex.dart';
import 'package:flutter/material.dart';

class SecondPage extends StatelessWidget {

  static const String NAME = "Seconde";

  static final Reducer reducer =
  new Reducer(initState: initState, reduce: _reducer);

  static final FludexState<Map<String, dynamic>> initState
  = new FludexState<Map<String,dynamic>>(<String, dynamic>{
    "state": "Begin",
  });

  static FludexState _reducer(FludexState _state, Action action) {
    Map<String, dynamic> state = _state.state;

    return new FludexState<Map<String,dynamic>>(state);
  }

  Widget _buildText1() {

    final Map<String, dynamic> state = new Store(null).state[SecondPage.NAME];
    final String value = state["state"];

    return new Center(
      child: new Text(value, style: new TextStyle(color: Colors.white),),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new StoreWrapper(builder: _buildText1),
      ),
    );
  }
}
