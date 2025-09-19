/// Environment configuration for the app
/// 
/// This class manages environment variables and configuration settings.
/// It supports both compile-time and runtime configuration.
class Env {
  // API Configuration
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.civicreporter.com',
  );
  
  static const String wsUrl = String.fromEnvironment(
    'WS_URL',
    defaultValue: 'wss://api.civicreporter.com/ws',
  );
  
  static const String storageUploadUrl = String.fromEnvironment(
    'STORAGE_UPLOAD_URL',
    defaultValue: 'https://storage.civicreporter.com',
  );
  
  // Maps Configuration
  static const String mapsApiKey = String.fromEnvironment(
    'MAPS_API_KEY',
    defaultValue: '',
  );
  
  // Authentication Configuration
  static const String authJwtKey = String.fromEnvironment(
    'AUTH_JWT_KEY',
    defaultValue: 'civic_reporter_jwt_secret_key',
  );
  
  // Feature Flags
  static const bool useRealApi = bool.fromEnvironment(
    'USE_REAL_API',
    defaultValue: false,
  );
  
  static const bool useRealWebSocket = bool.fromEnvironment(
    'USE_REAL_WEBSOCKET',
    defaultValue: false,
  );
  
  static const bool enablePushNotifications = bool.fromEnvironment(
    'ENABLE_PUSH_NOTIFICATIONS',
    defaultValue: true,
  );
  
  static const bool enableLocationServices = bool.fromEnvironment(
    'ENABLE_LOCATION_SERVICES',
    defaultValue: true,
  );
  
  // Debug Configuration
  static const bool enableDebugLogs = bool.fromEnvironment(
    'ENABLE_DEBUG_LOGS',
    defaultValue: true,
  );
  
  static const bool enableMockData = bool.fromEnvironment(
    'ENABLE_MOCK_DATA',
    defaultValue: true,
  );
  
  // App Configuration
  static const String appName = 'Civic Reporter';
  static const String appVersion = '1.0.0';
  static const String buildNumber = '1';
  
  // Timeouts (in milliseconds)
  static const int apiTimeout = 30000;
  static const int wsTimeout = 10000;
  static const int imageUploadTimeout = 60000;
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // File Upload Limits
  static const int maxImageSize = 5 * 1024 * 1024; // 5MB
  static const int maxImagesPerPost = 5;
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png', 'webp'];
  
  // Location Configuration
  static const double defaultLatitude = 12.9716;
  static const double defaultLongitude = 77.5946;
  static const double defaultZoom = 12.0;
  static const double locationAccuracyThreshold = 100.0; // meters
  
  // Cache Configuration
  static const int imageCacheMaxAge = 7 * 24 * 60 * 60; // 7 days in seconds
  static const int dataCacheMaxAge = 5 * 60; // 5 minutes in seconds
  
  // Validation
  static const int minPasswordLength = 6;
  static const int maxPostTitleLength = 100;
  static const int maxPostDescriptionLength = 500;
  static const int maxCommentLength = 200;
  
  /// Check if the app is running in mock mode
  static bool get isMockMode => !useRealApi || enableMockData;
  
  /// Check if real API should be used
  static bool get shouldUseRealApi => useRealApi && !enableMockData;
  
  /// Check if real WebSocket should be used
  static bool get shouldUseRealWebSocket => useRealWebSocket && !enableMockData;
  
  /// Check if maps are enabled
  static bool get isMapsEnabled => mapsApiKey.isNotEmpty;
  
  /// Check if location services are enabled
  static bool get isLocationEnabled => enableLocationServices;
  
  /// Get the appropriate API base URL
  static String get effectiveApiBaseUrl {
    if (isMockMode) {
      return 'mock://api';
    }
    return apiBaseUrl;
  }
  
  /// Get the appropriate WebSocket URL
  static String get effectiveWsUrl {
    if (isMockMode) {
      return 'mock://ws';
    }
    return wsUrl;
  }
  
  /// Get the appropriate storage URL
  static String get effectiveStorageUrl {
    if (isMockMode) {
      return 'mock://storage';
    }
    return storageUploadUrl;
  }
  
  /// Print environment configuration (for debugging)
  static void printConfig() {
    if (enableDebugLogs) {
      print('=== Environment Configuration ===');
      print('API Base URL: $effectiveApiBaseUrl');
      print('WebSocket URL: $effectiveWsUrl');
      print('Storage URL: $effectiveStorageUrl');
      print('Maps API Key: ${mapsApiKey.isNotEmpty ? "***configured***" : "not set"}');
      print('Use Real API: $useRealApi');
      print('Use Real WebSocket: $useRealWebSocket');
      print('Mock Mode: $isMockMode');
      print('Should Use Real API: $shouldUseRealApi');
      print('Should Use Real WebSocket: $shouldUseRealWebSocket');
      print('Maps Enabled: $isMapsEnabled');
      print('Location Enabled: $isLocationEnabled');
      print('Debug Logs: $enableDebugLogs');
      print('===============================');
    }
  }
  
  /// Get environment variables for backend integration
  static Map<String, String> getEnvironmentVariables() {
    return {
      'API_BASE_URL': apiBaseUrl,
      'WS_URL': wsUrl,
      'STORAGE_UPLOAD_URL': storageUploadUrl,
      'MAPS_API_KEY': mapsApiKey,
      'AUTH_JWT_KEY': authJwtKey,
      'USE_REAL_API': useRealApi.toString(),
      'USE_REAL_WEBSOCKET': useRealWebSocket.toString(),
      'ENABLE_PUSH_NOTIFICATIONS': enablePushNotifications.toString(),
      'ENABLE_LOCATION_SERVICES': enableLocationServices.toString(),
      'ENABLE_DEBUG_LOGS': enableDebugLogs.toString(),
      'ENABLE_MOCK_DATA': enableMockData.toString(),
    };
  }
}
