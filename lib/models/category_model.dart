import 'package:flutter/material.dart';

class CategoryModel {
  final String id;
  final String name;
  // final String categoryId;
  // final String subcategoryId;
  final IconData icon;

  const CategoryModel({
    required this.id,
    required this.name,
    // required this.categoryId,
    // required this.subcategoryId,
    required this.icon,
  });
}
