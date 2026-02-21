import 'dart:async';

import 'package:hamro_deal/features/product/domain/usecases/get_filtered_products_usecase.dart';
import 'package:hamro_deal/features/product/presentation/state/product_browse_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productBrowseViewModelProvider =
    NotifierProvider<ProductBrowseViewModel, ProductBrowseState>(
      () => ProductBrowseViewModel(),
    );

class ProductBrowseViewModel extends Notifier<ProductBrowseState> {
  late final GetFilteredProductsUsecase _getFilteredProductsUsecase;
  Timer? _debounceTimer;
  @override
  ProductBrowseState build() {
    _getFilteredProductsUsecase = ref.read(getFilteredProductsUsecaseProvider);
    loadProducts();
    return ProductBrowseState.initial();
  }

  Future<void> loadProducts() async {
    state = state.copyWith(status: ProductBrowseStatus.loading);

    final params = GetFilteredProductsParams(
      categoryId: state.selectedCategoryId,
      search: state.searchQuery,
      minPrice: state.minPrice,
      maxPrice: state.maxPrice,
      sort: state.sortOption,
    );

    final result = await _getFilteredProductsUsecase.call(params);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: ProductBrowseStatus.error,
          error: failure.message,
        );
      },
      (products) {
        state = state.copyWith(
          status: ProductBrowseStatus.success,
          products: products,
          clearError: true,
        );
      },
    );
  }

  // update category filter
  void selectCategory(String? categoryId) {
    if (categoryId == null) {
      // Clear category filter when "All" is selected
      state = state.copyWith(clearCategoryId: true);
    } else if (categoryId == state.selectedCategoryId) {
      // Toggle off if same category is clicked
      state = state.copyWith(clearCategoryId: true);
    } else {
      // Select new category
      state = state.copyWith(selectedCategoryId: categoryId);
    }
    loadProducts();
  }

  // Update search query with debounce
  void updateSearch(String query) {
    _debounceTimer?.cancel();

    // uupdate state immediattely for ui
    state = state.copyWith(
      searchQuery: query.isEmpty ? null : query,
      clearSearch: query.isEmpty,
    );

    // debounce
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      loadProducts();
    });
  }

  // update price range
  void updatePriceRange({double? minPrice, double? maxPrice}) {
    state = state.copyWith(
      minPrice: minPrice,
      maxPrice: maxPrice,
      clearMinPrice: minPrice == null,
      clearMaxPrice: maxPrice == null,
    );
    loadProducts();
  }

  // update sort option
  void updateSort(String? sortOption) {
    state = state.copyWith(
      sortOption: sortOption,
      clearSort: sortOption == null,
    );
    loadProducts();
  }

  // clear all filters
  void clearFilters() {
    state = state.copyWith(
      clearCategoryId: true,
      clearSearch: true,
      clearMinPrice: true,
      clearMaxPrice: true,
      clearSort: true,
    );
    loadProducts();
  }

  // refresh poroducts
  Future<void> refresh() async {
    await loadProducts();
  }
}
