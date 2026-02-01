enum TournamentFormat { roundRobin, knockout, hybrid }

enum TournamentStatus { open, registering, drawCompleted, ongoing, finished }

class Tournament {
  final int id;
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final TournamentFormat format;
  final double entryFee;
  final double prizePool;
  final TournamentStatus status;
  final Map<String, dynamic> settings;

  Tournament({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.format,
    required this.entryFee,
    required this.prizePool,
    required this.status,
    required this.settings,
  });

  factory Tournament.fromJson(Map<String, dynamic> json) {
    return Tournament(
      id: json['id'],
      name: json['name'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      format: TournamentFormat.values.firstWhere(
        (e) => e.name == (json['format'] as String).toLowerCase(),
        orElse: () => TournamentFormat.roundRobin,
      ),
      entryFee: (json['entryFee'] as num).toDouble(),
      prizePool: (json['prizePool'] as num).toDouble(),
      status: TournamentStatus.values.firstWhere(
        (e) => e.name == (json['status'] as String).toLowerCase(),
        orElse: () => TournamentStatus.open,
      ),
      settings: json['settings'] ?? {},
    );
  }
}
