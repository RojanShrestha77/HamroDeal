import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/api/api_client.dart';
import 'package:hamro_deal/core/api/api_endpoints.dart';
import 'package:hamro_deal/core/services/storage/token_service.dart';
import 'package:hamro_deal/features/product/data/datasources/product_datasource.dart';

// provider
final productRemoteDatasourceProvider = Provider<IProductRemoteDataSource>((
  ref,
) {
  return ProductRemoteDatasource(
    apiClient: ref.read(apiClientProvider),
    tokenService: ref.read(tokenServiceProvider),
  );
});

class ProductRemoteDatasource implements IProductRemoteDataSource {
  final ApiClient _apiClient;
  final TokenService _tokenService;

  ProductRemoteDatasource({
    required ApiClient apiClient,
    required TokenService tokenService,
  }) : _apiClient = apiClient,
       _tokenService = tokenService;

  @override
  Future<String> uploadImage(File image) async {
    final fileName = image.path.split('/').last;
    // fromdata = used when need ot send the pohot images or video and other data together
    // fromdata.fromMap() = converts a dart map  into formdata sop it can be as a multipart form data to the backend

    final formData = FormData.fromMap({
      'itemPhoto': await MultipartFile.fromFile(image.path, filename: fileName),
    });
    // get token from the token service
    final token = _tokenService.getToken();
    final response = await _apiClient.uploadFile(
      ApiEndpoints.itemUploadPhoto,
      formData: formData,
      options: Options(headers: {'authorization': 'Bearer $token'}),
    );
    var a = response.data['data'];
    return a;
  }

  @override
  Future<String> uploadVideo(File video) async {
    final fileName = video.path.split('/').last;
    // fromdata = used when need ot send the pohot images or video and other data together
    // fromdata.fromMap() = converts a dart map  into formdata sop it can be as a multipart form data to the backend

    final formData = FormData.fromMap({
      'itemVideo': await MultipartFile.fromFile(video.path, filename: fileName),
    });
    // get token from the token service
    final token = _tokenService.getToken();
    final response = await _apiClient.uploadFile(
      ApiEndpoints.itemUploadPhoto,
      formData: formData,
      options: Options(headers: {'authorization': 'Bearer $token'}),
    );
    var a = response.data['success'];
    return a;
  }
}
