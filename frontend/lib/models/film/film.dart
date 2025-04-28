import 'package:frontend/models/episode/episode.dart';
import 'package:frontend/models/film/category.dart';
import 'package:frontend/models/film/country.dart';
import 'package:frontend/models/film/imdb.dart';
import 'package:frontend/models/film/tmdb.dart';
import 'package:json_annotation/json_annotation.dart';

part 'film.g.dart';

@JsonSerializable()
class Film {
  final Tmdb? tmdb;
  final Imdb? imdb;
  @JsonKey(name: "name", defaultValue: "")
  final String name;
  @JsonKey(name: "slug", defaultValue: "")
  final String slug;

  @JsonKey(name: "origin_name", defaultValue: "")
  final String originName;

  @JsonKey(name: "content", defaultValue: "")
  final String content;
  @JsonKey(name: "type", defaultValue: "")
  final String type;
  @JsonKey(name: "status", defaultValue: "")
  final String status;

  @JsonKey(name: "poster_url", defaultValue: "")
  final String urlPoster;

  @JsonKey(name: "thumb_url", defaultValue: "")
  final String urlThumb;

  // final bool chieurap;

  @JsonKey(name: "trailer_url", defaultValue: "")
  final String trailerUrl;

  final String time;

  @JsonKey(name: "episode_current", defaultValue: "")
  final String episodeCurrent;

  @JsonKey(name: "episode_total", defaultValue: "")
  final String episodeTotal;

  @JsonKey(name: "quality", defaultValue: "")
  final String quality;
  @JsonKey(name: "lang", defaultValue: "")
  final String lang;
  @JsonKey(name: "notify", defaultValue: "")
  final String notify;
  @JsonKey(name: "showtimes", defaultValue: "")
  final String showtimes;

  @JsonKey(name: "year")
  final int? yearOfRelease;

  final List<String>? actor;
  final List<String>? director;

  final List<Category>? category;
  final List<Country>? country;

  @JsonKey(name: "_id")
  final String id;

  // final bool idCopyright;
  // final bool subDocquen;

  @JsonKey(ignore: true)
  List<Episode> listEpisodes = [];

  Film({
    required this.tmdb,
    required this.imdb,
    required this.name,
    required this.slug,
    required this.originName,
    required this.content,
    required this.type,
    required this.status,
    required this.urlPoster,
    required this.urlThumb,
    // required this.chieurap,
    required this.trailerUrl,
    required this.time,
    required this.episodeCurrent,
    required this.episodeTotal,
    required this.quality,
    required this.lang,
    required this.notify,
    required this.showtimes,
    required this.yearOfRelease,
    required this.actor,
    required this.director,
    required this.category,
    required this.country,
    required this.id,
    // required this.idCopyright,
    // required this.subDocquen,
  });

  factory Film.fromJson(Map<String, dynamic> json) => _$FilmFromJson(json);
  Map<String, dynamic> toJson() => _$FilmToJson(this);
}
