import 'package:flutter/material.dart';
import '../models/member.dart';
import '../services/member_service.dart';

class MemberProvider extends ChangeNotifier {
  List<Member> members = [];
  bool isLoading = false;
  String? error;

  Future<void> fetchMembers({
    int page = 1,
    int pageSize = 20,
    String? search,
  }) async {
    isLoading = true;
    notifyListeners();
    try {
      members = await MemberService().getMembers(
        page: page,
        pageSize: pageSize,
        search: search,
      );
      error = null;
    } catch (e) {
      error = 'Không thể tải danh sách hội viên';
    }
    isLoading = false;
    notifyListeners();
  }
}
