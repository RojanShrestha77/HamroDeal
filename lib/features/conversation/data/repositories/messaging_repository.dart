import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/error/failures.dart';
import 'package:hamro_deal/core/services/connectivity/network_info.dart';
import 'package:hamro_deal/features/conversation/data/datasource/message_datasource.dart';
import 'package:hamro_deal/features/conversation/data/datasource/remote/message_remote_datasource.dart';
import 'package:hamro_deal/features/conversation/domain/entity/conversation_entity.dart';
import 'package:hamro_deal/features/conversation/domain/entity/message_entity.dart';
import 'package:hamro_deal/features/conversation/domain/repositories/messaging_repository.dart';

final messagingRepositoryProvider = Provider<IMessagingRepository>((ref) {
  final remoteDataSource = ref.read(messagingRemoteDataSourceProvider);
  final networkInfo = ref.read(networkInfoProvider);
  return MessagingRepositoryImpl(
    remoteDataSource: remoteDataSource,
    networkInfo: networkInfo,
  );
});

class MessagingRepositoryImpl implements IMessagingRepository {
  final IMessagingDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  MessagingRepositoryImpl({
    required IMessagingDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  }) : _remoteDataSource = remoteDataSource,
       _networkInfo = networkInfo;

  // ============ Conversation Methods ============

  @override
  Future<Either<ApiFailure, ConversationEntity>> createOrGetConversation(
    String sellerId,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final model = await _remoteDataSource.createOrGetConversation(sellerId);
        return Right(model.toEntity());
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return const Left(ApiFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<ApiFailure, List<ConversationEntity>>>
  getAllConversations() async {
    if (await _networkInfo.isConnected) {
      try {
        final models = await _remoteDataSource.getAllConversations();
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
  Future<Either<ApiFailure, ConversationEntity>> getConversationById(
    String id,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final model = await _remoteDataSource.getConversationById(id);
        return Right(model.toEntity());
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return const Left(ApiFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<ApiFailure, void>> deleteConversation(String id) async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.deleteConversation(id);
        return const Right(null);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return const Left(ApiFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<ApiFailure, void>> resetUnreadCount(String id) async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.resetUnreadCount(id);
        return const Right(null);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return const Left(ApiFailure(message: 'No internet connection'));
    }
  }

  // ============ Message Methods ============

  @override
  Future<Either<ApiFailure, List<MessageEntity>>> getConversationMessages(
    String conversationId,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final models = await _remoteDataSource.getConversationMessages(
          conversationId,
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
  Future<Either<ApiFailure, MessageEntity>> sendMessage(
    String conversationId,
    String content,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final model = await _remoteDataSource.sendMessage(
          conversationId,
          content,
        );
        return Right(model.toEntity());
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return const Left(ApiFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<ApiFailure, void>> deleteMessage(String id) async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.deleteMessage(id);
        return const Right(null);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return const Left(ApiFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<ApiFailure, void>> markMessagesAsRead(
    String conversationId,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.markMessagesAsRead(conversationId);
        return const Right(null);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return const Left(ApiFailure(message: 'No internet connection'));
    }
  }
}
