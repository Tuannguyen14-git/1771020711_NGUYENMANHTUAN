import 'package:dio/dio.dart';
import '../core/api_client.dart';
import '../models/member.dart';

class MemberService {
  final Dio _dio = ApiClient().dio;

  Future<List<Member>> getMembers({
    int page = 1,
    int pageSize = 20,
    String? search,
  }) async {
    final response = await _dio.get(
      '/api/members',
      queryParameters: {
        'page': page,
        'pageSize': pageSize,
        if (search != null) 'search': search,
      },
    );
    return (response.data as List).map((e) => Member.fromJson(e)).toList();
  }

  Future<Member> getMemberProfile(int id) async {
    final response = await _dio.get('/api/members/$id/profile');
    return Member.fromJson(response.data);
  }
}
