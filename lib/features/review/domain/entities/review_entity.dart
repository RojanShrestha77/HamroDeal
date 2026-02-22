import 'package:equatable/equatable.dart';

class ReviewEntity extends Equatable {
  final String id;
  final String productId;
  final ReviewUserEntity user;
  final int rating;
  final String comment;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ReviewEntity({
    required this.id,
    required this.productId,
    required this.user,
    required this.rating,
    required this.comment,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    productId,
    user,
    rating,
    comment,
    createdAt,
    updatedAt,
  ];
}

class ReviewUserEntity extends Equatable {
  final String id;
  final String firstName;
  final String lastName;

  const ReviewUserEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
  });

  String get fullName => '$firstName $lastName';

  @override
  List<Object?> get props => [id, firstName, lastName];
}
