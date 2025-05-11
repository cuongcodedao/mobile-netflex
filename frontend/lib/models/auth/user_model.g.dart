// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  id: (json['id'] as num).toInt(),
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  email: json['email'] as String,
  currentPlan: PlanModel.fromJson(json['currentPlan'] as Map<String, dynamic>),
  createdAt:
      (json['createdAt'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
  updatedAt:
      (json['updatedAt'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
  enabled: json['enabled'] as bool,
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'id': instance.id,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'email': instance.email,
  'currentPlan': instance.currentPlan,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
  'enabled': instance.enabled,
};
