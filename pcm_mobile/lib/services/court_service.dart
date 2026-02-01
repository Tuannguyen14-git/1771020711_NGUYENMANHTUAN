import 'package:dio/dio.dart';
import '../core/api_client.dart';
import '../models/court.dart';

class CourtService {
  final Dio _dio = ApiClient().dio;

  Future<List<Court>> getCourts() async {
    final response = await _dio.get('/api/courts');
    return (response.data as List).map((e) => Court.fromJson(e)).toList();
  }
}
