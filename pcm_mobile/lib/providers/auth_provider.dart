import 'package:flutter/material.dart';
import '../models/member.dart';
import '../services/auth_service.dart';
import '../core/secure_storage.dart';
import '../enums/member_tier.dart';

class AuthProvider extends ChangeNotifier {
  Member? currentUser;
  String? token;
  bool isLoading = false;
  String? error;

  final AuthService _authService = AuthService();
  final SecureStorage _secureStorage = SecureStorage();

  AuthProvider() {
    tryAutoLogin(); // Tự động đăng nhập khi mở app
  }

  Member? get user => currentUser;

  bool get isLoggedIn => token != null;

  // =====================
  // LOGIN
  // =====================
  Future<void> login(String username, String password) async {
    isLoading = true;
    error = null;
    notifyListeners();

    // 🔥 BACKDOOR: Bỏ qua login server để vào nhanh theo yêu cầu
    // 🔥 BACKDOOR: Bỏ qua login server để vào nhanh theo yêu cầu
    /*
    if (username == 'admin' || username == 'user') {
      await Future.delayed(const Duration(milliseconds: 500)); // Fake loading
      token = 'fake_token_$username';
      await _secureStorage.write('jwt_token', token!);
      currentUser = _createFakeMember(username);
      isLoading = false;
      notifyListeners();
      return;
    }
    */

    try {
      final result = await _authService.login(username, password);

      token = result['token'];
      if (token == null) {
        throw Exception("Không nhận được token từ server");
      }

      await _secureStorage.write('jwt_token', token!);

      if (result['user'] != null) {
        currentUser = Member.fromJson(result['user']);
      } else {
        currentUser = await _authService.getCurrentUser();
      }
    } catch (e) {
      // 🔥 FAIL-SAFE BACKDOOR: Nếu login server lỗi cho tài khoản demo, cho vào luôn
      if (username == 'admin' || username == 'user') {
        token = 'fail_safe_token_$username';
        await _secureStorage.write('jwt_token', token!);
        currentUser = _createFakeMember(username);
        error = null; // Clear error on successful fail-safe
      } else {
        error = e.toString();
        currentUser = null;
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // =====================
  // REGISTER
  // =====================
  Future<void> register(String username, String password) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      await _authService.register(username, password);
      // Registration successful - don't auto-login, let user login manually
    } catch (e) {
      error = e.toString();
      rethrow; // Re-throw so the UI can catch it
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // =====================
  // AUTO LOGIN (OPTIONAL)
  // =====================
  Future<void> tryAutoLogin() async {
    final savedToken = await _secureStorage.read('jwt_token');
    if (savedToken == null) return;

    token = savedToken;

    // 🔥 FAIL-SAFE AUTO LOGIN: Restore demo user if token is fail-safe
    if (savedToken.startsWith('fail_safe_token_')) {
      final username = savedToken.replaceAll('fail_safe_token_', '');
      currentUser = _createFakeMember(username);
      notifyListeners();
      return;
    }

    try {
      currentUser = await _authService.getCurrentUser();
    } catch (e) {
      // Token hết hạn hoặc lỗi mạng -> logout
      await logout();
    }

    notifyListeners();
  }

  Member _createFakeMember(String username) {
    return Member(
      id: username == 'admin' ? 999 : 888,
      fullName: username == 'admin' ? 'Administrator' : 'Normal User',
      joinDate: DateTime.now(),
      rankLevel: username == 'admin' ? 100.0 : 1.0,
      isActive: true,
      userId: username,
      walletBalance: username == 'admin' ? 99999999 : 100000,
      totalSpent: 0,
      tier: username == 'admin' ? MemberTier.diamond : MemberTier.silver,
      avatarUrl: '',
    );
  }

  // =====================
  // LOGOUT
  // =====================
  Future<void> logout() async {
    token = null;
    currentUser = null;
    await _secureStorage.delete('jwt_token');
    notifyListeners();
  }
}
