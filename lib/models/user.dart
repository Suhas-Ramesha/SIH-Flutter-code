/// User model representing a user in the civic reporting system
class User {
  final String id;
  final String email;
  final String username;
  final String role; // 'user' or 'admin'
  final String area;
  final int reputation;
  final DateTime createdAt;
  final String? profileImageUrl;
  final String? phoneNumber;
  final bool isVerified;
  final Map<String, dynamic>? preferences;
  
  const User({
    required this.id,
    required this.email,
    required this.username,
    required this.role,
    required this.area,
    required this.reputation,
    required this.createdAt,
    this.profileImageUrl,
    this.phoneNumber,
    this.isVerified = false,
    this.preferences,
  });
  
  /// Create a User from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      username: json['username'] as String,
      role: json['role'] as String,
      area: json['area'] as String,
      reputation: json['reputation'] as int? ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      profileImageUrl: json['profileImageUrl'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      isVerified: json['isVerified'] as bool? ?? false,
      preferences: json['preferences'] as Map<String, dynamic>?,
    );
  }
  
  /// Convert User to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'role': role,
      'area': area,
      'reputation': reputation,
      'createdAt': createdAt.toIso8601String(),
      'profileImageUrl': profileImageUrl,
      'phoneNumber': phoneNumber,
      'isVerified': isVerified,
      'preferences': preferences,
    };
  }
  
  /// Create a copy of this User with updated fields
  User copyWith({
    String? id,
    String? email,
    String? username,
    String? role,
    String? area,
    int? reputation,
    DateTime? createdAt,
    String? profileImageUrl,
    String? phoneNumber,
    bool? isVerified,
    Map<String, dynamic>? preferences,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      role: role ?? this.role,
      area: area ?? this.area,
      reputation: reputation ?? this.reputation,
      createdAt: createdAt ?? this.createdAt,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isVerified: isVerified ?? this.isVerified,
      preferences: preferences ?? this.preferences,
    );
  }
  
  /// Check if user is an admin
  bool get isAdmin => role == 'admin';
  
  /// Check if user is a regular user
  bool get isUser => role == 'user';
  
  /// Get user's reputation level
  String get reputationLevel {
    if (reputation >= 500) return 'Expert';
    if (reputation >= 200) return 'Advanced';
    if (reputation >= 100) return 'Intermediate';
    if (reputation >= 50) return 'Beginner';
    return 'New';
  }
  
  /// Get user's reputation color
  String get reputationColor {
    if (reputation >= 500) return '#FFD700'; // Gold
    if (reputation >= 200) return '#C0C0C0'; // Silver
    if (reputation >= 100) return '#CD7F32'; // Bronze
    return '#808080'; // Gray
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.id == id;
  }
  
  @override
  int get hashCode => id.hashCode;
  
  @override
  String toString() {
    return 'User(id: $id, email: $email, username: $username, role: $role, area: $area, reputation: $reputation)';
  }
}

/// Authentication response model
class AuthResponse {
  final String token;
  final String refreshToken;
  final User user;
  final DateTime expiresAt;
  
  const AuthResponse({
    required this.token,
    required this.refreshToken,
    required this.user,
    required this.expiresAt,
  });
  
  /// Create AuthResponse from JSON
  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'] as String,
      refreshToken: json['refreshToken'] as String,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      expiresAt: DateTime.parse(json['expiresAt'] as String),
    );
  }
  
  /// Convert AuthResponse to JSON
  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'refreshToken': refreshToken,
      'user': user.toJson(),
      'expiresAt': expiresAt.toIso8601String(),
    };
  }
}

/// Login request model
class LoginRequest {
  final String email;
  final String password;
  final bool rememberMe;
  
  const LoginRequest({
    required this.email,
    required this.password,
    this.rememberMe = false,
  });
  
  /// Convert LoginRequest to JSON
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'rememberMe': rememberMe,
    };
  }
}

/// User preferences model
class UserPreferences {
  final String selectedArea;
  final List<String> selectedCategories;
  final bool enablePushNotifications;
  final bool enableLocationServices;
  final String language;
  final String theme;
  
  const UserPreferences({
    required this.selectedArea,
    required this.selectedCategories,
    this.enablePushNotifications = true,
    this.enableLocationServices = true,
    this.language = 'en',
    this.theme = 'light',
  });
  
  /// Create UserPreferences from JSON
  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      selectedArea: json['selectedArea'] as String? ?? '',
      selectedCategories: List<String>.from(json['selectedCategories'] as List? ?? []),
      enablePushNotifications: json['enablePushNotifications'] as bool? ?? true,
      enableLocationServices: json['enableLocationServices'] as bool? ?? true,
      language: json['language'] as String? ?? 'en',
      theme: json['theme'] as String? ?? 'light',
    );
  }
  
  /// Convert UserPreferences to JSON
  Map<String, dynamic> toJson() {
    return {
      'selectedArea': selectedArea,
      'selectedCategories': selectedCategories,
      'enablePushNotifications': enablePushNotifications,
      'enableLocationServices': enableLocationServices,
      'language': language,
      'theme': theme,
    };
  }
  
  /// Create a copy of UserPreferences with updated fields
  UserPreferences copyWith({
    String? selectedArea,
    List<String>? selectedCategories,
    bool? enablePushNotifications,
    bool? enableLocationServices,
    String? language,
    String? theme,
  }) {
    return UserPreferences(
      selectedArea: selectedArea ?? this.selectedArea,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      enablePushNotifications: enablePushNotifications ?? this.enablePushNotifications,
      enableLocationServices: enableLocationServices ?? this.enableLocationServices,
      language: language ?? this.language,
      theme: theme ?? this.theme,
    );
  }
}
