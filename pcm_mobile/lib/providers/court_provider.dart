import 'package:flutter/material.dart';
import '../models/court.dart';
import '../services/court_service.dart';

class CourtProvider extends ChangeNotifier {
  List<Court> courts = [];
  bool isLoading = false;
  String? error;

  Future<void> fetchCourts() async {
    isLoading = true;
    notifyListeners();
    try {
      courts = await CourtService().getCourts();
      error = null;
    } catch (e) {
      error = 'Không thể tải danh sách sân';
    }
    isLoading = false;
    notifyListeners();
  }
}
