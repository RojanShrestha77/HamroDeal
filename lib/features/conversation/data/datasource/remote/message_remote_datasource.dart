import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/api/api_client.dart';
import 'package:hamro_deal/core/api/api_endpoints.dart';
import 'package:hamro_deal/core/services/storage/token_service.dart';
import 'package:hamro_deal/features/conversation/data/datasource/message_datasource.dart';
import 'package:hamro_deal/features/conversation/data/model/conversation_model.dart';
import 'package:hamro_deal/features/conversation/data/model/message_model.dart';

final messagingRemoteDataSourceProvider = Provider<IMessagingDataSource>((ref) {
  return MessagingRemoteDataSource(
    apiClient: ref.read(apiClientProvider),
    tokenService: ref.read(tokenServiceProvider),
  );
});

class MessagingRemoteDataSource implements IMessagingDataSource {
  final ApiClient _apiClient;
  final TokenService _tokenService;

  MessagingRemoteDataSource({
    required ApiClient apiClient,
    required TokenService tokenService,
  })  : _apiClient = apiClient,
        _tokenService = tokenService;

  // ============ Conversation Methods ============

  @override
  Future<ConversationModel> createOrGetConversation(String sellerId) async {
    final token = _tokenService.getToken();

    final response = await _apiClient.post(
      ApiEndpoints.createOrGetConversation,
      data: {'otherUserId': sellerId}, // Backend expects 'otherUserId' not 'sellerId'
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return ConversationModel.fromJson(response.data['data']);
  }

  @override
  Future<List<ConversationModel>> getAllConversations() async {
    final token = _tokenService.getToken();

    final response = await _apiClient.get(
      ApiEndpoints.conversations,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    // Backend returns: { data: { conversations: [...], total, page, size } }
    final responseData = response.data['data'];
    
    // Check if conversations exists and is a List
    if (responseData['conversations'] is! List) {
      return [];
    }
    
    final List<dynamic> conversationsList = responseData['conversations'];
    return conversationsList
        .map((json) => ConversationModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<ConversationModel> getConversationById(String id) async {
    final token = _tokenService.getToken();

    final response = await _apiClient.get(
      ApiEndpoints.conversationById(id),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return ConversationModel.fromJson(response.data['data']);
  }

  @override
  Future<void> deleteConversation(String id) async {
    final token = _tokenService.getToken();

    await _apiClient.delete(
      ApiEndpoints.deleteConversation(id),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }

  @override
  Future<void> resetUnreadCount(String id) async {
    final token = _tokenService.getToken();

    await _apiClient.put(
      ApiEndpoints.resetUnreadCount(id),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }

  // ============ Message Methods ============

  @override
  Future<List<MessageModel>> getConversationMessages(
    String conversationId,
  ) async {
    final token = _tokenService.getToken();

    final response = await _apiClient.get(
      ApiEndpoints.messagesByConversation(conversationId),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    // Backend might return: { data: [...] } or { data: { messages: [...] } }
    final data = response.data['data'];
    
    List<dynamic> messagesList;
    if (data is List) {
      messagesList = data;
    } else if (data is Map && data['messages'] is List) {
      messagesList = data['messages'];
    } else {
      return [];
    }
    
    return messagesList.map((json) => MessageModel.fromJson(json as Map<String, dynamic>)).toList();
  }

  @override
  Future<MessageModel> sendMessage(
    String conversationId,
    String content,
  ) async {
    final token = _tokenService.getToken();

    final response = await _apiClient.post(
      ApiEndpoints.messages,
      data: {
        'conversationId': conversationId,
        'content': content,
      },
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return MessageModel.fromJson(response.data['data']);
  }

  @override
  Future<void> deleteMessage(String id) async {
    final token = _tokenService.getToken();

    await _apiClient.delete(
      ApiEndpoints.deleteMessage(id),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }

  @override
  Future<void> markMessagesAsRead(String conversationId) async {
    final token = _tokenService.getToken();

    await _apiClient.put(
      ApiEndpoints.markMessagesAsRead(conversationId),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }
}
