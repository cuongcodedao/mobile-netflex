import 'package:json_annotation/json_annotation.dart';

part 'auth.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class Auth<T> {
  final int code;
  final String message;
  final T result;

  Auth({
    required this.code,
    required this.message,
    required this.result,
  });

  factory Auth.fromJson(Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$AuthFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) =>
      _$AuthToJson(this, toJsonT);
}
