import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String? userId;
  final String? firstName;
  final String? lastName;
  final String username;
  final String email;
  final String? password;
  final String? confirmPassword;
  final String? imageUrl;
  final String? role;
  final bool? isApproved;

  AuthEntity({
    this.userId,
    this.firstName,
    this.lastName,
    required this.username,
    required this.email,
    this.password,
    this.confirmPassword,
    this.imageUrl,
    this.role,
    this.isApproved,
  });

  String get fullName => '${firstName ?? ''} ${lastName ?? ''}'.trim();

  @override
  List<Object?> get props => [
    userId,
    firstName,
    lastName,
    email,
    imageUrl,
    username,
    password,
    confirmPassword,
    role,
    isApproved,
  ];
}
