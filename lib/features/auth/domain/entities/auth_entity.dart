class AuthEntity {
  final String? userId;
  final String userName;
  final String email;
  final String? password;
  final String? profileImage;

  AuthEntity({
    this.userId,
    required this.userName,
    required this.email,
    this.password,
    this.profileImage,
  });
}
