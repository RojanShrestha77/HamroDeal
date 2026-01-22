import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/error/failures.dart';
import 'package:hamro_deal/core/usecase/app_usecase.dart';
import 'package:hamro_deal/features/product/data/repositories/product_repository.dart';
import 'package:hamro_deal/features/product/domain/repositories/product_repository.dart';

final uploadVideoUsecaseProvider = Provider<UploadVideoUsecase>((ref) {
  final productRepository = ref.read(productRepositoryProvider);
  return UploadVideoUsecase(productRepository: productRepository);
});

class UploadVideoUsecase implements UsecaseWithParams<String, File> {
  final IProductRepository _productRepository;
  UploadVideoUsecase({required IProductRepository productRepository})
    : _productRepository = productRepository;

  @override
  Future<Either<Failure, String>> call(File video) {
    return _productRepository.uploadVideo(video);
  }
}
