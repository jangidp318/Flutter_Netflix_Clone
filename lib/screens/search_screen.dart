import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:netflix_flutter_clone/common/utils.dart';
import 'package:netflix_flutter_clone/models/movie_recommendation_model.dart';
import 'package:netflix_flutter_clone/models/search_model.dart';
import 'package:netflix_flutter_clone/screens/movie_detailed_screen.dart';
import 'package:netflix_flutter_clone/services/api_services.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  ApiServices apiServices = ApiServices();
  late Future<MovieRecommendationModel> popularMoviesFuture;

  SearchModel? searchModel;

  @override
  void initState() {
    popularMoviesFuture = apiServices.getPopularMovies();
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void search(String query) {
    apiServices.getSearchedMovie(query).then((results) {
      setState(() {
        searchModel = results;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: CupertinoSearchTextField(
              padding: const EdgeInsets.all(10),
              controller: searchController,
              prefixIcon: const Icon(
                Icons.search,
                color: Colors.grey,
              ),
              suffixIcon: const Icon(
                Icons.cancel,
                color: Colors.grey,
              ),
              style: const TextStyle(color: Colors.white),
              backgroundColor: Colors.grey.withOpacity(0.3),
              onChanged: (value) {
                if (value.isEmpty) {
                } else {
                  search(searchController.text);
                }
              },
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Expanded(
            child: searchController.text.isEmpty
                ? FutureBuilder(
                    future: popularMoviesFuture,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var data = snapshot.data?.results;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: Text(
                                "Top Searches",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Expanded(
                              child: ListView.builder(
                                  itemCount: data!.length,
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        log("tap...!");
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MovieDetailedScreen(
                                                      movieId: data[index].id,
                                                    )));
                                      },
                                      child: Container(
                                        height: 150,
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Row(
                                          children: [
                                            Image.network(
                                                "$imageUrl${data[index].posterPath}"),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            SizedBox(
                                              width: 260,
                                              child: Text(
                                                "${data[index].originalTitle}",
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                            )
                          ],
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  )
                : searchModel == null
                    ? const SizedBox.shrink()
                    : GridView.builder(
                        itemCount: searchModel?.results.length,
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 15,
                                crossAxisSpacing: 5,
                                childAspectRatio: 1.2 / 2),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MovieDetailedScreen(
                                          movieId:
                                              searchModel!.results[index].id)));
                            },
                            child: Column(
                              children: [
                                searchModel?.results[index].backdropPath == null
                                    ? Image.asset(
                                        "assets/netflix.png",
                                        height: 170,
                                      )
                                    : CachedNetworkImage(
                                        imageUrl:
                                            "$imageUrl${searchModel?.results[index].posterPath}",
                                        height: 170,
                                      ),
                                SizedBox(
                                    width: 100,
                                    child: Text(
                                      "${searchModel?.results[index].originalTitle}",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 14),
                                    ))
                              ],
                            ),
                          );
                        },
                      ),
          )
        ],
      )),
    );
  }
}
