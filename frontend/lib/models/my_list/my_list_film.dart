import 'package:json_annotation/json_annotation.dart';
part 'my_list_film.g.dart';

@JsonSerializable()
class MyListFilm {
  @JsonKey(name: 'id')
  final int? id;
  @JsonKey(name: 'categorySlug')
  final String categorySlug;
  @JsonKey(name: 'profileId')
  final int profileId;

  MyListFilm({required this.id, required this.categorySlug, required this.profileId});

  factory MyListFilm.fromJson(Map<String, dynamic> json) => _$MyListFilmFromJson(json);
  Map<String, dynamic> toJson() => _$MyListFilmToJson(this);
}
