import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/notification.dart';
import '../core/mock_data.dart';

/// State class for notifications
class NotificationsState {
  final List<NotificationModel> notifications;
  final bool isLoading;
  final String? error;
  final int unreadCount;
  
  const NotificationsState({
    required this.notifications,
    this.isLoading = false,
    this.error,
    required this.unreadCount,
  });
  
  NotificationsState copyWith({
    List<NotificationModel>? notifications,
    bool? isLoading,
    String? error,
    int? unreadCount,
  }) {
    return NotificationsState(
      notifications: notifications ?? this.notifications,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}

/// Notifications provider
final notificationsProvider = StateNotifierProvider<NotificationsNotifier, NotificationsState>((ref) {
  return NotificationsNotifier();
});

/// Notifications notifier
class NotificationsNotifier extends StateNotifier<NotificationsState> {
  NotificationsNotifier() : super(
    NotificationsState(
      notifications: [],
      unreadCount: 0,
    ),
  ) {
    _loadNotifications();
  }
  
  /// Load notifications for the current user
  Future<void> _loadNotifications() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Get mock notifications
      final notifications = MockData.getNotificationsForUser('u1'); // Mock current user
      final unreadCount = notifications.where((n) => !n.isRead).length;
      
      state = state.copyWith(
        notifications: notifications,
        isLoading: false,
        unreadCount: unreadCount,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
  
  /// Refresh notifications
  Future<void> refreshNotifications() async {
    await _loadNotifications();
  }
  
  /// Mark notification as read
  Future<void> markAsRead(String notificationId) async {
    final updatedNotifications = state.notifications.map((notification) {
      if (notification.id == notificationId) {
        return notification.copyWith(isRead: true);
      }
      return notification;
    }).toList();
    
    final unreadCount = updatedNotifications.where((n) => !n.isRead).length;
    
    state = state.copyWith(
      notifications: updatedNotifications,
      unreadCount: unreadCount,
    );
  }
  
  /// Mark all notifications as read
  Future<void> markAllAsRead() async {
    final updatedNotifications = state.notifications.map((notification) {
      return notification.copyWith(isRead: true);
    }).toList();
    
    state = state.copyWith(
      notifications: updatedNotifications,
      unreadCount: 0,
    );
  }
  
  /// Add new notification
  void addNotification(NotificationModel notification) {
    final updatedNotifications = [notification, ...state.notifications];
    final unreadCount = updatedNotifications.where((n) => !n.isRead).length;
    
    state = state.copyWith(
      notifications: updatedNotifications,
      unreadCount: unreadCount,
    );
  }
  
  /// Remove notification
  void removeNotification(String notificationId) {
    final updatedNotifications = state.notifications
        .where((notification) => notification.id != notificationId)
        .toList();
    final unreadCount = updatedNotifications.where((n) => !n.isRead).length;
    
    state = state.copyWith(
      notifications: updatedNotifications,
      unreadCount: unreadCount,
    );
  }
  
  /// Get notifications by type
  List<NotificationModel> getNotificationsByType(String type) {
    return state.notifications.where((n) => n.type == type).toList();
  }
  
  /// Get unread notifications
  List<NotificationModel> getUnreadNotifications() {
    return state.notifications.where((n) => !n.isRead).toList();
  }
  
  /// Get recent notifications (last 7 days)
  List<NotificationModel> getRecentNotifications() {
    final weekAgo = DateTime.now().subtract(const Duration(days: 7));
    return state.notifications
        .where((n) => n.createdAt.isAfter(weekAgo))
        .toList();
  }
}

/// Provider for unread notification count
final unreadNotificationCountProvider = Provider<int>((ref) {
  final notificationsState = ref.watch(notificationsProvider);
  return notificationsState.unreadCount;
});

/// Provider for notifications by type
final notificationsByTypeProvider = Provider.family<List<NotificationModel>, String>((ref, type) {
  final notificationsState = ref.watch(notificationsProvider);
  return notificationsState.notifications.where((n) => n.type == type).toList();
});

/// Provider for unread notifications
final unreadNotificationsProvider = Provider<List<NotificationModel>>((ref) {
  final notificationsState = ref.watch(notificationsProvider);
  return notificationsState.notifications.where((n) => !n.isRead).toList();
});

/// Provider for recent notifications
final recentNotificationsProvider = Provider<List<NotificationModel>>((ref) {
  final notificationsState = ref.watch(notificationsProvider);
  final weekAgo = DateTime.now().subtract(const Duration(days: 7));
  return notificationsState.notifications
      .where((n) => n.createdAt.isAfter(weekAgo))
      .toList();
});
