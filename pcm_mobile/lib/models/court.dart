class Court {
  final int id;
  final String name;
  final bool isActive;
  final String description;
  final double pricePerHour;

  Court({
    required this.id,
    required this.name,
    required this.isActive,
    required this.description,
    required this.pricePerHour,
  });

  factory Court.fromJson(Map<String, dynamic> json) {
    return Court(
      id: json['id'],
      name: json['name'],
      isActive: json['isActive'],
      description: json['description'] ?? '',
      pricePerHour: (json['pricePerHour'] as num).toDouble(),
    );
  }
}
