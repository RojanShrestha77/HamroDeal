import 'package:flutter/material.dart';
import 'package:hamro_deal/app/theme/app_colors.dart';
import 'package:hamro_deal/app/theme/theme_extensions.dart';
import 'package:hamro_deal/features/category/domain/entities/category_entitty.dart';

class ProductCategoryChipSelector extends StatelessWidget {
  final List<CategoryEntity> categories;
  final String? selectedCategoryId;
  final ValueChanged<String> onCategorySelected;

  const ProductCategoryChipSelector({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
    required this.onCategorySelected,
  });

  IconData _icon(String name) {
    switch (name.toLowerCase()) {
      case 'fashion':
        return Icons.checkroom_rounded;
      case 'electronics':
        return Icons.devices_rounded;
      case 'beauty':
        return Icons.brush_rounded;
      case 'jewellery':
        return Icons.diamond_rounded;
      case 'footwear':
        return Icons.hiking_rounded;
      case 'toys':
        return Icons.toys_rounded;
      case 'furniture':
        return Icons.chair_rounded;
      case 'home & living':
        return Icons.weekend_rounded;
      case 'sports':
        return Icons.sports_soccer_rounded;
      default:
        return Icons.category_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.surfaceColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: context.softShadow,
        ),
        child: Center(
          child: Text(
            'Loading categories...',
            style: TextStyle(color: context.textSecondary),
          ),
        ),
      );
    }

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: categories.map((c) {
        final isSelected = selectedCategoryId == c.categoryId;

        return GestureDetector(
          onTap: () {
            if (c.categoryId != null) onCategorySelected(c.categoryId!);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              gradient: isSelected ? AppColors.primaryGradient : null,
              color: isSelected ? null : context.surfaceColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: context.softShadow,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _icon(c.name),
                  size: 18,
                  color: isSelected ? Colors.white : context.textSecondary,
                ),
                const SizedBox(width: 8),
                Text(
                  c.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: isSelected ? Colors.white : context.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
