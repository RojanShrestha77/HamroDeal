import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/error/failures.dart';
import 'package:hamro_deal/core/services/connectivity/network_info.dart';
import 'package:hamro_deal/features/notification/data/datasource/remote/notification_remote_datasource.dart';
import 'package:hamro_deal/features/notification/data/datasource/remote_datasource.dart';
import 'package:hamro_deal/features/notification/domain/entity/notification_entity.dart';
import 'package:hamro_deal/features/notification/domain/repositories/notification_repository.dart';

final notificationRepositoryProvider = Provider<INotificationRepository>((ref) {
  final remoteDataSource = ref.read(notificationRemoteDataSourceProvider);
  final networkInfo = ref.read(networkInfoProvider);
  return NotificationRepositoryImpl(
    remoteDataSource: remoteDataSource,
    networkInfo: networkInfo,
  );
});

class NotificationRepositoryImpl implements INotificationRepository {
  final INotificationDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  NotificationRepositoryImpl({
    required INotificationDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  }) : _remoteDataSource = remoteDataSource,
       _networkInfo = networkInfo;

  @override
  Future<Either<ApiFailure, List<NotificationEntity>>> getAllNotifications({
    required int page,
    required int size,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final models = await _remoteDataSource.getAllNotifications(
          page: page,
          size: size,
        );
        final entities = models.map((model) => model.toEntity()).toList();
        return Right(entities);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return const Left(ApiFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<ApiFailure, int>> getUnreadCount() async {
    if (await _networkInfo.isConnected) {
      try {
        final count = await _remoteDataSource.getUnreadCount();
        return Right(count);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return const Left(ApiFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<ApiFailure, NotificationEntity>> markAsRead(
    String notificationId,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final model = await _remoteDataSource.markAsRead(notificationId);
        return Right(model.toEntity());
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return const Left(ApiFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<ApiFailure, void>> markAllAsRead() async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.markAllAsRead();
        return const Right(null);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return const Left(ApiFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<ApiFailure, void>> deleteNotification(
    String notificationId,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.deleteNotification(notificationId);
        return const Right(null);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return const Left(ApiFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<ApiFailure, void>> deleteAllNotifications() async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.deleteAllNotifications();
        return const Right(null);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return const Left(ApiFailure(message: 'No internet connection'));
    }
  }
}
