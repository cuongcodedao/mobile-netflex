// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'film_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FilmHistory _$FilmHistoryFromJson(Map<String, dynamic> json) => FilmHistory(
  id: (json['id'] as num?)?.toInt() ?? 0,
  episode: (json['episodeIndex'] as num).toInt(),
  finished: json['finished'] as bool,
  movieSlug: json['movie_slug'] as String? ?? '',
  watchDuration: (json['watch_duration'] as num?)?.toInt() ?? 0,
  episodeHistory:
      json['episode'] == null
          ? null
          : EpisodeHistory.fromJson(json['episode'] as Map<String, dynamic>),
  profileId: (json['profile_id'] as num?)?.toInt() ?? 0,
  lastWatch: _dateTimeFromList(json['last_watch'] as List),
);

Map<String, dynamic> _$FilmHistoryToJson(FilmHistory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'finished': instance.finished,
      'episodeIndex': instance.episode,
      'movie_slug': instance.movieSlug,
      'watch_duration': instance.watchDuration,
      'episode': instance.episodeHistory,
      'profile_id': instance.profileId,
      'last_watch': _dateTimeToList(instance.lastWatch),
    };
