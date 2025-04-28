import 'package:json_annotation/json_annotation.dart';

part 'plan_model.g.dart';

@JsonSerializable()
class PlanModel {
  final String id;
  final String planName;
  final double price;
  final int maxNumberOfProfile;
  final int maxNumberOfDevice;
  final int maxNumberOfDeviceActive;

  PlanModel({
    required this.id,
    required this.planName,
    required this.price,
    required this.maxNumberOfProfile,
    required this.maxNumberOfDevice,
    required this.maxNumberOfDeviceActive,
  });

  factory PlanModel.fromJson(Map<String, dynamic> json) =>
      _$PlanModelFromJson(json);

  Map<String, dynamic> toJson() => _$PlanModelToJson(this);
}