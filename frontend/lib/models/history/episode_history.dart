import 'package:json_annotation/json_annotation.dart';

part 'episode_history.g.dart';

@JsonSerializable()
class EpisodeHistory {
  @JsonKey(name: 'poster_url', defaultValue: '')
  final String posterUrl;
  @JsonKey(defaultValue: '')
  final String name;
  @JsonKey(defaultValue: '')
  final String slug;
  @JsonKey(defaultValue: '')
  final String filename;
  @JsonKey(name: 'link_embed', defaultValue: '')
  final String linkEmbed;
  @JsonKey(name: 'link_m3u8', defaultValue: '')
  final String linkM3u8;

  EpisodeHistory({
    required this.posterUrl,
    required this.name,
    required this.slug,
    required this.filename,
    required this.linkEmbed,
    required this.linkM3u8,
  });

  factory EpisodeHistory.fromJson(Map<String, dynamic> json) =>
      _$EpisodeHistoryFromJson(json);

  Map<String, dynamic> toJson() => _$EpisodeHistoryToJson(this);
}
