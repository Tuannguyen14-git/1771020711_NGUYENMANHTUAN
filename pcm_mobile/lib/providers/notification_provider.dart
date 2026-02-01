import 'package:flutter/material.dart';
import '../models/notification.dart';
import '../services/notification_service.dart';

class NotificationProvider extends ChangeNotifier {
  List<NotificationModel> notifications = [];
  bool isLoading = false;
  String? error;

  Future<void> fetchNotifications() async {
    isLoading = true;
    notifyListeners();
    try {
      notifications = await NotificationService().getNotifications();
      error = null;
    } catch (e) {
      error = 'Không thể tải thông báo';
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> markAsRead(int id) async {
    isLoading = true;
    notifyListeners();
    try {
      await NotificationService().markAsRead(id);
      error = null;
    } catch (e) {
      error = 'Đánh dấu đã đọc thất bại';
    }
    isLoading = false;
    notifyListeners();
  }
}
