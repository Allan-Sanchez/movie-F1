import 'package:flutter/material.dart';
import 'package:movies/src/provider/movie_provider.dart';
import 'package:movies/src/search/search_delegate.dart';
import 'package:movies/src/widget/popular_card_widget.dart';
import 'package:movies/src/widget/swiper_card_widget.dart';

class HomePage extends StatelessWidget {
  // const HomePage({Key key}) : super(key: key);

  final moviesProvider = new MovieProvider();

  @override
  Widget build(BuildContext context) {
    moviesProvider.getPopular();
    return Scaffold(
      appBar: AppBar(
        title: Text('Cartelera de peliculas'),
        backgroundColor: Colors.indigoAccent,
        actions: [
          IconButton(
              color: Colors.white,
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(context: context, delegate: DataSearch());
                // print('click');
              })
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [_swiperCard(), _popularCard(context)],
      ),
    );
  }

  Widget _swiperCard() {
    return FutureBuilder(
      future: moviesProvider.getMoviesNow(),
      // initialData: InitialData,
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          return MySwiperCard(movies: snapshot.data);
        } else {
          return Container(
            height: 500.0,
            child: (Center(child: CircularProgressIndicator())),
          );
        }
      },
    );
  }

  Widget _popularCard(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(left: 20.0),
            child: Text(
              'Peliculas Populares',
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          StreamBuilder(
            stream: moviesProvider.popularStream,
            // initialData: InitialData,
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              if (snapshot.hasData) {
                return MyPopularCard(
                  movies: snapshot.data,
                  nextPage: moviesProvider.getPopular,
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ],
      ),
    );
  }
}
