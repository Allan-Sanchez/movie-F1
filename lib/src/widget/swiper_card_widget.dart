import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:movies/src/models/movie_model.dart';

class MySwiperCard extends StatelessWidget {
  // const MySwiperCard({Key key}) : super(key: key);

  final List<Movie> movies;

  MySwiperCard({@required this.movies});
  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    return Container(
      // padding: EdgeInsets.only(top: 20.0),
      child: Swiper(
        layout: SwiperLayout.STACK,
        itemWidth: _screenSize.width * 0.7,
        itemHeight: _screenSize.height * 0.45,
        itemBuilder: (BuildContext context, int index) {
          movies[index].uniqueId = '${movies[index].id}-card';
          return Hero(
            tag: movies[index].uniqueId,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/detailMovie',
                        arguments: movies[index]);
                  },
                  child: FadeInImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(movies[index].getPosterImage()),
                    placeholder: AssetImage('assets/img/no-image.jpg'),
                  ),
                )),
          );
        },
        itemCount: movies.length,
        // pagination: SwiperPagination(),
        // control: SwiperControl(),
      ),
    );
  }
}
