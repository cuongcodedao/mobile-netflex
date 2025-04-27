import 'package:json_annotation/json_annotation.dart';
import 'film.dart';
import 'pagination.dart';

part 'film_page.g.dart';

@JsonSerializable()
class FilmPage {
  final bool? status;
  final List<Film> items;
  final Pagination pagination;

  FilmPage({
    required this.status,
    required this.items,
    required this.pagination,
  });

  factory FilmPage.fromJson(Map<String, dynamic> json) =>
      _$FilmPageFromJson(json);

  Map<String, dynamic> toJson() => _$FilmPageToJson(this);
}
