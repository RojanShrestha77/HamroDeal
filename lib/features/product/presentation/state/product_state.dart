import 'package:equatable/equatable.dart';
import 'package:hamro_deal/features/product/domain/entities/product_entity.dart';

enum ProductStatus {
  initial,
  loading,
  loaded,
  error,
  created,
  updated,
  deleted,
}

class ProductState extends Equatable {
  final ProductStatus status;
  final List<ProductEntity> products;
  final List<ProductEntity> claimedProducts;
  final List<ProductEntity> unclaimedProducts;
  final List<ProductEntity> myProducts;
  final List<ProductEntity> productsByCategory;
  final ProductEntity? selectedProduct;
  final String? errorMessage;
  final String? uploadedMediaUrl;

  const ProductState({
    this.status = ProductStatus.initial,
    this.products = const [],
    this.claimedProducts = const [],
    this.unclaimedProducts = const [],
    this.myProducts = const [],
    this.productsByCategory = const [],
    this.selectedProduct,
    this.errorMessage,
    this.uploadedMediaUrl,
  });

  ProductState copyWith({
    ProductStatus? status,
    List<ProductEntity>? products,
    List<ProductEntity>? claimedProducts,
    List<ProductEntity>? unclaimedProducts,
    List<ProductEntity>? myProducts,
    List<ProductEntity>? productsByCategory,
    ProductEntity? selectedProduct,
    bool resetSelectedProduct = false,
    String? errorMessage,
    bool resetErrorMessage = false,
    String? uploadedMediaUrl,
    bool resetUploadedMediaUrl = false,
  }) {
    return ProductState(
      status: status ?? this.status,
      products: products ?? this.products,
      claimedProducts: claimedProducts ?? this.claimedProducts,
      unclaimedProducts: unclaimedProducts ?? this.unclaimedProducts,
      myProducts: myProducts ?? this.myProducts,
      productsByCategory: productsByCategory ?? this.productsByCategory,
      selectedProduct: resetSelectedProduct
          ? null
          : (selectedProduct ?? this.selectedProduct),
      errorMessage: resetErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
      uploadedMediaUrl: resetUploadedMediaUrl
          ? null
          : (uploadedMediaUrl ?? this.uploadedMediaUrl),
    );
  }

  @override
  List<Object?> get props => [
    status,
    products,
    claimedProducts,
    unclaimedProducts,
    myProducts,
    productsByCategory,
    selectedProduct,
    errorMessage,
    uploadedMediaUrl,
  ];
}
