import 'package:dio/dio.dart';
import '../core/api_client.dart';
import '../models/member.dart';

class AuthService {
  final Dio _dio = ApiClient().dio;

  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await _dio.post(
        '/api/auth/login',
        data: {'username': username, 'password': password},
      );
      final data = response.data;
      if (data == null || data is! Map) {
        throw Exception('Server trả về dữ liệu không hợp lệ.');
      }
      final token = data['token'];
      final user = data['user'];
      if (token == null) {
        throw Exception('Server trả về dữ liệu thiếu token.');
      }
      // If server doesn't include a full user object, caller can fetch /api/auth/me
      return {'token': token, 'user': user};
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception(
          'Kết nối tới server thất bại (timeout). Vui lòng thử lại.',
        );
      }
      if (e.response != null) {
        // Try to extract message from response body safely
        final data = e.response?.data;
        if (data is Map && data.containsKey('message')) {
          throw Exception(data['message'].toString());
        }
        throw Exception('Đăng nhập thất bại');
      }
      throw Exception('Không thể kết nối tới server.');
    }
  }

  Future<void> register(String username, String password) async {
    try {
      await _dio.post(
        '/api/auth/register',
        data: {'username': username, 'password': password},
      );
    } on DioException catch (e) {
      if (e.response != null) {
         throw Exception(e.response?.data?.toString() ?? 'Đăng ký thất bại');
      }
      throw Exception('Lỗi kết nối');
    }
  }

  Future<Member> getCurrentUser() async {
    try {
      final response = await _dio.get('/api/auth/me');
      final data = response.data;
      if (data == null || data is! Map<String, dynamic>) {
        throw Exception('Dữ liệu người dùng không hợp lệ.');
      }
      return Member.fromJson(data as Map<String, dynamic>);
    } on DioException catch (_) {
      throw Exception('Lỗi khi lấy thông tin người dùng.');
    }
  }
}
