// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'film_page.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FilmPage _$FilmPageFromJson(Map<String, dynamic> json) => FilmPage(
  status: json['status'] as bool?,
  items:
      (json['items'] as List<dynamic>)
          .map((e) => Film.fromJson(e as Map<String, dynamic>))
          .toList(),
  pagination: Pagination.fromJson(json['pagination'] as Map<String, dynamic>),
);

Map<String, dynamic> _$FilmPageToJson(FilmPage instance) => <String, dynamic>{
  'status': instance.status,
  'items': instance.items,
  'pagination': instance.pagination,
};
