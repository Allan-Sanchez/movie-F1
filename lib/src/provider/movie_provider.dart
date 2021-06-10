import 'package:http/http.dart' as http;
import 'package:movies/src/models/cast_model.dart';
import 'dart:convert';
import 'dart:async';

import 'package:movies/src/models/movie_model.dart';

class MovieProvider {
  String _url = 'api.themoviedb.org';
  String _apikey = '34f36315d3a9c94dc721f77720d28841';
  String _language = 'es-Es';
  int _popularPage = 0;

  List<Movie> _populares = [];
  bool _loading = false;

  final _popularStreamController = StreamController<List<Movie>>.broadcast();

  Function(List<Movie>) get popularSink => _popularStreamController.sink.add;
  Stream<List<Movie>> get popularStream => _popularStreamController.stream;

  void disposeStreams() {
    _popularStreamController?.close();
  }

  Future<List<Movie>> _processResponse(Uri url) async {
    final response = await http.get(url);
    final decodeData = json.decode(response.body);
    final movies = new Movies.fromJsonList(decodeData['results']);
    return movies.items;
  }

  Future<List<Movie>> getMoviesNow() async {
    final url = Uri.https(_url, '3/movie/now_playing',
        {'api_key': _apikey, 'language': _language});

    return await _processResponse(url);
  }

  Future<List<Movie>> getPopular() async {
    if (_loading) return [];
    _loading = true;
    _popularPage++;
    final url = Uri.https(_url, '3/movie/popular', {
      'api_key': _apikey,
      'language': _language,
      'page': _popularPage.toString()
    });
    final response = await _processResponse(url);
    _populares.addAll(response);
    popularSink(_populares);
    _loading = false;
    return response;
  }

  Future<List<Actor>> getCastMovie(int idCast) async {
    final url = Uri.https(_url, '3/movie/$idCast/credits',
        {'api_key': _apikey, 'language': _language});

    final response = await http.get(url);
    final decodeResponse = json.decode(response.body);
    final cast = new Cast.fromJsonList(decodeResponse['cast']);
    return cast.items;
  }

  Future<List<Movie>> getMoviesSearch(String search) async {
    final url = Uri.https(_url, '3/search/movie',
        {'api_key': _apikey, 'language': _language ,'query':search});

    return await _processResponse(url);
  }
}
