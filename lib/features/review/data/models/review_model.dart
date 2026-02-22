import 'package:hamro_deal/features/review/domain/entities/review_entity.dart';

class ReviewModel {
  final String id;
  final String productId;
  final ReviewUserModel user;
  final int rating;
  final String comment;
  final DateTime createdAt;
  final DateTime updatedAt;

  ReviewModel({
    required this.id,
    required this.productId,
    required this.user,
    required this.rating,
    required this.comment,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['_id'],
      productId: json['productId'],
      user: ReviewUserModel.fromJson(json['userId']),
      rating: json['rating'],
      comment: json['comment'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  ReviewEntity toEntity() {
    return ReviewEntity(
      id: id,
      productId: productId,
      user: user.toEntity(),
      rating: rating,
      comment: comment,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

class ReviewUserModel {
  final String id;
  final String firstName;
  final String lastName;

  ReviewUserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
  });

  factory ReviewUserModel.fromJson(Map<String, dynamic> json) {
    return ReviewUserModel(
      id: json['_id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
    );
  }

  ReviewUserEntity toEntity() {
    return ReviewUserEntity(id: id, firstName: firstName, lastName: lastName);
  }
}
