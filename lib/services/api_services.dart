import 'dart:convert';
import 'dart:developer';

import 'package:netflix_flutter_clone/common/utils.dart';
import 'package:netflix_flutter_clone/models/movie_detailed_model.dart';
import 'package:netflix_flutter_clone/models/movie_recommendation_model.dart';
import 'package:netflix_flutter_clone/models/search_model.dart';
import 'package:netflix_flutter_clone/models/tv_series_model.dart';
import 'package:netflix_flutter_clone/models/upcoming_model.dart';
import 'package:http/http.dart' as http;

var key = "?api_key=$apiKey";
late String endPoint;

class ApiServices {
  Future<UpcomingMovieModel> getUpcomingMovies() async {
    log("fetching upcoming movies...");
    endPoint = "movie/upcoming";
    final url = "$baseUrl$endPoint$key";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      log("Success");

      return UpcomingMovieModel.fromJson(jsonDecode(response.body));
    }
    throw Exception("Failed to load upcoming movies");
  }

  Future<UpcomingMovieModel> getNowPlayingMovies() async {
    log("fetching now playing movies...");
    endPoint = "movie/now_playing";
    final url = "$baseUrl$endPoint$key";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      log("Success Response");

      return UpcomingMovieModel.fromJson(jsonDecode(response.body));
    }
    throw Exception("Failed to load now playing movies");
  }

  Future<TvSeriesModel> getTopRatedTvSeries() async {
    log("fetching tv series...");
    endPoint = "tv/top_rated";
    final url = "$baseUrl$endPoint$key";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      log("Success Response");

      return TvSeriesModel.fromJson(jsonDecode(response.body));
    }
    throw Exception("Failed to load top rated tv series");
  }

  Future<SearchModel> getSearchedMovie(String searchText) async {
    log("searching movie $searchText...");
    endPoint = "search/movie?query=$searchText";
    final url = "$baseUrl$endPoint";
    print("search URL is $url");

    final response = await http
        .get(Uri.parse(url), headers: {"Authorization": "Bearer $token"});

    if (response.statusCode == 200) {
      log("Success Response");

      return SearchModel.fromJson(jsonDecode(response.body));
    }
    throw Exception("Failed to search  movie");
  }

  Future<MovieRecommendationModel> getPopularMovies() async {
    endPoint = "movie/popular";
    final url = "$baseUrl$endPoint";
    print("search URL is $url");

    final response = await http
        .get(Uri.parse(url), headers: {"Authorization": "Bearer $token"});

    if (response.statusCode == 200) {
      log("Success Response");

      return MovieRecommendationModel.fromJson(jsonDecode(response.body));
    }
    throw Exception("Failed to load popular movie");
  }

  Future<MovieDetailedModel> getMovieDetail(int movieId) async {
    endPoint = "movie/$movieId";
    final url = "$baseUrl$endPoint";
    print("search URL is $url");

    final response = await http
        .get(Uri.parse(url), headers: {"Authorization": "Bearer $token"});

    if (response.statusCode == 200) {
      log("Success Response");

      return MovieDetailedModel.fromJson(jsonDecode(response.body));
    }
    throw Exception("Failed to load movie detail");
  }

  Future<MovieRecommendationModel> getMovieRecommendation(int movieId) async {
    endPoint = "movie/$movieId/recommendations";
    final url = "$baseUrl$endPoint";
    print("search URL is $url");

    final response = await http
        .get(Uri.parse(url), headers: {"Authorization": "Bearer $token"});

    if (response.statusCode == 200) {
      log("Success Response");

      return MovieRecommendationModel.fromJson(jsonDecode(response.body));
    }
    throw Exception("Failed to load movie recommendations");
  }
}
