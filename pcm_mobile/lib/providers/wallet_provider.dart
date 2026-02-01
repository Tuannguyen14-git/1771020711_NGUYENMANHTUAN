import 'package:flutter/material.dart';
import '../models/wallet_transaction.dart';
import '../services/wallet_service.dart';

class WalletProvider extends ChangeNotifier {
  List<WalletTransaction> transactions = [];
  bool isLoading = false;
  String? error;

  double? get balance => null;

  Future<void> fetchTransactions(int memberId) async {
    isLoading = true;
    notifyListeners();
    try {
      final data = await WalletService().getTransactions(memberId);
      transactions = (data as List).map((e) => WalletTransaction.fromJson(e)).toList();
      error = null;
    } catch (e) {
      error = 'Không thể tải lịch sử giao dịch';
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> deposit(int memberId, double amount, String description) async {
    isLoading = true;
    notifyListeners();
    try {
      await WalletService().deposit({
        'memberId': memberId,
        'amount': amount,
        'description': description,
      });
      await fetchTransactions(memberId);
      error = null;
    } catch (e) {
      error = 'Nạp tiền thất bại';
    }
    isLoading = false;
    notifyListeners();
  }

  void loadWallet(double amount) {
    // Implementation for loading wallet if needed
  }
}
