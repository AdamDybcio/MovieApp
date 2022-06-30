import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movie_app/screens/video_player.dart';
import 'package:movie_app/widgets/similar_movies.dart';
import 'package:sliver_fab/sliver_fab.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../bloc/get_movie_videos_bloc.dart';
import '../models/video.dart';
import '../models/video_response.dart';
import '../models/movie.dart';
import '../style/theme.dart' as Style;
import '../widgets/casts.dart';
import '../widgets/movie_info.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;
  const MovieDetailScreen({Key key, @required this.movie}) : super(key: key);

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState(movie);
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  final Movie movie;
  _MovieDetailScreenState(this.movie);

  @override
  void initState() {
    super.initState();
    movieVideosBloc.getMovieVideos(movie.id);
  }

  @override
  void dispose() {
    super.dispose();
    movieVideosBloc.drainStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.Colors.mainColor,
      body: Builder(builder: (context) {
        return SliverFab(
          floatingPosition: const FloatingPosition(right: 20),
          slivers: [
            SliverAppBar(
              backgroundColor: Style.Colors.mainColor,
              expandedHeight: 200,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                titlePadding: const EdgeInsets.only(bottom: 30),
                title: Text(
                  movie.title.length > 47
                      ? "${movie.title.substring(0, 47)}..."
                      : movie.title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                background: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                          image: NetworkImage(
                            "https://image.tmdb.org/t/p/original/${movie.backPoster}",
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.center,
                          colors: [
                            Style.Colors.mainColor.withOpacity(1),
                            Style.Colors.mainColor.withOpacity(0.0),
                          ],
                          stops: const [
                            0.0,
                            0.5,
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                        top: 20,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            movie.rating.toStringAsFixed(2),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          RatingBar.builder(
                            itemSize: 8,
                            initialRating: movie.rating / 2,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 2),
                            itemBuilder: (context, _) => const Icon(
                              EvaIcons.star,
                              color: Style.Colors.secondColor,
                            ),
                            onRatingUpdate: (rating) {
                              print(rating);
                            },
                            unratedColor: Colors.white,
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 10, top: 20),
                      child: Text(
                        'OVERVIEW',
                        style: TextStyle(
                          color: Style.Colors.titleColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        movie.overview,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    MovieInfo(id: movie.id),
                    Casts(
                      id: movie.id,
                    ),
                    SimilarMovies(id: movie.id),
                  ],
                ),
              ),
              padding: const EdgeInsets.all(0),
            )
          ],
          floatingWidget: StreamBuilder<VideoResponse>(
            stream: movieVideosBloc.subject.stream,
            builder: (context, AsyncSnapshot<VideoResponse> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.error.isNotEmpty) {
                  return _buildErrorWidget(snapshot.data.error);
                }
                return _buildVideoWidget(snapshot.data);
              } else if (snapshot.hasError) {
                return _buildErrorWidget(snapshot.error as String);
              } else {
                return _buildLoadingWidget();
              }
            },
          ),
          expandedHeight: 200,
        );
      }),
    );
  }

  Widget _buildLoadingWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          SizedBox(
            height: 25,
            width: 25,
            child: CircularProgressIndicator(),
          )
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Error occured: $error'),
        ],
      ),
    );
  }

  Widget _buildVideoWidget(VideoResponse data) {
    List<Video> videos = data.videos;
    return FloatingActionButton(
      backgroundColor: Style.Colors.secondColor,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: ((context) => VideoPlayerScreen(
                  controller: YoutubePlayerController(
                    initialVideoId: videos[0].key,
                    flags: const YoutubePlayerFlags(
                      autoPlay: true,
                    ),
                  ),
                )),
          ),
        );
      },
      child: const Icon(Icons.play_arrow),
    );
  }
}
