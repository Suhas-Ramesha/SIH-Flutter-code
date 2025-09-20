/// Notification model for user notifications
class NotificationModel {
  final String id;
  final String userId;
  final String type; // 'like', 'upvote', 'comment', 'status_update', 'bbmp_message'
  final String title;
  final String message;
  final String? postId;
  final String? postTitle;
  final String? fromUserId;
  final String? fromUsername;
  final String? fromUserAvatar;
  final DateTime createdAt;
  final bool isRead;
  final Map<String, dynamic>? metadata;
  
  const NotificationModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.message,
    this.postId,
    this.postTitle,
    this.fromUserId,
    this.fromUsername,
    this.fromUserAvatar,
    required this.createdAt,
    this.isRead = false,
    this.metadata,
  });
  
  /// Create a NotificationModel from JSON
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      postId: json['postId'] as String?,
      postTitle: json['postTitle'] as String?,
      fromUserId: json['fromUserId'] as String?,
      fromUsername: json['fromUsername'] as String?,
      fromUserAvatar: json['fromUserAvatar'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isRead: json['isRead'] as bool? ?? false,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }
  
  /// Convert NotificationModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'type': type,
      'title': title,
      'message': message,
      'postId': postId,
      'postTitle': postTitle,
      'fromUserId': fromUserId,
      'fromUsername': fromUsername,
      'fromUserAvatar': fromUserAvatar,
      'createdAt': createdAt.toIso8601String(),
      'isRead': isRead,
      'metadata': metadata,
    };
  }
  
  /// Create a copy of this NotificationModel with updated fields
  NotificationModel copyWith({
    String? id,
    String? userId,
    String? type,
    String? title,
    String? message,
    String? postId,
    String? postTitle,
    String? fromUserId,
    String? fromUsername,
    String? fromUserAvatar,
    DateTime? createdAt,
    bool? isRead,
    Map<String, dynamic>? metadata,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      postId: postId ?? this.postId,
      postTitle: postTitle ?? this.postTitle,
      fromUserId: fromUserId ?? this.fromUserId,
      fromUsername: fromUsername ?? this.fromUsername,
      fromUserAvatar: fromUserAvatar ?? this.fromUserAvatar,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      metadata: metadata ?? this.metadata,
    );
  }
  
  /// Get time since creation
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
  
  /// Get notification icon based on type
  String get iconName {
    switch (type) {
      case 'like':
        return 'thumb_up';
      case 'upvote':
        return 'keyboard_arrow_up';
      case 'comment':
        return 'comment';
      case 'status_update':
        return 'update';
      case 'bbmp_message':
        return 'message';
      default:
        return 'notifications';
    }
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NotificationModel && other.id == id;
  }
  
  @override
  int get hashCode => id.hashCode;
  
  @override
  String toString() {
    return 'NotificationModel(id: $id, type: $type, title: $title, isRead: $isRead)';
  }
}

/// Notification types enum
enum NotificationType {
  like,
  upvote,
  comment,
  statusUpdate,
  bbmpMessage,
  communityMessage,
}

/// Helper class for creating notifications
class NotificationFactory {
  static NotificationModel createLikeNotification({
    required String id,
    required String userId,
    required String postId,
    required String postTitle,
    required String fromUserId,
    required String fromUsername,
    required String fromUserAvatar,
  }) {
    return NotificationModel(
      id: id,
      userId: userId,
      type: 'like',
      title: 'New Like',
      message: '$fromUsername liked your post "$postTitle"',
      postId: postId,
      postTitle: postTitle,
      fromUserId: fromUserId,
      fromUsername: fromUsername,
      fromUserAvatar: fromUserAvatar,
      createdAt: DateTime.now(),
    );
  }
  
  static NotificationModel createUpvoteNotification({
    required String id,
    required String userId,
    required String postId,
    required String postTitle,
    required String fromUserId,
    required String fromUsername,
    required String fromUserAvatar,
  }) {
    return NotificationModel(
      id: id,
      userId: userId,
      type: 'upvote',
      title: 'New Upvote',
      message: '$fromUsername upvoted your post "$postTitle"',
      postId: postId,
      postTitle: postTitle,
      fromUserId: fromUserId,
      fromUsername: fromUsername,
      fromUserAvatar: fromUserAvatar,
      createdAt: DateTime.now(),
    );
  }
  
  static NotificationModel createCommentNotification({
    required String id,
    required String userId,
    required String postId,
    required String postTitle,
    required String fromUserId,
    required String fromUsername,
    required String fromUserAvatar,
    required String commentText,
  }) {
    return NotificationModel(
      id: id,
      userId: userId,
      type: 'comment',
      title: 'New Comment',
      message: '$fromUsername commented on your post "$postTitle"',
      postId: postId,
      postTitle: postTitle,
      fromUserId: fromUserId,
      fromUsername: fromUsername,
      fromUserAvatar: fromUserAvatar,
      createdAt: DateTime.now(),
      metadata: {'commentText': commentText},
    );
  }
  
  static NotificationModel createStatusUpdateNotification({
    required String id,
    required String userId,
    required String postId,
    required String postTitle,
    required String newStatus,
  }) {
    return NotificationModel(
      id: id,
      userId: userId,
      type: 'status_update',
      title: 'Status Update',
      message: 'Your post "$postTitle" status has been updated to $newStatus',
      postId: postId,
      postTitle: postTitle,
      createdAt: DateTime.now(),
      metadata: {'newStatus': newStatus},
    );
  }
  
  static NotificationModel createBbmpMessageNotification({
    required String id,
    required String userId,
    required String message,
    required String fromAdminName,
  }) {
    return NotificationModel(
      id: id,
      userId: userId,
      type: 'bbmp_message',
      title: 'BBMP Message',
      message: 'New message from $fromAdminName: $message',
      fromUsername: fromAdminName,
      createdAt: DateTime.now(),
    );
  }
  
  static NotificationModel createCommunityMessageNotification({
    required String id,
    required String userId,
    required String message,
    required String fromUserId,
    required String fromUsername,
    required String fromUserAvatar,
  }) {
    return NotificationModel(
      id: id,
      userId: userId,
      type: 'community_message',
      title: 'Community Message',
      message: 'New message from $fromUsername',
      fromUserId: fromUserId,
      fromUsername: fromUsername,
      fromUserAvatar: fromUserAvatar,
      createdAt: DateTime.now(),
    );
  }
}
