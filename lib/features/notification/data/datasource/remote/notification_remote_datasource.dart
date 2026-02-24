import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/api/api_client.dart';
import 'package:hamro_deal/core/api/api_endpoints.dart';
import 'package:hamro_deal/core/services/storage/token_service.dart';
import 'package:hamro_deal/features/notification/data/model/notification_model.dart';
import 'package:hamro_deal/features/notification/data/datasource/remote_datasource.dart';

final notificationRemoteDataSourceProvider = Provider<INotificationDataSource>((
  ref,
) {
  return NotificationRemoteDataSource(
    apiClient: ref.read(apiClientProvider),
    tokenService: ref.read(tokenServiceProvider),
  );
});

class NotificationRemoteDataSource implements INotificationDataSource {
  final ApiClient _apiClient;
  final TokenService _tokenService;

  NotificationRemoteDataSource({
    required ApiClient apiClient,
    required TokenService tokenService,
  }) : _apiClient = apiClient,
       _tokenService = tokenService;

  @override
  Future<List<NotificationModel>> getAllNotifications({
    required int page,
    required int size,
  }) async {
    final token = _tokenService.getToken();

    final response = await _apiClient.get(
      '${ApiEndpoints.notifications}?page=$page&size=$size',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    final responseData = response.data['data'];
    final List<dynamic> notificationsList;

    if (responseData is Map && responseData.containsKey('notifications')) {
      notificationsList = responseData['notifications'] as List;
    } else if (responseData is List) {
      notificationsList = responseData;
    } else {
      notificationsList = [];
    }

    return notificationsList
        .map((json) => NotificationModel.fromJson(json))
        .toList();
  }

  @override
  Future<int> getUnreadCount() async {
    final token = _tokenService.getToken();

    final response = await _apiClient.get(
      ApiEndpoints.notificationsUnreadCount,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return response.data['data']['count'] ?? 0;
  }

  @override
  Future<NotificationModel> markAsRead(String notificationId) async {
    final token = _tokenService.getToken();

    final response = await _apiClient.patch(
      ApiEndpoints.markNotificationAsRead(notificationId),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return NotificationModel.fromJson(response.data['data']);
  }

  @override
  Future<void> markAllAsRead() async {
    final token = _tokenService.getToken();

    await _apiClient.patch(
      ApiEndpoints.notificationsMarkAllRead,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }

  @override
  Future<void> deleteNotification(String notificationId) async {
    final token = _tokenService.getToken();

    await _apiClient.delete(
      ApiEndpoints.deleteNotification(notificationId),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }

  @override
  Future<void> deleteAllNotifications() async {
    final token = _tokenService.getToken();

    await _apiClient.delete(
      ApiEndpoints.notifications,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }
}
