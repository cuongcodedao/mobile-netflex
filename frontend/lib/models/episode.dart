import 'package:json_annotation/json_annotation.dart';

part 'episode.g.dart';

@JsonSerializable()
class Episode {
  @JsonKey(name: "name")
  final String name;

  @JsonKey(name: "link_m3u8")
  final String linkM3u8;

  Episode({required this.name, required this.linkM3u8});

  factory Episode.fromJson(Map<String, dynamic> json) =>
      _$EpisodeFromJson(json);
  Map<String, dynamic> toJson() => _$EpisodeToJson(this);
}
