import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_colors.dart';
import '../../enums/member_tier.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;

    if (user == null) return const Scaffold();

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Hồ sơ cá nhân', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.gradientStart,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.gradientStart, AppColors.gradientEnd],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // USER INFO SECTION
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.gradientStart,
                    backgroundImage: user.avatarUrl.isNotEmpty 
                        ? NetworkImage(user.avatarUrl) 
                        : null,
                    child: user.avatarUrl.isEmpty
                        ? Text(user.fullName[0], style: const TextStyle(fontSize: 40, color: Colors.white))
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user.fullName,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getTierColor(user.tier).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: _getTierColor(user.tier)),
                    ),
                    child: Text(
                      user.tier.name.toUpperCase(),
                      style: TextStyle(
                        color: _getTierColor(user.tier),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 10),
            
            // STATS ROW
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _statItem('DUPR', '${user.rankLevel}'),
                  _verticalDivider(),
                  _statItem('Trận đấu', '0'),
                  _verticalDivider(),
                  _statItem('Thắng/Thua', '0/0'),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // MENU ITEMS
            _menuSection([
              _menuItem(Icons.person_outline, 'Chỉnh sửa thông tin', () {}),
              _menuItem(Icons.lock_outline, 'Đổi mật khẩu', () {}),
              _menuItem(Icons.people_outline, 'Danh sách thành viên CLB', () {
                // Navigate to Members List
              }),
            ]),

            const SizedBox(height: 16),

            _menuSection([
              _menuItem(Icons.help_outline, 'Hỗ trợ', () {}),
               _menuItem(Icons.info_outline, 'Về ứng dụng', () {}),
            ]),

            const SizedBox(height: 24),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () async {
                    await auth.logout();
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('ĐĂNG XUẤT'),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Color _getTierColor(MemberTier tier) {
    switch (tier) {
      case MemberTier.diamond:
        return AppColors.diamond;
      case MemberTier.gold:
        return AppColors.gold;
      default:
        return Colors.grey;
    }
  }

  Widget _statItem(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
      ],
    );
  }

  Widget _verticalDivider() {
    return Container(height: 30, width: 1, color: Colors.grey.shade300);
  }

  Widget _menuSection(List<Widget> children) {
    return Container(
      color: Colors.white,
      child: Column(
        children: children.map((item) {
          return Column(
            children: [
              item,
              const Divider(height: 1, indent: 56),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _menuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textPrimary),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }
}
