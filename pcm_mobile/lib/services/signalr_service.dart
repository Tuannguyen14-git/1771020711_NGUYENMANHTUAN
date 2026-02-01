import 'package:signalr_netcore/signalr_client.dart';
import '../core/constants.dart';

class SignalRService {
  late HubConnection _hubConnection;

  Future<void> connect() async {
    _hubConnection = HubConnectionBuilder()
        .withUrl(Constants.signalRHubUrl)
        .build();
    await _hubConnection.start();
  }

  void onReceiveNotification(Function(dynamic) handler) {
    _hubConnection.on('ReceiveNotification', handler);
  }

  void onUpdateCalendar(Function(dynamic) handler) {
    _hubConnection.on('UpdateCalendar', handler);
  }

  void onUpdateMatchScore(Function(dynamic) handler) {
    _hubConnection.on('UpdateMatchScore', handler);
  }

  Future<void> disconnect() async {
    await _hubConnection.stop();
  }
}
