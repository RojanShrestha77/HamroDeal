import 'package:hamro_deal/core/constants/hive_table_constants.dart';
import 'package:hamro_deal/features/auth/domain/entities/auth_entity.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'auth_hive_model.g.dart';

@HiveType(typeId: HiveTableConstants.authTypeId)
class AuthHiveModel extends HiveObject {
  @HiveField(0)
  final String? userId;

  @HiveField(1)
  final String? firstName;

  @HiveField(2)
  final String? lastName;

  @HiveField(3)
  final String userName;

  @HiveField(4)
  final String email;

  @HiveField(5)
  final String? password;

  @HiveField(6)
  final String? imageUrl;

  @HiveField(7)
  final String? role;

  @HiveField(8)
  final bool? isApproved;

  AuthHiveModel({
    String? userId,
    this.firstName,
    this.lastName,
    required this.userName,
    required this.email,
    this.password,
    this.imageUrl,
    this.role,
    this.isApproved,
  }) : userId = userId ?? const Uuid().v4();

  factory AuthHiveModel.fromEntity(AuthEntity entity) {
    return AuthHiveModel(
      userId: entity.userId,
      firstName: entity.firstName,
      lastName: entity.lastName,
      userName: entity.username,
      email: entity.email,
      password: entity.password,
      imageUrl: entity.imageUrl,
      role: entity.role,
      isApproved: entity.isApproved,
    );
  }

  AuthEntity toEntity() {
    return AuthEntity(
      userId: userId,
      firstName: firstName,
      lastName: lastName,
      username: userName,
      email: email,
      password: password,
      imageUrl: imageUrl,
      role: role,
      isApproved: isApproved,
    );
  }
}
