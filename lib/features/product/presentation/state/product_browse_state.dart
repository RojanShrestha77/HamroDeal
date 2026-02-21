import 'package:equatable/equatable.dart';
import 'package:hamro_deal/features/product/domain/entities/product_entity.dart';

enum ProductBrowseStatus { initial, loading, success, error }

class ProductBrowseState extends Equatable {
  final ProductBrowseStatus status;
  final List<ProductEntity> products;
  final String? error;

  // current filter vcalues
  final String? selectedCategoryId;
  final String? searchQuery;
  final double? minPrice;
  final double? maxPrice;
  final String? sortOption;

  const ProductBrowseState({
    required this.status,
    required this.products,
    this.error,
    this.selectedCategoryId,
    this.searchQuery,
    this.minPrice,
    this.maxPrice,
    this.sortOption,
  });

  // intila state
  factory ProductBrowseState.initial() {
    return const ProductBrowseState(
      status: ProductBrowseStatus.initial,
      products: [],
    );
  }

  // cehck if any filter is applied
  bool get hasFilters =>
      selectedCategoryId != null ||
      searchQuery != null ||
      minPrice != null ||
      maxPrice != null ||
      sortOption != null;

  // copy with method
  ProductBrowseState copyWith({
    ProductBrowseStatus? status,
    List<ProductEntity>? products,
    String? error,
    String? selectedCategoryId,
    String? searchQuery,
    double? minPrice,
    double? maxPrice,
    String? sortOption,
    bool clearCategoryId = false,
    bool clearSearch = false,
    bool clearMinPrice = false,
    bool clearMaxPrice = false,
    bool clearSort = false,
    bool clearError = false,
  }) {
    return ProductBrowseState(
      status: status ?? this.status,
      products: products ?? this.products,
      error: clearError ? null : (error ?? this.error),
      selectedCategoryId: clearCategoryId
          ? null
          : (selectedCategoryId ?? this.selectedCategoryId),
      searchQuery: clearSearch ? null : (searchQuery ?? this.searchQuery),
      minPrice: clearMinPrice ? null : (minPrice ?? this.minPrice),
      maxPrice: clearMaxPrice ? null : (maxPrice ?? this.maxPrice),
      sortOption: clearSort ? null : (sortOption ?? this.sortOption),
    );
  }

  @override
  List<Object?> get props => [
    status,
    products,
    error,
    selectedCategoryId,
    searchQuery,
    minPrice,
    maxPrice,
    sortOption,
  ];
}
