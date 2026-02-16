import 'package:hamro_deal/features/auth/domain/entities/auth_entity.dart';

class AuthApiModel {
  final String? userId;
  final String? firstName;
  final String? lastName;
  final String email;
  final String username;
  final String? password;
  final String? imageUrl;
  final String? role;
  final bool? isApproved;

  AuthApiModel({
    this.userId,
    this.firstName,
    this.lastName,
    required this.email,
    required this.username,
    this.password,
    this.imageUrl,
    this.role,
    this.isApproved,
  });

  Map<String, dynamic> toJson() {
    return {
      if (firstName != null) 'firstName': firstName,
      if (lastName != null) 'lastName': lastName,
      'email': email,
      'username': username,
      if (password != null) 'password': password,
      if (imageUrl != null) 'imageUrl': imageUrl,
      if (role != null) 'role': role,
    };
  }

  factory AuthApiModel.fromJson(Map<String, dynamic> json) {
    return AuthApiModel(
      userId: json['_id'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      email: json['email'] as String,
      username: json['username'] as String,
      password: json['password'] as String?,
      imageUrl: json['imageUrl'] as String?,
      role: json['role'] as String?,
      isApproved: json['isApproved'] as bool?,
    );
  }

  AuthEntity toEntity() {
    return AuthEntity(
      userId: userId,
      firstName: firstName,
      lastName: lastName,
      email: email,
      username: username,
      password: password,
      imageUrl: imageUrl,
      role: role,
      isApproved: isApproved,
    );
  }

  factory AuthApiModel.fromEntity(AuthEntity entity) {
    return AuthApiModel(
      userId: entity.userId,
      firstName: entity.firstName,
      lastName: entity.lastName,
      email: entity.email,
      username: entity.username,
      password: entity.password,
      imageUrl: entity.imageUrl,
      role: entity.role,
      isApproved: entity.isApproved,
    );
  }

  static List<AuthEntity> toEntityList(List<AuthApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
