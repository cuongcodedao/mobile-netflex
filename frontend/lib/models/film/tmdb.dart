import 'package:json_annotation/json_annotation.dart';
part 'tmdb.g.dart';

@JsonSerializable()
class Tmdb {
  final String? id;
  final int? season;
  @JsonKey(name: "vote_average")
  final double voteAverage;
  @JsonKey(name: "vote_count")
  final int voteCount;

  Tmdb({
    required this.id,
    required this.season,
    required this.voteAverage,
    required this.voteCount,
  });

  factory Tmdb.fromJson(Map<String, dynamic> json) => _$TmdbFromJson(json);
  Map<String, dynamic> toJson() => _$TmdbToJson(this);
}
