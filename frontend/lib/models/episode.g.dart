// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'episode.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Episode _$EpisodeFromJson(Map<String, dynamic> json) => Episode(
  name: json['name'] as String,
  linkM3u8: json['link_m3u8'] as String,
);

Map<String, dynamic> _$EpisodeToJson(Episode instance) => <String, dynamic>{
  'name': instance.name,
  'link_m3u8': instance.linkM3u8,
};
