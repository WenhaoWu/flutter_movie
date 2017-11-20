class Movie {

  final String id;
  final String posterPath;
  final String title;
  final String tagline;

  const Movie({
    this.id,
    this.posterPath,
    this.title,
    this.tagline
  });

  Movie.fromMap(Map<String, dynamic> map) :
      id = "${map['id']}",
      posterPath = "${map['poster_path']}",
      title = "${map['title']}",
      tagline = "${map['tagline']}";
}