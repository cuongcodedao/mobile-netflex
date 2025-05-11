import 'package:frontend/models/film/film.dart';
import 'package:json_annotation/json_annotation.dart';

part 'film_history.g.dart';

@JsonSerializable()
class FilmHistory {
  final int? id;
  final bool finished;
  @JsonKey(name: 'episodeIndex')
  final int episode;
  @JsonKey(name: 'movie_slug')
  final String movieSlug;
  @JsonKey(name: 'watch_duration')
  final int watchDuration;
  @JsonKey(name: 'movie')
  final Film movie;
  @JsonKey(name: 'profile_id')
  final int profileId;
  @JsonKey(name: 'last_watch')
  final DateTime lastWatch;

  FilmHistory({
    required this.id,
    required this.episode,
    required this.finished,
    required this.movieSlug,
    required this.watchDuration,
    required this.movie,
    required this.profileId,
    required this.lastWatch,
  });

  factory FilmHistory.fromJson(Map<String, dynamic> json) =>
      _$FilmHistoryFromJson(json);

  Map<String, dynamic> toJson() => _$FilmHistoryToJson(this);
}
