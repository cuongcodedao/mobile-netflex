import 'package:json_annotation/json_annotation.dart';

part 'profile_model.g.dart';

@JsonSerializable()
class ProfileModel {
  final int? id; // Cho phép null
  final String username;
  final String avatar;
  final bool kid;
  final int? accountId; // Cho phép null

  ProfileModel({
    this.id, // Không required nữa
    required this.username,
    required this.avatar,
    required this.kid,
    this.accountId, // Không required nữa
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        id: json['id'] as int?, // Xử lý null
        username: json['username'] as String,
        avatar: json['avatar'] as String,
        kid: json['kid'] as bool,
        accountId: json['account_id'] as int?, // Xử lý null
      );

  Map<String, dynamic> toJson() => _$ProfileModelToJson(this);
}