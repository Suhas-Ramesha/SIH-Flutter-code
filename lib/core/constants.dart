class AppConstants {
  // App Info
  static const String appName = 'Civic Reporter';
  static const String appVersion = '1.0.0';
  
  // API Configuration
  static const String defaultApiBaseUrl = 'https://api.civicreporter.com';
  static const String defaultWsUrl = 'wss://api.civicreporter.com/ws';
  static const String defaultStorageUrl = 'https://storage.civicreporter.com';
  
  // Pagination
  static const int postsPerPage = 20;
  static const int maxImageSize = 5 * 1024 * 1024; // 5MB
  
  // Post Categories
  static const List<String> categories = [
    'Potholes',
    'Streetlights not working',
    'Waterlogging / Drainage blockages',
    'Broken / Missing Road Signs',
    'Trash / Illegal dumping',
    'Sidewalk / Footpath damage',
    'Fallen trees / Vegetation blocking road',
    'Unsafe manhole / Missing covers',
    'Bus-shelter / Public furniture damage',
    'Traffic signal faults',
    'Encroachments / Illegal constructions',
    'Public toilet issues',
    'Road markings faded',
    'Sewage / Water leak complaints',
    'Noise / Pollution complaints',
    'Tree trimming requests',
  ];
  
  // Post Status
  static const List<String> postStatuses = [
    'Reported',
    'Under Review',
    'Assigned',
    'In Progress',
    'Resolved',
    'Closed',
  ];
  
  // Severity Levels
  static const List<String> severityLevels = [
    'Low',
    'Medium',
    'High',
  ];
  
  // Areas (Bangalore areas for mock data)
  static const List<String> areas = [
    'Koramangala 4th Block',
    'Koramangala 5th Block',
    'Jayanagar',
    'Malleshwaram',
    'HSR Layout',
    'Indiranagar',
    'Basavanagudi',
    'Whitefield',
    'Electronic City',
    'Marathahalli',
    'BTM Layout',
    'Banashankari',
    'Rajajinagar',
    'Vijayanagar',
    'Hebbal',
  ];
  
  // User Roles
  static const String userRole = 'user';
  static const String adminRole = 'admin';
  
  // Storage Keys
  static const String authTokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String currentUserKey = 'current_user';
  static const String selectedAreaKey = 'selected_area';
  static const String selectedCategoriesKey = 'selected_categories';
  
  // Map Configuration
  static const double defaultLatitude = 12.9716;
  static const double defaultLongitude = 77.5946;
  static const double defaultZoom = 12.0;
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  
  // Validation
  static const int minPasswordLength = 6;
  static const int maxPostTitleLength = 100;
  static const int maxPostDescriptionLength = 500;
  static const int maxCommentLength = 200;
  
  // Post Configuration
  static const int maxImagesPerPost = 5;
}
