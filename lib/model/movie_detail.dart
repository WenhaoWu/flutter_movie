import 'package:movie/model/cast.dart';

class MovieDetail {

  final int id;
  final String posterPath;
  final String title;
  final String tagline;
  final String overview;
  final String genres;
  final double rate;
  final List<String> backdrops;
  final List<Cast> casts;

  const MovieDetail({
    this.id,
    this.posterPath,
    this.title,
    this.tagline,
    this.overview,
    this.genres,
    this.rate,
    this.backdrops,
    this.casts
  });

  static MovieDetail fromMap(Map<String, dynamic> map){
    int id = map['id'];
    String posterPath = map['poster_path'];
    String title = map['title'];
    String tagline = map['tagline'];
    String overview = map['overview'];
    double rate = map['vote_average'];

    Map<String, dynamic> images = map['images'];
    List<Map<String, dynamic>> backdrops = images['backdrops'];
    List<String> backdropFiles = new List();
    backdrops.forEach((map){backdropFiles.add(map['file_path']);});

    Map<String, dynamic> cast = map['casts'];
    List<Map<String, dynamic>> casts = cast['cast'];
    List<Cast> castList = new List();
    casts.forEach((map){castList.add(new Cast.fromMap(map));});

    List<Map<String, dynamic>> genres = map['genres'];
    String genreBuilder = "";
    genres.forEach((map){genreBuilder+="${map['name']} ";});


    return new MovieDetail(
        id: id, posterPath: posterPath, title: title,
        tagline: tagline, overview: overview,
        rate: rate, backdrops: backdropFiles,
        casts: castList, genres: genreBuilder);
  }
}