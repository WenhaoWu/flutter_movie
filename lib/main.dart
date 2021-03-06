import 'package:fludex/fludex.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:movie/screens/home_page.dart';
import 'package:movie/screens/movie_list_page.dart';
import 'package:movie/screens/movie_page.dart';

import './screens/support.dart' as _supportPage;

void main()  {

  final Reducer reducers = new CombinedReducer(
    {
      HomeScreen.NAME : HomeScreen.reducer,
      MoviePage.NAME : MoviePage.reducer,
      MovieListPage.NAME : MovieListPage.reducer
    }
  );

  final Map<String, dynamic> params = <String, dynamic>{
    "reducer": reducers,
    "middleware": <Middleware>[logger, thunk, futureMiddleware]
  };

  final Store store = new Store(params);

  MaterialApp app = new MaterialApp(
    title: 'Movie',
    theme: new ThemeData(
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.black,
        backgroundColor: Colors.black
    ),
    home: new MyApp(),
    routes: <String, WidgetBuilder>{
      '/support' : (BuildContext context) => new _supportPage.Support(),
    },
  );

  runApp(app);
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) => new Scaffold(

    //App Bar
    appBar: new AppBar(
      title: new Text(
        'Movies',
        style: new TextStyle(
          fontSize: Theme.of(context).platform == TargetPlatform.iOS ? 17.0 : 20.0,
        ),
      ),
      elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
    ),
  
    //Content 
    body: new PageView(
      children: <Widget>[
        new HomeScreen()
      ],
    ),
    
    //Drawer
    drawer: new Drawer(
      child: new ListView(
        children: <Widget>[
          new Container(
            height: 120.0,
            child: new DrawerHeader(
              padding: new EdgeInsets.all(0.0),
              decoration: new BoxDecoration(
                color: new Color(0xFFECEFF1),
              ),
              child: new Center(
                child: new FlutterLogo(
                  colors: Colors.blueGrey,
                  size: 54.0,
                ),
              ),
            ),
          ),
          new ListTile(
            leading: new Icon(Icons.chat),
            title: new Text('Support'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamed('/support');
            },
          ),
          new ListTile(
              leading: new Icon(Icons.info),
              title: new Text('About'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).pushNamed('/about');
              }
          ),
          new Divider(),
          new ListTile(
              leading: new Icon(Icons.exit_to_app),
              title: new Text('Sign Out'),
              onTap: () {
                Navigator.pop(context);
              }
          ),
        ],
      ),
    ),
  );
}