import 'package:dio/dio.dart';
import '../core/api_client.dart';
import '../models/notification.dart';

class NotificationService {
  final Dio _dio = ApiClient().dio;

  Future<List<NotificationModel>> getNotifications() async {
    final response = await _dio.get('/api/notifications');
    return (response.data as List)
        .map((e) => NotificationModel.fromJson(e))
        .toList();
  }

  Future<void> markAsRead(int id) async {
    await _dio.put('/api/notifications/$id/read');
  }
}
