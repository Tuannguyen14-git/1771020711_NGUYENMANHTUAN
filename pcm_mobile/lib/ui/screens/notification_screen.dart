import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/notification_provider.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notificationProvider = Provider.of<NotificationProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Thông báo')),
      body: ListView.builder(
        itemCount: notificationProvider.notifications.length,
        itemBuilder: (context, index) {
          final noti = notificationProvider.notifications[index];
          return ListTile(
            title: Text(noti.message),
            subtitle: Text(noti.createdDate.toString()),
            trailing: noti.isRead
                ? null
                : const Icon(Icons.fiber_new, color: Colors.red),
            onTap: () async {
              await notificationProvider.markAsRead(noti.id);
            },
          );
        },
      ),
    );
  }
}
