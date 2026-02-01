import 'package:dio/dio.dart';
import '../core/api_client.dart';

class BookingService {
  final ApiClient _apiClient = ApiClient();

  // Get all courts
  Future<List<dynamic>> getCourts() async {
    try {
      final response = await _apiClient.dio.get('/api/courts');
      return response.data;
    } catch (e) {
      throw Exception('Failed to load courts: $e');
    }
  }

  // Get calendar bookings
  Future<List<dynamic>> getCalendar(DateTime from, DateTime to) async {
    try {
      final response = await _apiClient.dio.get('/api/bookings/calendar', queryParameters: {
        'from': from.toIso8601String(),
        'to': to.toIso8601String(),
      });
      return response.data;
    } catch (e) {
      throw Exception('Failed to load calendar: $e');
    }
  }

  // Hold slot
  Future<Map<String, dynamic>> holdSlot(Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.dio.post('/api/bookings/hold', data: data);
      return response.data;
    } catch (e) {
      if (e is DioException && e.response != null) {
         throw Exception(e.response!.data);
      }
      throw Exception('Failed to hold slot: $e');
    }
  }

  // Confirm Booking
  Future<Map<String, dynamic>> confirmBooking(Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.dio.post('/api/bookings/confirm', data: data);
      return response.data;
    } catch (e) {
      if (e is DioException && e.response != null) {
         throw Exception(e.response!.data);
      }
      throw Exception('Failed to confirm booking: $e');
    }
  }

  // Create single booking
  Future<Map<String, dynamic>> createBooking(Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.dio.post('/api/bookings', data: data);
      return response.data;
    } catch (e) {
      if (e is DioException && e.response != null) {
         throw Exception(e.response!.data);
      }
      throw Exception('Failed to create booking: $e');
    }
  }

  // Create recurring booking
  Future<Map<String, dynamic>> createRecurringBooking(Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.dio.post('/api/bookings/recurring', data: data);
      return response.data;
    } catch (e) {
      if (e is DioException && e.response != null) {
         throw Exception(e.response!.data);
      }
      throw Exception('Failed to create recurring booking: $e');
    }
  }

  // Cancel booking
  Future<void> cancelBooking(int bookingId) async {
    try {
      await _apiClient.dio.delete('/api/bookings/$bookingId');
    } catch (e) {
      if (e is DioException && e.response != null) {
         throw Exception(e.response!.data);
      }
      throw Exception('Failed to cancel booking: $e');
    }
  }
}
