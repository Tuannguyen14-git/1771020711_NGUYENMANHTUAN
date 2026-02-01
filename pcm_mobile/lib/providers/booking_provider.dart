import 'package:flutter/material.dart';
import '../models/booking.dart';
import '../services/booking_service.dart';

class BookingProvider extends ChangeNotifier {
  List<Booking> bookings = [];
  bool isLoading = false;
  String? error;

  Future<void> fetchCalendar(DateTime from, DateTime to) async {
    isLoading = true;
    notifyListeners();
    try {
      bookings = await BookingService().getCalendar(from, to);
      error = null;
    } catch (e) {
      error = 'Không thể tải lịch đặt sân';
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> createBooking(Map<String, dynamic> bookingData) async {
    isLoading = true;
    notifyListeners();
    try {
      await BookingService().createBooking(bookingData);
      error = null;
    } catch (e) {
      error = 'Đặt sân thất bại';
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> createRecurringBooking(Map<String, dynamic> bookingData) async {
    isLoading = true;
    notifyListeners();
    try {
      await BookingService().createRecurringBooking(bookingData);
      error = null;
    } catch (e) {
      error = 'Đặt lịch định kỳ thất bại';
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> cancelBooking(int id) async {
    isLoading = true;
    notifyListeners();
    try {
      await BookingService().cancelBooking(id);
      error = null;
    } catch (e) {
      error = 'Hủy sân thất bại';
    }
    isLoading = false;
    notifyListeners();
  }
}
