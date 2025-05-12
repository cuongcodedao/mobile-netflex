// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'episode_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EpisodeHistory _$EpisodeHistoryFromJson(Map<String, dynamic> json) =>
    EpisodeHistory(
      posterUrl: json['poster_url'] as String? ?? '',
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      filename: json['filename'] as String? ?? '',
      linkEmbed: json['link_embed'] as String? ?? '',
      linkM3u8: json['link_m3u8'] as String? ?? '',
    );

Map<String, dynamic> _$EpisodeHistoryToJson(EpisodeHistory instance) =>
    <String, dynamic>{
      'poster_url': instance.posterUrl,
      'name': instance.name,
      'slug': instance.slug,
      'filename': instance.filename,
      'link_embed': instance.linkEmbed,
      'link_m3u8': instance.linkM3u8,
    };
