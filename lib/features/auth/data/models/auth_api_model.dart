import 'package:hamro_deal/features/auth/domain/entities/auth_entity.dart';

class AuthApiModel {
  final String? userId;
  final String fullName;
  final String email;
  final String username;
  final String? password;
  final String? profileImage;

  AuthApiModel({
    this.userId,
    required this.fullName,
    required this.email,
    required this.username,
    this.password,
    this.profileImage,
  });

  // toJson
  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'username': username,
      'password': password,
      'profilePicture': profileImage,
    };
  }

  // fromJson
  factory AuthApiModel.fromJson(Map<String, dynamic> json) {
    return AuthApiModel(
      userId: json['_id'] as String? ?? json['userId'] as String?,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      username: json['username'] as String,
      password: json['password'] as String?,
      profileImage: json['profilePicture'] as String?,
    );
  }

  // toEntity
  AuthEntity toEntity() {
    return AuthEntity(
      userId: userId,
      fullName: fullName,
      email: email,
      username: username,
      profileImage: profileImage,
    );
  }

  // fromEntity - FIX: Include password!
  factory AuthApiModel.fromEntity(AuthEntity entity) {
    return AuthApiModel(
      userId: entity.userId,
      fullName: entity.fullName,
      email: entity.email,
      username: entity.username,
      password: entity.password, // <-- ADD THIS LINE
      profileImage: entity.profileImage,
    );
  }

  // toEntityList
  static List<AuthEntity> toEntityList(List<AuthApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
