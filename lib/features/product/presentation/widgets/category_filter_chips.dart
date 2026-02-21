import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/features/category/domain/usecases/get_all_categories_usecase.dart';
import 'package:hamro_deal/features/category/presentation/view_model/category_viewmodel.dart';

class CategoryFilterChips extends ConsumerStatefulWidget {
  final String? selectedCategoryId;
  final Function(String?) onCategorySelected;

  const CategoryFilterChips({
    super.key,
    this.selectedCategoryId,
    required this.onCategorySelected,
  });

  @override
  ConsumerState<CategoryFilterChips> createState() =>
      _CategoryFilterChipsState();
}

class _CategoryFilterChipsState extends ConsumerState<CategoryFilterChips> {
  @override
  void initState() {
    super.initState();
    // Load categories
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(categoryViewModelProvider.notifier).getAllCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    final categoryState = ref.watch(categoryViewModelProvider);

    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: const Text('All'),
              selected: widget.selectedCategoryId == null,
              onSelected: (_) => widget.onCategorySelected(null),
              backgroundColor: Colors.grey.shade200,
              selectedColor: Colors.blue,
              labelStyle: TextStyle(
                color: widget.selectedCategoryId == null
                    ? Colors.white
                    : Colors.black87,
                fontWeight: widget.selectedCategoryId == null
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          ),
          // Category chips
          ...categoryState.categories.map((category) {
            final isSelected = widget.selectedCategoryId == category.categoryId;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(category.name),
                selected: isSelected,
                onSelected: (_) =>
                    widget.onCategorySelected(category.categoryId),
                backgroundColor: Colors.grey.shade200,
                selectedColor: Colors.blue,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
