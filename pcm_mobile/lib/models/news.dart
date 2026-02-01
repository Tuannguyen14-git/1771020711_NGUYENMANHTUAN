class News {
  final int id;
  final String title;
  final String content;
  final bool isPinned;
  final DateTime createdDate;
  final String imageUrl;

  News({
    required this.id,
    required this.title,
    required this.content,
    required this.isPinned,
    required this.createdDate,
    required this.imageUrl,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      isPinned: json['isPinned'] ?? false,
      createdDate: DateTime.parse(json['createdDate']),
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}
