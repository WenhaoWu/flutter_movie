class Movie {

  final String id;
  final String posterPath;
  final String title;
  final String tagline;
  final String overview;
  final num rate;
  final String releaseDate;

  const Movie({
    this.id,
    this.posterPath,
    this.title,
    this.tagline,
    this.overview,
    this.rate,
    this.releaseDate
  });

  Movie.fromMap(Map<String, dynamic> map) :
      id = "${map['id']}",
      posterPath = "${map['poster_path']}",
      title = "${map['title']}",
      tagline = "${map['tagline']}",
      overview = "${map['overview']}",
      rate = double.parse("${map['vote_average']}"),
      releaseDate = "${map['release_date']}";

}