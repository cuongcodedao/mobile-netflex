import 'package:json_annotation/json_annotation.dart';

part 'episode_data.g.dart';

@JsonSerializable()
class EpisodeData {
  final String name;
  final String slug;
  final String filename;
  final String link_embed;
  final String link_m3u8;

  EpisodeData({
    required this.name,
    required this.slug,
    required this.filename,
    required this.link_embed,
    required this.link_m3u8,
  });

  factory EpisodeData.fromJson(Map<String, dynamic> json) =>
      _$EpisodeDataFromJson(json);

  Map<String, dynamic> toJson() => _$EpisodeDataToJson(this);
}
