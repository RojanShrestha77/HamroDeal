import 'package:flutter/material.dart';
import 'package:hamro_deal/app/theme/theme_extensions.dart';

class ProductFormSectionHeader extends StatelessWidget {
  final String title;
  const ProductFormSectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: context.textPrimary,
      ),
    );
  }
}
