// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'film_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FilmHistory _$FilmHistoryFromJson(Map<String, dynamic> json) => FilmHistory(
  id: (json['id'] as num?)?.toInt(),
  episode: (json['episodeIndex'] as num).toInt(),
  finished: json['finished'] as bool,
  movieSlug: json['movie_slug'] as String,
  watchDuration: (json['watch_duration'] as num).toInt(),
  movie: Film.fromJson(json['movie'] as Map<String, dynamic>),
  profileId: (json['profile_id'] as num).toInt(),
  lastWatch: DateTime.parse(json['last_watch'] as String),
);

Map<String, dynamic> _$FilmHistoryToJson(FilmHistory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'finished': instance.finished,
      'episodeIndex': instance.episode,
      'movie_slug': instance.movieSlug,
      'watch_duration': instance.watchDuration,
      'movie': instance.movie,
      'profile_id': instance.profileId,
      'last_watch': instance.lastWatch.toIso8601String(),
    };
