import 'package:hamro_deal/core/constants/hive_table_constants.dart';
import 'package:hamro_deal/features/auth/domain/entities/auth_entity.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'auth_hive_model.g.dart'; // ← Critical line

@HiveType(typeId: HiveTableConstants.authTypeId)
class AuthHiveModel extends HiveObject {
  @HiveField(0)
  final String? userId;

  @HiveField(1)
  final String userName;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String? password;

  @HiveField(4)
  final String? profileImage;

  AuthHiveModel({
    String? userId,
    required this.userName,
    required this.email,
    this.password,
    this.profileImage,
  }) : userId = userId ?? const Uuid().v4();

  factory AuthHiveModel.fromEntity(AuthEntity entity) {
    return AuthHiveModel(
      userId: entity.userId,
      userName: entity.userName,
      email: entity.email,
      password: entity.password,
      profileImage: entity.profileImage,
    );
  }

  AuthEntity toEntity() {
    return AuthEntity(
      userId: userId,
      userName: userName,
      email: email,
      password: password,
      profileImage: profileImage,
    );
  }
}
