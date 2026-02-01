enum MatchStatus { scheduled, inProgress, finished }

enum WinningSide { team1, team2 }

class Match {
  final int id;
  final int? tournamentId;
  final String roundName;
  final DateTime date;
  final DateTime startTime;
  final int team1Player1Id;
  final int? team1Player2Id;
  final int team2Player1Id;
  final int? team2Player2Id;
  final int score1;
  final int score2;
  final String details;
  final WinningSide? winningSide;
  final bool isRanked;
  final MatchStatus status;

  Match({
    required this.id,
    this.tournamentId,
    required this.roundName,
    required this.date,
    required this.startTime,
    required this.team1Player1Id,
    this.team1Player2Id,
    required this.team2Player1Id,
    this.team2Player2Id,
    required this.score1,
    required this.score2,
    required this.details,
    this.winningSide,
    required this.isRanked,
    required this.status,
  });

  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      id: json['id'],
      tournamentId: json['tournamentId'],
      roundName: json['roundName'],
      date: DateTime.parse(json['date']),
      startTime: DateTime.parse(json['startTime']),
      team1Player1Id: json['team1Player1Id'],
      team1Player2Id: json['team1Player2Id'],
      team2Player1Id: json['team2Player1Id'],
      team2Player2Id: json['team2Player2Id'],
      score1: json['score1'],
      score2: json['score2'],
      details: json['details'] ?? '',
      winningSide: json['winningSide'] != null
          ? WinningSide.values.firstWhere(
              (e) => e.name == (json['winningSide'] as String).toLowerCase(),
              orElse: () => WinningSide.team1,
            )
          : null,
      isRanked: json['isRanked'] ?? false,
      status: MatchStatus.values.firstWhere(
        (e) => e.name == (json['status'] as String).toLowerCase(),
        orElse: () => MatchStatus.scheduled,
      ),
    );
  }
}
