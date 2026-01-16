import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String? userId;
  final String fullName;
  final String username;
  final String email;
  final String? password;
  final String? profileImage;

  AuthEntity({
    this.userId,
    required this.fullName,
    required this.username,
    required this.email,
    this.password,
    this.profileImage,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    email,
    profileImage,
    username,
    password,
    fullName,
  ];
}
