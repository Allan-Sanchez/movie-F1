import 'package:flutter/material.dart';

import 'package:movies/src/page/home_page.dart';
import 'package:movies/src/page/detail_movie_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Movies',
        initialRoute: '/',
        routes: {
          '/': (BuildContext context) => HomePage(),
          '/detailMovie': (BuildContext context) => DetailMoviePage()
        });
  }
}
