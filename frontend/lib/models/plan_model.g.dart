// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plan_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlanModel _$PlanModelFromJson(Map<String, dynamic> json) => PlanModel(
  id: json['id'] as String,
  planName: json['planName'] as String,
  price: (json['price'] as num).toDouble(),
  maxNumberOfProfile: (json['maxNumberOfProfile'] as num).toInt(),
  maxNumberOfDevice: (json['maxNumberOfDevice'] as num).toInt(),
  maxNumberOfDeviceActive: (json['maxNumberOfDeviceActive'] as num).toInt(),
);

Map<String, dynamic> _$PlanModelToJson(PlanModel instance) => <String, dynamic>{
  'id': instance.id,
  'planName': instance.planName,
  'price': instance.price,
  'maxNumberOfProfile': instance.maxNumberOfProfile,
  'maxNumberOfDevice': instance.maxNumberOfDevice,
  'maxNumberOfDeviceActive': instance.maxNumberOfDeviceActive,
};
