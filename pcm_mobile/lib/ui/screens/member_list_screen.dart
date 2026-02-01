import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/member_provider.dart';
import '../../models/member.dart';

class MemberListScreen extends StatelessWidget {
  const MemberListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final memberProvider = Provider.of<MemberProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Danh sách hội viên')),
      body: ListView.builder(
        itemCount: memberProvider.members.length,
        itemBuilder: (context, index) {
          final member = memberProvider.members[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(member.avatarUrl),
            ),
            title: Text(member.fullName),
            subtitle: Text('Hạng: ${member.tier.name}'),
            onTap: () {
              // TODO: Xem profile hội viên khác
            },
          );
        },
      ),
    );
  }
}
