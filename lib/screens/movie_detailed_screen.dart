import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:netflix_flutter_clone/common/utils.dart';
import 'package:netflix_flutter_clone/models/movie_detailed_model.dart';
import 'package:netflix_flutter_clone/models/movie_recommendation_model.dart';
import 'package:netflix_flutter_clone/services/api_services.dart';

class MovieDetailedScreen extends StatefulWidget {
  final int movieId;
  const MovieDetailedScreen({super.key, required this.movieId});

  @override
  State<MovieDetailedScreen> createState() => _MovieDetailedScreenState();
}

class _MovieDetailedScreenState extends State<MovieDetailedScreen> {
  ApiServices apiServices = ApiServices();

  late Future<MovieDetailedModel> movieDetail;
  late Future<MovieRecommendationModel> movieRecommendations;

  @override
  void initState() {
    super.initState();
    fetchInitialData();
  }

  fetchInitialData() {
    movieDetail = apiServices.getMovieDetail(widget.movieId);
    movieRecommendations = apiServices.getMovieRecommendation(widget.movieId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: movieDetail,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final movie = snapshot.data;
              String genreText =
                  movie!.genres.map((genre) => genre.name).join(', ');
              return Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.4,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(
                                  "$imageUrl${movie.backdropPath}"),
                              fit: BoxFit.cover),
                        ),
                        child: SafeArea(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.arrow_back_ios),
                                color: Colors.white,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie.title,
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Text(
                            "${movie.releaseDate.year}",
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(
                            width: 30,
                          ),
                          Text(
                            genreText,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        movie.overview,
                        maxLines: 6,
                        overflow: TextOverflow.ellipsis,
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 17),
                      ),
                    ],
                  ),
                  FutureBuilder(
                      future: movieRecommendations,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final data = snapshot.data;
                          return data!.results.isEmpty
                              ? const SizedBox()
                              : Column(
                                  children: [
                                    const Text("More like this"),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    GridView.builder(
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          mainAxisSpacing: 15,
                                          crossAxisSpacing: 5,
                                          childAspectRatio: 1.5 / 2,
                                        ),
                                        itemBuilder: (context, index) {
                                          return CachedNetworkImage(
                                              imageUrl:
                                                  "$imageUrl${data.results[index].posterPath}");
                                        })
                                  ],
                                );
                        } else {
                          return SizedBox();
                        }
                      })
                ],
              );
            } else {
              return const CupertinoActivityIndicator();
            }
          }),
    );
  }
}
