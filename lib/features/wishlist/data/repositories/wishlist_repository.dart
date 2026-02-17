import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/error/failures.dart';
import 'package:hamro_deal/core/services/connectivity/network_info.dart';
import 'package:hamro_deal/features/wishlist/data/datasources/remote/wishlist_remote_datasource.dart';
import 'package:hamro_deal/features/wishlist/data/datasources/wishlist_datasource.dart';
import 'package:hamro_deal/features/wishlist/domain/entities/wishlist_entity.dart';
import 'package:hamro_deal/features/wishlist/domain/repositories/wihslist_repository.dart';

final wishlistRepositoryProvider = Provider<IWishlistRepository>((ref) {
  return WishlistRepository(
    remoteDataSource: ref.read(wishlistRemoteDatasourceProvider),
    networkInfo: ref.read(networkInfoProvider),
  );
});

class WishlistRepository implements IWishlistRepository {
  final IWishlistRemoteDataSource _remoteDataSource;
  final INetworkInfo _networkInfo;

  WishlistRepository({
    required IWishlistRemoteDataSource remoteDataSource,
    required INetworkInfo networkInfo,
  }) : _remoteDataSource = remoteDataSource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, WishlistEntity>> addToWishlist(
    String productId,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final wishlist = await _remoteDataSource.addToWishlist(productId);
        return Right(wishlist.toEntity());
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message: e.response?.data['message'] ?? 'Failed to add to wishlist',
            statusCode: e.response?.statusCode,
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return Left(ApiFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, WishlistEntity>> getWishlist() async {
    if (await _networkInfo.isConnected) {
      try {
        final wishlist = await _remoteDataSource.getWishlist();
        return Right(wishlist.toEntity());
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message: e.response?.data['message'] ?? 'Failed to get wishlist',
            statusCode: e.response?.statusCode,
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return Left(ApiFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, bool>> removeFromWishlist(String productId) async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.removeFromWishlist(productId);
        return const Right(true);
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message:
                e.response?.data['message'] ?? 'Failed to remove from wishlist',
            statusCode: e.response?.statusCode,
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return Left(ApiFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, bool>> clearWishlist() async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.clearWishlist();
        return const Right(true);
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message: e.response?.data['message'] ?? 'Failed to clear wishlist',
            statusCode: e.response?.statusCode,
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return Left(ApiFailure(message: 'No internet connection'));
    }
  }
}
