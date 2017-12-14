import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fludex/fludex.dart';
import 'package:movie/component/cardone.dart';
import 'package:movie/component/cardtwo.dart';
import 'package:movie/model/movie.dart';
import 'package:movie/screens/movie_list_page.dart';
import 'package:movie/utils/api.dart';
import 'package:movie/utils/constans.dart';

class HomeScreen extends StatelessWidget {
  static const String NAME = "HomeScreen";

  static const String HOME_STATE = "HomeState";
  static const String NOW_PLAYING_LIST = "NowPlayingList";
  static const String POPULAR_LIST = "PopularList";

  static final Reducer reducer =
    new Reducer(initState: _initState, reduce: _reducer);

  static final FludexState<Map<String, dynamic>> _initState =
    new FludexState<Map<String,dynamic>>(<String, dynamic>{
      HOME_STATE: "Begin",
      NOW_PLAYING_LIST: new List<Movie>(),
      POPULAR_LIST : new List<Movie>()
    });

  static FludexState _reducer(FludexState _state, Action action) {
    Map<String, dynamic> state = _state.state;

    if (action.type is FutureFulfilledAction) {
      String purpose = action.payload["purpose"];
      if (purpose == "now_playing"){
        state[NOW_PLAYING_LIST] = action.type.result;
        state[HOME_STATE] = "Done1";
      }
      else if (purpose == "popular"){
        state[POPULAR_LIST] = action.type.result;
        state[HOME_STATE] = "Done2";
      }
    }
    else if (action.type is FutureRejectedAction) {
      state[HOME_STATE] = "Error";
    }
    else if (action.type == "FUTURE_DISPATCHED") {
      state[HOME_STATE] = "Fetching";
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
      payload:{"purpose" : "now_playing"}
    );

    new Store(null).dispatch(asyncAction);
  }

  void _fetchPopularAction(int page) {

    final Future<List<Movie>> moviesFuture = fetchMoviesPopular(page);

    final Action asyncAction = new Action(
        type: new FutureAction<List<Movie>>(
            moviesFuture,
            initialAction: new Action(
                type: "FUTURE_DISPATCHED"
            )
        ),
        payload:{"purpose" : "popular"}
    );

    new Store(null).dispatch(asyncAction);
  }

  Widget _buildNowPlaying() {
    List<Movie> nowPlayList = new Store(null).state[HomeScreen.NAME][NOW_PLAYING_LIST];

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
    List<Movie> popularList = new Store(null).state[HomeScreen.NAME][POPULAR_LIST];

    return new Container(
      height: 210.0,
      child: new ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: popularList.length,
        itemBuilder: (BuildContext context, int index)=>
            new CardTwo(movie:popularList[index])
      ),
    );
  }

  Widget _stateSwitcher(BuildContext context){
    String state = new Store(null).state[HomeScreen.NAME][HOME_STATE];

    if (state == "Begin"){
      _fetchNowPlayingAction(1);
    }
    else if (state == "Fetching"){
      return new Center(
        child:const CircularProgressIndicator(),
      );
    }
    else if (state == "Done1"){
      _fetchPopularAction(1);
    }
    else if (state == "Done2"){
      return new ListView(
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
          new StoreWrapper(builder: _buildPopular),
          new Container(
            height: 130.0,
            margin: const EdgeInsets.fromLTRB(12.0,30.0, 20.0, 20.0),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new GestureDetector(
                  onTap: (){
                    Navigator.push(context, new MaterialPageRoute(
                        builder: (BuildContext context)=> new MovieListPage(mode: ListMode.NowPlaying)));
                  },
                  child: new Row(
                    children: <Widget>[
                      new Icon(Icons.play_arrow, color: Colors.white, size: 28.0,),
                      new Padding(padding:
                      const EdgeInsets.only(left: 10.0),
                          child:  new Text("Now Playing", style: new TextStyle(
                              fontSize: 18.0, color: Colors.white
                          ))
                      )
                    ],
                  ),
                ),
                new Row(
                  children: <Widget>[
                    new Icon(Icons.trending_up, color: Colors.white, size: 28.0,),
                    new Padding(padding:
                    const EdgeInsets.only(left: 10.0),
                        child:  new Text("Top Rated", style: new TextStyle(
                            fontSize: 18.0, color: Colors.white
                        ))
                    )
                  ],
                ),
                new Row(
                  children: <Widget>[
                    new Icon(Icons.voicemail, color: Colors.white, size: 28.0,),
                    new Padding(padding:
                    const EdgeInsets.only(left: 10.0),
                        child:  new Text("Upcoming", style: new TextStyle(
                            fontSize: 18.0, color: Colors.white
                        ))
                    )
                  ],
                ),
              ],
            ),
          )
        ],
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
    return new StoreWrapper(builder: () =>_stateSwitcher(context));
  }
}
