import 'package:json_annotation/json_annotation.dart';
part 'imdb.g.dart';

@JsonSerializable()
class Imdb {
  final String? id;

  Imdb({required this.id});

  factory Imdb.fromJson(Map<String, dynamic> json) => _$ImdbFromJson(json);
  Map<String, dynamic> toJson() => _$ImdbToJson(this);
}
