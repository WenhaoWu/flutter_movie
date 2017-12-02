import 'package:movie/model/cast.dart';

class MovieDetail {

  final int id;
  final String posterPath;
  final String title;
  final String tagline;
  final String overview;
  final List<String> backdrops;
  final List<Cast> casts;

  const MovieDetail({
    this.id,
    this.posterPath,
    this.title,
    this.tagline,
    this.overview,
    this.backdrops,
    this.casts
  });

  static MovieDetail fromMap(Map<String, dynamic> map){
    int id = map['id'];
    String posterPath = map['poster_path'];
    String title = map['title'];
    String tagline = map['tagline'];
    String overview = map['overview'];

    Map<String, dynamic> images = map['images'];
    List<String> backdrops = images['backdrops'];

    Map<String, dynamic> cast = map['casts'];
    List<Map<String, dynamic>> casts = cast['cast'];

    List<Cast> castList = new List();
    casts.forEach((map){castList.add(new Cast.fromMap(map));});

    return new MovieDetail(
        id: id, posterPath: posterPath, title: title,
        tagline: tagline, overview: overview,
        backdrops: backdrops, casts: castList);
  }
}