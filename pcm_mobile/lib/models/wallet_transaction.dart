enum WalletTransactionType { deposit, withdraw, payment, refund, reward }

enum WalletTransactionStatus { pending, completed, rejected, failed }

class WalletTransaction {
  final int id;
  final int memberId;
  final double amount;
  final WalletTransactionType type;
  final WalletTransactionStatus status;
  final String relatedId;
  final String description;
  final DateTime createdDate;

  WalletTransaction({
    required this.id,
    required this.memberId,
    required this.amount,
    required this.type,
    required this.status,
    required this.relatedId,
    required this.description,
    required this.createdDate,
  });

  factory WalletTransaction.fromJson(Map<String, dynamic> json) {
    return WalletTransaction(
      id: json['id'],
      memberId: json['memberId'],
      amount: (json['amount'] as num).toDouble(),
      type: WalletTransactionType.values.firstWhere(
        (e) => e.name == (json['type'] as String).toLowerCase(),
        orElse: () => WalletTransactionType.payment,
      ),
      status: WalletTransactionStatus.values.firstWhere(
        (e) => e.name == (json['status'] as String).toLowerCase(),
        orElse: () => WalletTransactionStatus.pending,
      ),
      relatedId: json['relatedId'].toString(),
      description: json['description'] ?? '',
      createdDate: DateTime.parse(json['createdDate']),
    );
  }
}
