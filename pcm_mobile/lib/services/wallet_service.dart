import 'package:dio/dio.dart';
import '../core/api_client.dart';

class WalletService {
  final ApiClient _apiClient = ApiClient();

  // Get transactions
  Future<List<dynamic>> getTransactions(int memberId) async {
    try {
      final response = await _apiClient.dio.get('/api/wallet/transactions/$memberId');
      return response.data;
    } catch (e) {
      throw Exception('Failed to load transactions: $e');
    }
  }

  // Deposit money
  Future<Map<String, dynamic>> deposit(Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.dio.post('/api/wallet/deposit', data: data);
      return response.data;
    } catch (e) {
      if (e is DioException && e.response != null) {
         throw Exception(e.response!.data);
      }
      throw Exception('Deposit failed: $e');
    }
  }
}
