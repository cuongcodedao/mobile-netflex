import 'package:frontend/models/episode.dart';
import 'package:json_annotation/json_annotation.dart';

part 'film.g.dart';

@JsonSerializable()
class Film {
  @JsonKey(name: "poster_url")
  final String urlPoster;

  @JsonKey(name: "origin_name")
  final String originName;

  @JsonKey(name: "year")
  final int yearOfRelease;

  @JsonKey(name: "content")
  final String content;

  @JsonKey(ignore: true)
  List<Episode> listEpisolds = [];

  Film({
    required this.urlPoster,
    required this.originName,
    required this.yearOfRelease,
    required this.content,
  });

  factory Film.fromJson(Map<String, dynamic> json) => _$FilmFromJson(json);
  Map<String, dynamic> toJson() => _$FilmToJson(this);
}
