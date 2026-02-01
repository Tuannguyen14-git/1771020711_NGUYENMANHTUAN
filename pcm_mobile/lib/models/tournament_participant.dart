class TournamentParticipant {
  final int id;
  final int tournamentId;
  final int memberId;
  final String teamName;
  final bool paymentStatus;

  TournamentParticipant({
    required this.id,
    required this.tournamentId,
    required this.memberId,
    required this.teamName,
    required this.paymentStatus,
  });

  factory TournamentParticipant.fromJson(Map<String, dynamic> json) {
    return TournamentParticipant(
      id: json['id'],
      tournamentId: json['tournamentId'],
      memberId: json['memberId'],
      teamName: json['teamName'] ?? '',
      paymentStatus: json['paymentStatus'] ?? false,
    );
  }
}
