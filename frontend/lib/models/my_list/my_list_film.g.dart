// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_list_film.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyListFilm _$MyListFilmFromJson(Map<String, dynamic> json) => MyListFilm(
  id: (json['id'] as num?)?.toInt(),
  categorySlug: json['categorySlug'] as String,
  profileId: (json['profileId'] as num).toInt(),
);

Map<String, dynamic> _$MyListFilmToJson(MyListFilm instance) =>
    <String, dynamic>{
      'id': instance.id,
      'categorySlug': instance.categorySlug,
      'profileId': instance.profileId,
    };
