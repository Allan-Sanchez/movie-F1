import 'package:flutter/material.dart';
import 'package:movies/src/models/cast_model.dart';
import 'package:movies/src/models/movie_model.dart';
import 'package:movies/src/provider/movie_provider.dart';

class DetailMoviePage extends StatelessWidget {
  // const DetailMoviePage({Key key}) : super(key: key);
  final movieProvider = new MovieProvider();

  @override
  Widget build(BuildContext context) {
    final Movie detailMovie = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _createAppBar(detailMovie),
          SliverList(
              delegate: SliverChildListDelegate([
            SizedBox(
              height: 20.0,
            ),
            _createDetail(context, detailMovie),
            _createBodyDetail(detailMovie),
            _createBodyDetail(detailMovie),
            _createBodyDetail(detailMovie),
            _createCastList(context, detailMovie)
          ]))
        ],
      ),
    );
  }

  Widget _createAppBar(Movie detailMovie) {
    return SliverAppBar(
      elevation: 2.0,
      backgroundColor: Colors.indigoAccent,
      expandedHeight: 200.0,
      floating: true,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          detailMovie.title,
          style: TextStyle(color: Colors.white, fontSize: 16.0),
        ),
        background: FadeInImage(
          fit: BoxFit.cover,
          fadeInDuration: Duration(milliseconds: 150),
          image: NetworkImage(detailMovie.getBackdropPathImage()),
          placeholder: AssetImage('assets/img/loading.gif'),
        ),
      ),
    );
  }

  Widget _createDetail(BuildContext context, Movie detailMovie) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          Hero(
            tag: detailMovie.uniqueId,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Image(
                    height: 200.0,
                    image: NetworkImage(detailMovie.getPosterImage()))),
          ),
          SizedBox(width: 20.0),
          Flexible(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                detailMovie.originalTitle,
                style: Theme.of(context).textTheme.headline6,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                detailMovie.title,
                style: Theme.of(context).textTheme.subtitle1,
                overflow: TextOverflow.ellipsis,
              ),
              Row(
                children: [
                  Icon(Icons.star),
                  SizedBox(width: 10.0),
                  Text(
                    detailMovie.voteAverage.toString(),
                    style: Theme.of(context).textTheme.subtitle1,
                  )
                ],
              )
            ],
          ))
        ],
      ),
    );
  }

  Widget _createBodyDetail(Movie detailMovie) {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Text(
        detailMovie.overview,
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _createCastList(BuildContext context, Movie detailMovie) {
    return FutureBuilder(
      future: movieProvider.getCastMovie(detailMovie.id),
      // initialData: InitialData,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return _createCardActor(context, snapshot.data);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _createCardActor(BuildContext context, List<Actor> actores) {
    return SizedBox(
      height: 250.0,
      child: PageView.builder(
        pageSnapping: false,
        controller: PageController(initialPage: 1, viewportFraction: 0.3),
        itemCount: actores.length,
        itemBuilder: (context, index) {
          return _cardAvatar(actores[index]);
        },
      ),
    );
  }

  Widget _cardAvatar(Actor actor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: FadeInImage(
                height: 200.0,
                fit: BoxFit.cover,
                placeholder: AssetImage('assets/img/no-image.jpg'),
                image: NetworkImage(actor.getImageActor())),
          ),
          SizedBox(height: 10.0),
          Text(
            actor.name,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            actor.character,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
