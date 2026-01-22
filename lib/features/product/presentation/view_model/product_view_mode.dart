import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/features/product/domain/usecases/create_product_usecase.dart';
import 'package:hamro_deal/features/product/domain/usecases/delete_product_usecase.dart';
import 'package:hamro_deal/features/product/domain/usecases/get_all_products_usecase.dart';
import 'package:hamro_deal/features/product/domain/usecases/get_product_by_id_usecase.dart';
import 'package:hamro_deal/features/product/domain/usecases/get_product_by_user_usecase.dart';
import 'package:hamro_deal/features/product/domain/usecases/update_product_usecase.dart';
import 'package:hamro_deal/features/product/domain/usecases/upload_photo_usecase.dart';
import 'package:hamro_deal/features/product/domain/usecases/upload_video_usecase.dart';
import 'package:hamro_deal/features/product/presentation/state/product_state.dart';

class ProductViewModel extends Notifier<ProductState> {
  late final GetAllProductsUsecase _getAllProductsUsecase;
  late final CreateProductUsecase _createProductUsecase;
  late final DeleteProductUsecase _deleteProductUsecase;
  late final GetProductByIdUsecase _getProductByIdUsecase;
  late final GetProductByUserUsecase _getProductByUserUsecase;
  late final UpdateProductUsecase _updateProductUsecase;
  late final UploadPhotoUsecase _uploadPhotoUsecase;
  late final UploadVideoUsecase _uploadVideoUsecase;
  @override
  ProductState build() {
    _getAllProductsUsecase = ref.read(getAllProductsUsecaseProvider);
    _createProductUsecase = ref.read(createProductUsecaseProvider);
    _deleteProductUsecase = ref.read(deleteProductUsecaseProvider);
    _getProductByIdUsecase = ref.read(getProductsByIdUsecaseProvider);
    _getProductByUserUsecase = ref.read(getProductsByUserUsecaseProvider);
    _updateProductUsecase = ref.read(updateUsecaseProvider);
    _uploadPhotoUsecase = ref.read(uploadPhotoUsecaseProvider);
    _uploadVideoUsecase = ref.read(uploadVideoUsecaseProvider);
    return const ProductState();
  }

  Future<void> getAllProducts() async {
    state = state.copyWith(status: ProductStatus.loading);
    final result = await _getAllProductsUsecase();

    result.fold(
      (failure) => state = state.copyWith(
        status: ProductStatus.error,
        errorMessage: failure.message,
      ),
      (products) => state = state.copyWith(
        status: ProductStatus.loaded,
        products: products,
      ),
    );
  }

  Future<void> getProductsById(String productId) async {
    state = state.copyWith(status: ProductStatus.loading);

    final result = await _getProductByIdUsecase(
      GetProductByIdParams(productId: productId),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: ProductStatus.error,
        errorMessage: failure.message,
      ),
      (product) => state = state.copyWith(
        status: ProductStatus.loaded,
        selectedProduct: product,
      ),
    );
  }

  Future<void> getMyProducts(String userId) async {
    state = state.copyWith(status: ProductStatus.loading);
    final result = await _getProductByUserUsecase(
      GetProductByUserParams(userId: userId),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: ProductStatus.error,
        errorMessage: failure.message,
      ),
      (products) {
        state = state.copyWith(
          status: ProductStatus.loaded,
          myProducts: products,
        );
      },
    );
  }

  Future<void> createProduct({
    required String title,
    required String description,
    required double price,
    required int quantity,
    required String category,
    String? media,
    String? mediaType,
  }) async {
    state = state.copyWith(status: ProductStatus.loading);

    final params = CreateProductParams(
      title: title,
      description: description,
      price: price,
      quantity: quantity,
      category: category,
      media: media,
      mediaType: mediaType,
    );

    final result = await _createProductUsecase(params);

    result.fold(
      (failure) => state = state.copyWith(
        status: ProductStatus.error,
        errorMessage: failure.message,
      ),
      (isCreated) {
        state = state.copyWith(
          status: ProductStatus.created,
          resetUploadedMediaUrl: true,
        );
        getAllProducts();
      },
    );
  }

  Future<void> updateProduct({
    required String productId,
    required String title,
    required String description,
    required double price,
    required int quantity,
    required String category,
    String? media,
    String? mediaType,
    bool isClaimed = false,
    String? status,
  }) async {
    state = state.copyWith(status: ProductStatus.loading);

    final params = UpdateProductParams(
      productId: productId,
      title: title,
      description: description,
      price: price,
      quantity: quantity,
      category: category,
      media: media,
      mediaType: mediaType,
      isClaimed: isClaimed,
      status: status,
    );

    final result = await _updateProductUsecase(params);

    result.fold(
      (failure) => state = state.copyWith(
        status: ProductStatus.error,
        errorMessage: failure.message,
      ),
      (isUpdated) {
        state = state.copyWith(
          status: ProductStatus.updated,
          resetUploadedMediaUrl: true,
        );
        getAllProducts();
      },
    );
  }

  Future<void> deleteProduct(String productId) async {
    state = state.copyWith(status: ProductStatus.loading);

    final result = await _deleteProductUsecase(
      DeleteProductParams(productId: productId),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: ProductStatus.error,
        errorMessage: failure.message,
      ),
      (isDeleted) {
        state = state.copyWith(status: ProductStatus.deleted);
        getAllProducts();
      },
    );
  }

  Future<String?> uploadPhoto(File photo) async {
    state = state.copyWith(status: ProductStatus.loaded);

    final result = await _uploadPhotoUsecase(photo);

    return result.fold(
      (failure) {
        state = state.copyWith(
          status: ProductStatus.error,
          errorMessage: failure.message,
        );
        return null;
      },
      (url) {
        state = state.copyWith(
          status: ProductStatus.loaded,
          uploadedMediaUrl: url,
        );
        return url;
      },
    );
  }

  Future<String?> uploadVideo(File video) async {
    state = state.copyWith(status: ProductStatus.loaded);

    final result = await _uploadVideoUsecase(video);

    return result.fold(
      (failure) {
        state = state.copyWith(
          status: ProductStatus.error,
          errorMessage: failure.message,
        );
        return null;
      },
      (url) {
        state = state.copyWith(
          status: ProductStatus.loaded,
          uploadedMediaUrl: url,
        );
        return url;
      },
    );
  }

  void clearError() {
    state = state.copyWith(resetErrorMessage: true);
  }

  void clearSelecetedItem() {
    state = state.copyWith(resetSelectedProduct: true);
  }

  void clearReportState() {
    state = state.copyWith(
      resetErrorMessage: true,
      resetUploadedMediaUrl: true,
    );
  }
}
