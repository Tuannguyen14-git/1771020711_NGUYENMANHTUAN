enum BookingStatus { pendingPayment, confirmed, cancelled, completed }

class Booking {
  final int id;
  final int courtId;
  final int memberId;
  final DateTime startTime;
  final DateTime endTime;
  final double totalPrice;
  final int transactionId;
  final bool isRecurring;
  final String recurrenceRule;
  final int? parentBookingId;
  final BookingStatus status;

  Booking({
    required this.id,
    required this.courtId,
    required this.memberId,
    required this.startTime,
    required this.endTime,
    required this.totalPrice,
    required this.transactionId,
    required this.isRecurring,
    required this.recurrenceRule,
    this.parentBookingId,
    required this.status,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      courtId: json['courtId'],
      memberId: json['memberId'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      totalPrice: (json['totalPrice'] as num).toDouble(),
      transactionId: json['transactionId'],
      isRecurring: json['isRecurring'] ?? false,
      recurrenceRule: json['recurrenceRule'] ?? '',
      parentBookingId: json['parentBookingId'],
      status: BookingStatus.values.firstWhere(
        (e) => e.name == (json['status'] as String).toLowerCase(),
        orElse: () => BookingStatus.pendingPayment,
      ),
    );
  }
}
