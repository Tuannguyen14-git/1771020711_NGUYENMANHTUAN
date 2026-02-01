import 'package:dio/dio.dart';
import '../core/api_client.dart';
import '../models/tournament.dart';
import '../models/tournament_participant.dart';
import '../models/match.dart';

class TournamentService {
  final Dio _dio = ApiClient().dio;

  Future<void> createTournament(Map<String, dynamic> tournamentData) async {
    await _dio.post('/api/tournaments', data: tournamentData);
  }

  Future<void> joinTournament(int id) async {
    await _dio.post('/api/tournaments/$id/join');
  }

  Future<void> generateSchedule(int id) async {
    await _dio.post('/api/tournaments/$id/generate-schedule');
  }

  Future<void> updateMatchResult(
    int matchId,
    Map<String, dynamic> resultData,
  ) async {
    await _dio.post('/api/matches/$matchId/result', data: resultData);
  }

  Future<List<Tournament>> getTournaments() async {
    final response = await _dio.get('/api/tournaments');
    return (response.data as List).map((e) => Tournament.fromJson(e)).toList();
  }

  Future<List<TournamentParticipant>> getParticipants(int tournamentId) async {
    final response = await _dio.get(
      '/api/tournaments/$tournamentId/participants',
    );
    return (response.data as List)
        .map((e) => TournamentParticipant.fromJson(e))
        .toList();
  }

  Future<List<Match>> getMatches(int tournamentId) async {
    final response = await _dio.get('/api/tournaments/$tournamentId/matches');
    return (response.data as List).map((e) => Match.fromJson(e)).toList();
  }
}
