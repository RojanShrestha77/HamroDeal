import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/error/failures.dart';
import 'package:hamro_deal/core/services/connectivity/network_info.dart';
import 'package:hamro_deal/features/cart/data/datasources/cart_datasource.dart';
import 'package:hamro_deal/features/cart/data/datasources/remote/cart_remote_datasource.dart';
import 'package:hamro_deal/features/cart/domain/entities/cart_entity.dart';
import 'package:hamro_deal/features/cart/domain/repositories/cart_repository.dart';

final cartRepositoryProvider = Provider<ICartRepository>((ref) {
  return CartRepository(
    remoteDataSource: ref.read(cartRemoteDatasourceProvider),
    networkInfo: ref.read(networkInfoProvider),
  );
});

class CartRepository implements ICartRepository {
  final ICartRemoteDataSource _remoteDataSource;
  final INetworkInfo _networkInfo;

  CartRepository({
    required ICartRemoteDataSource remoteDataSource,
    required INetworkInfo networkInfo,
  }) : _remoteDataSource = remoteDataSource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, CartEntity>> addToCart(
    String productId,
    int quantity,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final cart = await _remoteDataSource.addToCart(productId, quantity);
        return Right(cart.toEntity());
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message: e.response?.data['message'] ?? 'Failed to add to cart',
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
  Future<Either<Failure, CartEntity>> getCart() async {
    if (await _networkInfo.isConnected) {
      try {
        final cart = await _remoteDataSource.getCart();
        return Right(cart.toEntity());
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message: e.response?.data['message'] ?? 'Failed to get cart',
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
  Future<Either<Failure, CartEntity>> updateCartItem(
    String productId,
    int quantity,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final cart = await _remoteDataSource.updateCartItem(
          productId,
          quantity,
        );
        return Right(cart.toEntity());
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message: e.response?.data['message'] ?? 'Failed to update cart',
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
  Future<Either<Failure, bool>> removeFromCart(String productId) async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.removeFromCart(productId);
        return const Right(true);
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message:
                e.response?.data['message'] ?? 'Failed to remove from cart',
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
  Future<Either<Failure, bool>> clearCart() async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.clearCart();
        return const Right(true);
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message: e.response?.data['message'] ?? 'Failed to clear cart',
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
