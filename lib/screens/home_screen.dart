import 'package:flutter/material.dart';
import 'package:netflix_flutter_clone/common/utils.dart';
import 'package:netflix_flutter_clone/models/tv_series_model.dart';
import 'package:netflix_flutter_clone/models/upcoming_model.dart';
import 'package:netflix_flutter_clone/services/api_services.dart';
import 'package:netflix_flutter_clone/widgets/custom_carousel.dart';
import 'package:netflix_flutter_clone/widgets/movie_card_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<UpcomingMovieModel> upcomingFuture;
  late Future<UpcomingMovieModel> nowPlayingFuture;
  late Future<TvSeriesModel> topRatedSeriesFuture;

  ApiServices apiServices = ApiServices();

  @override
  void initState() {
    upcomingFuture = apiServices.getUpcomingMovies();
    nowPlayingFuture = apiServices.getNowPlayingMovies();
    topRatedSeriesFuture = apiServices.getTopRatedTvSeries();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        title: Image.asset(
          "assets/logo.png",
          height: 50,
          width: 120,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: InkWell(
              onTap: () {},
              child: const Icon(
                Icons.search,
                size: 30,
                color: Colors.white,
              ),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Container(
              color: Colors.blue,
              height: 27,
              width: 27,
            ),
          ),
          const SizedBox(
            width: 20,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder(
              future: topRatedSeriesFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return CustomCarouselSlider(
                      data: snapshot.data as TvSeriesModel);
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
            SizedBox(
              height: 220,
              child: MovieCardWidget(
                  future: nowPlayingFuture, headLineText: "Now Playing"),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 220,
              child: MovieCardWidget(
                  future: upcomingFuture, headLineText: "Upcoming Movies"),
            ),
          ],
        ),
      ),
    );
  }
}
