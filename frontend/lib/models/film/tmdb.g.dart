// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tmdb.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tmdb _$TmdbFromJson(Map<String, dynamic> json) => Tmdb(
  id: json['id'] as String?,
  season: (json['season'] as num?)?.toInt(),
  voteAverage: (json['vote_average'] as num).toDouble(),
  voteCount: (json['vote_count'] as num).toInt(),
);

Map<String, dynamic> _$TmdbToJson(Tmdb instance) => <String, dynamic>{
  'id': instance.id,
  'season': instance.season,
  'vote_average': instance.voteAverage,
  'vote_count': instance.voteCount,
};
