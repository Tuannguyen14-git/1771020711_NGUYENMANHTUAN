import 'package:flutter/foundation.dart';

class Constants {
  static String get baseUrl {
    if (kIsWeb) return 'https://localhost:7043';
    return 'https://10.0.2.2:7043';
  }

  static String get signalRHubUrl {
    if (kIsWeb) return 'https://localhost:7043/pcmHub';
    return 'https://10.0.2.2:7043/pcmHub';
  }
}
