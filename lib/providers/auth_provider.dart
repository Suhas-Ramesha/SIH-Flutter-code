import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import '../core/env.dart';
import '../core/mock_data.dart';

/// Authentication state
class AuthState {
  final User? user;
  final String? token;
  final String? refreshToken;
  final bool isLoading;
  final String? error;
  final bool isAuthenticated;
  
  const AuthState({
    this.user,
    this.token,
    this.refreshToken,
    this.isLoading = false,
    this.error,
    this.isAuthenticated = false,
  });
  
  AuthState copyWith({
    User? user,
    String? token,
    String? refreshToken,
    bool? isLoading,
    String? error,
    bool? isAuthenticated,
  }) {
    return AuthState(
      user: user ?? this.user,
      token: token ?? this.token,
      refreshToken: refreshToken ?? this.refreshToken,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AuthState &&
        other.user == user &&
        other.token == token &&
        other.refreshToken == refreshToken &&
        other.isLoading == isLoading &&
        other.error == error &&
        other.isAuthenticated == isAuthenticated;
  }
  
  @override
  int get hashCode {
    return Object.hash(user, token, refreshToken, isLoading, error, isAuthenticated);
  }
}

/// Authentication notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final ApiService _apiService;
  
  AuthNotifier(this._apiService) : super(const AuthState()) {
    _initializeAuth();
  }
  
  /// Initialize authentication state
  Future<void> _initializeAuth() async {
    try {
      // TODO: Load stored auth data from secure storage
      // For now, start with unauthenticated state
      state = state.copyWith(isAuthenticated: false);
    } catch (e) {
      state = state.copyWith(error: 'Failed to initialize auth: $e');
    }
  }
  
  /// Login with email and password
  Future<void> login(String email, String password, {bool rememberMe = false}) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final request = LoginRequest(
        email: email,
        password: password,
        rememberMe: rememberMe,
      );
      
      final response = await _apiService.login(request);
      
      // TODO: Store auth data in secure storage
      // await _storeAuthData(response);
      
      state = state.copyWith(
        user: response.user,
        token: response.token,
        refreshToken: response.refreshToken,
        isLoading: false,
        isAuthenticated: true,
        error: null,
      );
      
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        isAuthenticated: false,
      );
    }
  }
  
  /// Login as admin (for testing)
  Future<void> loginAsAdmin() async {
    await login('admin@civicreporter.com', 'password123');
  }
  
  /// Login as user (for testing)
  Future<void> loginAsUser() async {
    await login('user@example.com', 'password123');
  }
  
  /// Logout
  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    
    try {
      await _apiService.logout();
      
      // TODO: Clear stored auth data
      // await _clearAuthData();
      
      state = const AuthState(isAuthenticated: false);
      
    } catch (e) {
      // Even if logout fails on server, clear local state
      state = const AuthState(isAuthenticated: false);
    }
  }
  
  /// Refresh authentication token
  Future<void> refreshAuthToken() async {
    if (state.refreshToken == null) {
      await logout();
      return;
    }
    
    try {
      final response = await _apiService.refreshToken(state.refreshToken!);
      
      // TODO: Update stored auth data
      // await _storeAuthData(response);
      
      state = state.copyWith(
        token: response.token,
        refreshToken: response.refreshToken,
        user: response.user,
      );
      
    } catch (e) {
      // Refresh failed, logout user
      await logout();
    }
  }
  
  /// Update user profile
  Future<void> updateProfile(Map<String, dynamic> updates) async {
    if (state.user == null) return;
    
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final updatedUser = await _apiService.updateUserProfile(updates);
      
      state = state.copyWith(
        user: updatedUser,
        isLoading: false,
        error: null,
      );
      
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
  
  /// Change password
  Future<void> changePassword(String currentPassword, String newPassword) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      await _apiService.changePassword(currentPassword, newPassword);
      
      state = state.copyWith(
        isLoading: false,
        error: null,
      );
      
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
  
  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }
  
  /// Check if user is admin
  bool get isAdmin => state.user?.isAdmin ?? false;
  
  /// Check if user is authenticated
  bool get isAuthenticated => state.isAuthenticated;
  
  /// Get current user
  User? get currentUser => state.user;
  
  /// Get auth token
  String? get token => state.token;
  
  /// Store auth data in secure storage
  Future<void> _storeAuthData(AuthResponse response) async {
    // TODO: Implement secure storage
    // await SecureStorage.store('auth_token', response.token);
    // await SecureStorage.store('refresh_token', response.refreshToken);
    // await SecureStorage.store('user_data', jsonEncode(response.user.toJson()));
  }
  
  /// Clear auth data from secure storage
  Future<void> _clearAuthData() async {
    // TODO: Implement secure storage cleanup
    // await SecureStorage.delete('auth_token');
    // await SecureStorage.delete('refresh_token');
    // await SecureStorage.delete('user_data');
  }
}

/// API service provider
final apiServiceProvider = Provider<ApiService>((ref) {
  if (Env.shouldUseRealApi) {
    // TODO: Create HttpApiService with proper configuration
    final dio = Dio();
    return HttpApiService(dio: dio);
  } else {
    return MockApiService();
  }
});

/// Authentication provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return AuthNotifier(apiService);
});

/// Current user provider
final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authProvider);
  return authState.user;
});

/// Is authenticated provider
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authProvider);
  return authState.isAuthenticated;
});

/// Is admin provider
final isAdminProvider = Provider<bool>((ref) {
  final authState = ref.watch(authProvider);
  return authState.user?.isAdmin ?? false;
});

/// Auth token provider
final authTokenProvider = Provider<String?>((ref) {
  final authState = ref.watch(authProvider);
  return authState.token;
});

/// Auth loading state provider
final authLoadingProvider = Provider<bool>((ref) {
  final authState = ref.watch(authProvider);
  return authState.isLoading;
});

/// Auth error provider
final authErrorProvider = Provider<String?>((ref) {
  final authState = ref.watch(authProvider);
  return authState.error;
});
