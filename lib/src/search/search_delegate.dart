import 'package:flutter/material.dart';
import 'package:movies/src/models/movie_model.dart';
import 'package:movies/src/provider/movie_provider.dart';

class DataSearch extends SearchDelegate {
  final movieProvider = MovieProvider();
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            //clean input search
            query = '';
          }),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) return Container();
    return FutureBuilder(
      future: movieProvider.getMoviesSearch(query),
      // initialData: InitialData,
      builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
        if (snapshot.hasData) {
          final movies = snapshot.data;
          return ListView.builder(
              itemCount: movies.length,
              itemBuilder: (BuildContext context, index) {
                return ListTile(
                  leading: FadeInImage(
                    placeholder: AssetImage('assets/img/no-image.jpg'),
                    image: NetworkImage(movies[index].getPosterImage()),
                  ),
                  title: Text(movies[index].title),
                  subtitle: Text(movies[index].originalTitle),
                  onTap: () {
                    movies[index].uniqueId = '';
                    close(context, null);
                    Navigator.pushNamed(context, '/detailMovie',
                        arguments: movies[index]);
                  },
                );
              });
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
