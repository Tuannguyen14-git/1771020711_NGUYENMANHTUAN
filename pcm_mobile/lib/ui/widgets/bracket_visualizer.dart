import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/tournament_provider.dart';
import '../../models/match.dart';

class BracketVisualizer extends StatelessWidget {
  final List<Match> matches;
  const BracketVisualizer({Key? key, required this.matches}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: Vẽ cây đấu loại trực tiếp bằng CustomPainter hoặc package bracket
    return Container(
      height: 300,
      color: Colors.grey[200],
      child: const Center(
        child: Text('Bracket Visualizer (Cây đấu)'),
      ), // Placeholder
    );
  }
}
