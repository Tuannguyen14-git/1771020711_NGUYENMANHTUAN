import 'package:flutter/material.dart';
import '../models/tournament.dart';
import '../models/tournament_participant.dart';
import '../models/match.dart';
import '../services/tournament_service.dart';

class TournamentProvider extends ChangeNotifier {
  List<Tournament> tournaments = [];
  List<TournamentParticipant> participants = [];
  List<Match> matches = [];
  bool isLoading = false;
  String? error;

  Future<void> fetchTournaments() async {
    isLoading = true;
    notifyListeners();
    try {
      tournaments = await TournamentService().getTournaments();
      error = null;
    } catch (e) {
      error = 'Không thể tải danh sách giải đấu';
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchParticipants(int tournamentId) async {
    isLoading = true;
    notifyListeners();
    try {
      participants = await TournamentService().getParticipants(tournamentId);
      error = null;
    } catch (e) {
      error = 'Không thể tải danh sách đội/đội viên';
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchMatches(int tournamentId) async {
    isLoading = true;
    notifyListeners();
    try {
      matches = await TournamentService().getMatches(tournamentId);
      error = null;
    } catch (e) {
      error = 'Không thể tải danh sách trận đấu';
    }
    isLoading = false;
    notifyListeners();
  }
}
