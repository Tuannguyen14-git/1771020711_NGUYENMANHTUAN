import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/tournament_provider.dart';
import '../../models/tournament.dart';

class TournamentListScreen extends StatelessWidget {
  const TournamentListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tournamentProvider = Provider.of<TournamentProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Giải đấu')),
      body: ListView.builder(
        itemCount: tournamentProvider.tournaments.length,
        itemBuilder: (context, index) {
          final tournament = tournamentProvider.tournaments[index];
          return ListTile(
            title: Text(tournament.name),
            subtitle: Text('Trạng thái: ${tournament.status.name}'),
            onTap: () {
              // TODO: Điều hướng sang chi tiết giải đấu
            },
          );
        },
      ),
    );
  }
}
