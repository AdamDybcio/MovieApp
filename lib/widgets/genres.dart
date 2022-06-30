import 'package:flutter/material.dart';

import '../bloc/get_genres_bloc.dart';
import '../widgets/genres_list.dart';
import '../models/genre.dart';
import '../models/genre_response.dart';

class GenresScreen extends StatefulWidget {
  const GenresScreen({Key key}) : super(key: key);

  @override
  State<GenresScreen> createState() => _GenreScreenState();
}

class _GenreScreenState extends State<GenresScreen> {
  @override
  void initState() {
    super.initState();
    genresBloc.getGenres();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<GenreResponse>(
        stream: genresBloc.subject.stream,
        builder: (context, AsyncSnapshot<GenreResponse> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.error != "" && snapshot.data.error.isNotEmpty) {
              return _buildErrorWidget(snapshot.data.error);
            }
            return _buildGenreWidget(snapshot.data);
          } else if (snapshot.hasError) {
            return _buildErrorWidget(snapshot.error as String);
          } else {
            return _buildLoadingWidget();
          }
        });
  }

  Widget _buildLoadingWidget() {
    return Center(
      child: Container(
        height: 307,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            SizedBox(
              height: 25,
              width: 25,
              child: CircularProgressIndicator(),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Loading Genres...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Error occured: $error',
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenreWidget(GenreResponse data) {
    List<Genre> genres = data.genres;
    if (genres.isEmpty) {
      return Container(
        child: const Text('No Genre'),
      );
    } else {
      return GenresList(genres: genres);
    }
  }
}
