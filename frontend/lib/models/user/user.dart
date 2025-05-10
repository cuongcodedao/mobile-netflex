class User {
  final String id;
  final String email;
  final String name;
  final String? avatar;
  final String? phoneNumber;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> savedContent;
  final List<String> watchHistory;
  final String subscriptionType;
  final DateTime subscriptionExpiry;

  User({
    required this.id,
    required this.email,
    required this.name,
    this.avatar,
    this.phoneNumber,
    required this.createdAt,
    required this.updatedAt,
    required this.savedContent,
    required this.watchHistory,
    required this.subscriptionType,
    required this.subscriptionExpiry,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      avatar: json['avatar'],
      phoneNumber: json['phoneNumber'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      savedContent: List<String>.from(json['savedContent']),
      watchHistory: List<String>.from(json['watchHistory']),
      subscriptionType: json['subscriptionType'],
      subscriptionExpiry: DateTime.parse(json['subscriptionExpiry']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'avatar': avatar,
      'phoneNumber': phoneNumber,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'savedContent': savedContent,
      'watchHistory': watchHistory,
      'subscriptionType': subscriptionType,
      'subscriptionExpiry': subscriptionExpiry.toIso8601String(),
    };
  }
} 