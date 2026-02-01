class NotificationModel {
  final int id;
  final int receiverId;
  final String message;
  final String type;
  final String linkUrl;
  final bool isRead;
  final DateTime createdDate;

  NotificationModel({
    required this.id,
    required this.receiverId,
    required this.message,
    required this.type,
    required this.linkUrl,
    required this.isRead,
    required this.createdDate,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      receiverId: json['receiverId'],
      message: json['message'],
      type: json['type'],
      linkUrl: json['linkUrl'] ?? '',
      isRead: json['isRead'] ?? false,
      createdDate: DateTime.parse(json['createdDate']),
    );
  }
}
