import 'dart:async';
import 'dart:convert';

import 'package:movie/model/movie.dart';
import 'package:flutter/services.dart';
import 'package:movie/model/movie_detail.dart';
import 'package:movie/utils/constans.dart';

Future<MovieDetail> fetchMovie(String id) async {

  var httpClient = createHttpClient();
  var url = "$TMDB_URL/movie/$id?api_key=$TMDB_API_KEY&append_to_response=casts,images,videos";
  var response = await httpClient.get(url);

  final String jsonBody = response.body;

  final container = JSON.decode(jsonBody);
  return MovieDetail.fromMap(container);
}

Future<List<Movie>> fetchMoviesNowPlaying(int page) async {

  var httpClient = createHttpClient();
  var url = "$TMDB_URL/movie/now_playing?api_key=$TMDB_API_KEY&page=$page";
  var response = await httpClient.get(url);

  final String jsonBody = response.body;

  final container = JSON.decode(jsonBody);

  final List<Map<String,dynamic>> result = container['results'];

  List<Movie> list = new List();

  result.forEach((map) => list.add(new Movie.fromMap(map)));

  return list;
}

Future<List<Movie>> fetchMoviesPopular(int page) async {
  var httpClient = createHttpClient();
  var url = "$TMDB_URL/movie/popular?api_key=$TMDB_API_KEY&page=$page";
  var response = await httpClient.get(url);

  final String jsonBody = response.body;

  final container = JSON.decode(jsonBody);

  final List<Map<String,dynamic>> result = container['results'];

  List<Movie> list = new List();

  result.forEach((map) => list.add(new Movie.fromMap(map)));

  return list;
}

Future<List<Movie>> fetchMoviesList(String type, {int page = 1}) async {
  var httpClient = createHttpClient();
  var url = '$TMDB_URL/movie/$type?api_key=$TMDB_API_KEY&page=$page';
  print(url);
  var response = await httpClient.get(url);

  final String jsonBody = response.body;

  final container = JSON.decode(jsonBody);

  final List<Map<String,dynamic>> result = container['results'];

  List<Movie> list = new List();

  result.forEach((map) => list.add(new Movie.fromMap(map)));

  return list;
}