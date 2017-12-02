class Cast {
  final String character;
  final String name;
  final String avatar;

  Cast({
    this.character,
    this.name,
    this.avatar
  });

  Cast.fromMap(Map<String, dynamic> map) :
        character = "${map['character']}",
        name = "${map['name']}",
        avatar = "${map['profile_path']}";
}