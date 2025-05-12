import 'package:frontend/models/history/episode_history.dart';
import 'package:json_annotation/json_annotation.dart';

part 'film_history.g.dart';

@JsonSerializable()
class FilmHistory {
  @JsonKey(defaultValue: 0)
  final int id; // tránh null → mặc định là 0
  final bool finished;
  @JsonKey(name: 'episodeIndex')
  final int episode;
  @JsonKey(name: 'movie_slug', defaultValue: '')
  final String movieSlug;
  @JsonKey(name: 'watch_duration', defaultValue: 0)
  final int watchDuration;
  @JsonKey(name: 'episode')
  final EpisodeHistory? episodeHistory;
  @JsonKey(name: 'profile_id', defaultValue: 0)
  final int profileId;
  @JsonKey(
    name: 'last_watch',
    fromJson: _dateTimeFromList,
    toJson: _dateTimeToList,
  )
  final DateTime lastWatch;

  FilmHistory({
    required this.id,
    required this.episode,
    required this.finished,
    required this.movieSlug,
    required this.watchDuration,
    required this.episodeHistory,
    required this.profileId,
    required this.lastWatch,
  });

  factory FilmHistory.fromJson(Map<String, dynamic> json) =>
      _$FilmHistoryFromJson(json);

  Map<String, dynamic> toJson() => _$FilmHistoryToJson(this);

}
DateTime _dateTimeFromList(List<dynamic> list) {
    return DateTime(
      list[0] as int,
      list[1] as int,
      list[2] as int,
      list[3] as int,
      list[4] as int,
      list[5] as int,
      list[6] ~/ 1000000, // chuyển microseconds thành milliseconds
    );
  }

  List<dynamic> _dateTimeToList(DateTime dt) {
    return [
      dt.year,
      dt.month,
      dt.day,
      dt.hour,
      dt.minute,
      dt.second,
      dt.millisecond * 1000, // trả về microseconds như backend yêu cầu
    ];
  }
