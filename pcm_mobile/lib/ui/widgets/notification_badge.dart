import 'package:flutter/material.dart';

class NotificationBadge extends StatelessWidget {
  final int count;
  const NotificationBadge({Key? key, required this.count}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (count == 0) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: const BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
      ),
      child: Text(
        '$count',
        style: const TextStyle(color: Colors.white, fontSize: 10),
      ),
    );
  }
}
