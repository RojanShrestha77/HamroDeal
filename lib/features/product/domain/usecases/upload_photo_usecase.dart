import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/error/failures.dart';
import 'package:hamro_deal/core/usecase/app_usecase.dart';
import 'package:hamro_deal/features/product/data/repositories/product_repository.dart';
import 'package:hamro_deal/features/product/domain/repositories/product_repository.dart';

final uploadPhotoUsecaseProvider = Provider<UploadPhotoUsecase>((ref) {
  final productRepostory = ref.read(productRepositoryProvider);
  return UploadPhotoUsecase(productRepository: productRepostory);
});

class UploadPhotoUsecase implements UsecaseWithParams<String, File> {
  final IProductRepository _productRepository;
  UploadPhotoUsecase({required IProductRepository productRepository})
    : _productRepository = productRepository;

  @override
  Future<Either<Failure, String>> call(File photo) {
    return _productRepository.uploadPhoto(photo);
  }
}
