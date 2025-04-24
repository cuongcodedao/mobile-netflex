// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'film.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Film _$FilmFromJson(Map<String, dynamic> json) => Film(
  urlPoster: json['poster_url'] as String,
  originName: json['origin_name'] as String,
  yearOfRelease: (json['year'] as num).toInt(),
  content: json['content'] as String,
);

Map<String, dynamic> _$FilmToJson(Film instance) => <String, dynamic>{
  'poster_url': instance.urlPoster,
  'origin_name': instance.originName,
  'year': instance.yearOfRelease,
  'content': instance.content,
};
