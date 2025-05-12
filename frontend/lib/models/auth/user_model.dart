import 'package:json_annotation/json_annotation.dart';
import '../plan_model.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final PlanModel currentPlan;
  final List<int> createdAt;
  final List<int>? updatedAt;
  final bool enabled;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.currentPlan,
    required this.createdAt,
    this.updatedAt,
    required this.enabled,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}