import 'package:flutter/material.dart';
import 'package:movies/src/models/movie_model.dart';

class MyPopularCard extends StatelessWidget {
  // const MyPopularCard({Key key}) : super(key: key);
  final List<Movie> movies;
  final Function nextPage;
  MyPopularCard({@required this.movies, @required this.nextPage});

  final _mypageController =
      PageController(initialPage: 1, viewportFraction: 0.3);

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    _mypageController.addListener(() {
      if (_mypageController.position.pixels >=
          _mypageController.position.maxScrollExtent - 200) {
        nextPage();
        // print('llego');
      }
    });
    return Container(
        height: _screenSize.height * 0.2,
        child: PageView.builder(
          pageSnapping: false,
          controller: _mypageController,
          itemCount: movies.length,
          itemBuilder: (context, i) {
            return _imageCard(context, movies[i]);
          },
          // children: _imagesCarg(context),
        ));
  }

  Widget _imageCard(BuildContext context, Movie movie) {
      movie.uniqueId = '${movie.id}-popular-card';

    final myCard = Container(
      child: Column(
        children: [
          Hero(
            tag: movie.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
                height: 200.0,
                placeholder: AssetImage('assets/img/no-image.jpg'),
                image: NetworkImage(movie.getPosterImage()),
              ),
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            movie.title,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.caption,
          )
        ],
      ),
    );

    return GestureDetector(
      child: myCard,
      onTap: () {
        Navigator.pushNamed(context, '/detailMovie', arguments: movie);
      },
    );
  }

  // List<Widget> _imagesCarg(BuildContext context) {
  //   return movies.map((item) {
  //     return Container(
  //       child: Column(
  //         children: [
  //           ClipRRect(
  //             borderRadius: BorderRadius.circular(20.0),
  //             child: FadeInImage(
  //               height: 200.0,
  //               placeholder: AssetImage('assets/img/no-image.jpg'),
  //               image: NetworkImage(item.getPosterImage()),
  //             ),
  //           ),
  //           SizedBox(height: 10.0),
  //           Text(
  //             item.title,
  //             overflow: TextOverflow.ellipsis,
  //             style: Theme.of(context).textTheme.caption,
  //           )
  //         ],
  //       ),
  //     );
  //   }).toList();
  // }
}
