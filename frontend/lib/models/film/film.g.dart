// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'film.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Film _$FilmFromJson(Map<String, dynamic> json) => Film(
  tmdb:
      json['tmdb'] == null
          ? null
          : Tmdb.fromJson(json['tmdb'] as Map<String, dynamic>),
  imdb:
      json['imdb'] == null
          ? null
          : Imdb.fromJson(json['imdb'] as Map<String, dynamic>),
  name: json['name'] as String? ?? '',
  slug: json['slug'] as String? ?? '',
  originName: json['origin_name'] as String? ?? '',
  content: json['content'] as String? ?? '',
  type: json['type'] as String? ?? '',
  status: json['status'] as String? ?? '',
  urlPoster: json['poster_url'] as String? ?? '',
  urlThumb: json['thumb_url'] as String? ?? '',
  trailerUrl: json['trailer_url'] as String? ?? '',
  time: json['time'] as String,
  episodeCurrent: json['episode_current'] as String? ?? '',
  episodeTotal: json['episode_total'] as String? ?? '',
  quality: json['quality'] as String? ?? '',
  lang: json['lang'] as String? ?? '',
  notify: json['notify'] as String? ?? '',
  showtimes: json['showtimes'] as String? ?? '',
  yearOfRelease: (json['year'] as num?)?.toInt(),
  actor: (json['actor'] as List<dynamic>?)?.map((e) => e as String).toList(),
  director:
      (json['director'] as List<dynamic>?)?.map((e) => e as String).toList(),
  category:
      (json['category'] as List<dynamic>?)
          ?.map((e) => Category.fromJson(e as Map<String, dynamic>))
          .toList(),
  country:
      (json['country'] as List<dynamic>?)
          ?.map((e) => Country.fromJson(e as Map<String, dynamic>))
          .toList(),
  id: json['_id'] as String,
);

Map<String, dynamic> _$FilmToJson(Film instance) => <String, dynamic>{
  'tmdb': instance.tmdb,
  'imdb': instance.imdb,
  'name': instance.name,
  'slug': instance.slug,
  'origin_name': instance.originName,
  'content': instance.content,
  'type': instance.type,
  'status': instance.status,
  'poster_url': instance.urlPoster,
  'thumb_url': instance.urlThumb,
  'trailer_url': instance.trailerUrl,
  'time': instance.time,
  'episode_current': instance.episodeCurrent,
  'episode_total': instance.episodeTotal,
  'quality': instance.quality,
  'lang': instance.lang,
  'notify': instance.notify,
  'showtimes': instance.showtimes,
  'year': instance.yearOfRelease,
  'actor': instance.actor,
  'director': instance.director,
  'category': instance.category,
  'country': instance.country,
  '_id': instance.id,
};
