// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Auth<T> _$AuthFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => Auth<T>(
  code: (json['code'] as num).toInt(),
  message: json['message'] as String,
  result: fromJsonT(json['result']),
);

Map<String, dynamic> _$AuthToJson<T>(
  Auth<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'code': instance.code,
  'message': instance.message,
  'result': toJsonT(instance.result),
};
