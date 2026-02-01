import 'package:dio/dio.dart';
import '../core/api_client.dart';

class StatisticsService {
  final Dio _dio = ApiClient().dio;

  Future<Map<String, dynamic>> getDashboardStats() async {
    try {
      final response = await _dio.get('/api/statistics/dashboard');
      return response.data;
    } catch (e) {
      throw Exception('Failed to load dashboard stats: $e');
    }
  }

  Future<List<dynamic>> getRevenueChart(int? year) async {
    try {
      final response = await _dio.get(
        '/api/statistics/revenue',
        queryParameters: year != null ? {'year': year} : null,
      );
      return response.data;
    } catch (e) {
      throw Exception('Failed to load revenue chart: $e');
    }
  }

  Future<List<dynamic>> getTopMembers() async {
    try {
      final response = await _dio.get('/api/statistics/top-members');
      return response.data;
    } catch (e) {
      throw Exception('Failed to load top members: $e');
    }
  }
}
