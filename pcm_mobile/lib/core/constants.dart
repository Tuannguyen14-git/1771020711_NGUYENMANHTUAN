import 'package:flutter/foundation.dart';

class Constants {
  static String get baseUrl {
    if (kIsWeb) return 'https://localhost:7043';
    return 'https://192.168.1.245:7043';  // Computer IP for real device testing
  }

  static String get signalRHubUrl {
    if (kIsWeb) return 'https://localhost:7043/pcmHub';
    return 'https://10.0.2.2:7043/pcmHub';
  }
}
