import 'dart:async';
import 'dart:convert';

import 'package:movie/model/movie.dart';
import 'package:flutter/services.dart';
import 'package:movie/utils/constans.dart';

Future<Movie> fetchMovie(String id) async {

  JsonDecoder _decoder = new JsonDecoder();

  var httpClient = createHttpClient();
  var url = "$TMDB_URL/movie/$id?api_key=$TMDB_API_KEY&append_to_response=casts,images,videos";
  var response = await httpClient.get(url);

  final String jsonBody = response.body;

  final container = _decoder.convert(jsonBody);
  return new Movie.fromMap(container);
}

Future<List<Movie>> fetchNowPlaying(int page) async {

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