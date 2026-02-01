import '../enums/member_tier.dart';

class Member {
  final int id;
  final String fullName;
  final DateTime joinDate;
  final double rankLevel;
  final bool isActive;
  final String userId;
  final double walletBalance;
  final MemberTier tier;
  final double totalSpent;
  final String avatarUrl;

  Member({
    required this.id,
    required this.fullName,
    required this.joinDate,
    required this.rankLevel,
    required this.isActive,
    required this.userId,
    required this.walletBalance,
    required this.tier,
    required this.totalSpent,
    required this.avatarUrl,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['id'],
      fullName: json['fullName'],
      joinDate: DateTime.parse(json['joinDate']),
      rankLevel: (json['rankLevel'] as num).toDouble(),
      isActive: json['isActive'] ?? json['status'],
      userId: json['userId'],
      walletBalance: (json['walletBalance'] as num).toDouble(),
      tier: MemberTier.values.firstWhere(
        (e) => e.name == (json['tier'] as String).toLowerCase(),
        orElse: () => MemberTier.standard,
      ),
      totalSpent: (json['totalSpent'] as num).toDouble(),
      avatarUrl: json['avatarUrl'] ?? '',
    );
  }
}
