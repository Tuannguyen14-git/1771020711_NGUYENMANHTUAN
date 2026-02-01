import 'package:flutter/foundation.dart';

class Constants {
  // PRODUCTION - Render.com backend
  static const String productionUrl = 'https://one771020711-nguyenmanhtuan.onrender.com';
  
  static String get baseUrl {
    // Use production URL for both web and mobile
    return productionUrl;
  }

  static String get signalRHubUrl {
    return '$productionUrl/pcmHub';
  }
}
