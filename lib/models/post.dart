/// Roadmap step model for tracking issue resolution progress
class RoadmapStep {
  final String status;
  final String description;
  final DateTime? timestamp;
  final String? assignedTo;
  final List<String>? attachments;
  
  const RoadmapStep({
    required this.status,
    required this.description,
    this.timestamp,
    this.assignedTo,
    this.attachments,
  });
  
  /// Create a RoadmapStep from JSON
  factory RoadmapStep.fromJson(Map<String, dynamic> json) {
    return RoadmapStep(
      status: json['status'] as String,
      description: json['description'] as String,
      timestamp: json['timestamp'] != null ? DateTime.parse(json['timestamp'] as String) : null,
      assignedTo: json['assignedTo'] as String?,
      attachments: List<String>.from(json['attachments'] as List? ?? []),
    );
  }
  
  /// Convert RoadmapStep to JSON
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'description': description,
      'timestamp': timestamp?.toIso8601String(),
      'assignedTo': assignedTo,
      'attachments': attachments,
    };
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RoadmapStep && other.status == status;
  }
  
  @override
  int get hashCode => status.hashCode;
}

/// Post model representing a civic report
class Post {
  final String id;
  final String userId;
  final String username;
  final String area;
  final String category;
  final String title;
  final String description;
  final List<String> images;
  final double latitude;
  final double longitude;
  final int upvotes;
  final int downvotes;
  final String status;
  final String severity;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final List<Comment> comments;
  final List<BbmpNote> bbmpNotes;
  final bool isVerified;
  final String? assignedTo;
  final DateTime? assignedAt;
  final DateTime? resolvedAt;
  final Map<String, dynamic>? metadata;
  final List<RoadmapStep> roadmapSteps;
  
  const Post({
    required this.id,
    required this.userId,
    required this.username,
    required this.area,
    required this.category,
    required this.title,
    required this.description,
    required this.images,
    required this.latitude,
    required this.longitude,
    required this.upvotes,
    required this.downvotes,
    required this.status,
    required this.severity,
    required this.createdAt,
    this.updatedAt,
    required this.comments,
    required this.bbmpNotes,
    this.isVerified = false,
    this.assignedTo,
    this.assignedAt,
    this.resolvedAt,
    this.metadata,
    this.roadmapSteps = const [],
  });
  
  /// Create a Post from JSON
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as String,
      userId: json['userId'] as String,
      username: json['username'] as String,
      area: json['area'] as String,
      category: json['category'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      images: List<String>.from(json['images'] as List? ?? []),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      upvotes: json['upvotes'] as int? ?? 0,
      downvotes: json['downvotes'] as int? ?? 0,
      status: json['status'] as String,
      severity: json['severity'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt'] as String) : null,
      comments: (json['comments'] as List? ?? [])
          .map((comment) => Comment.fromJson(comment as Map<String, dynamic>))
          .toList(),
      bbmpNotes: (json['bbmpNotes'] as List? ?? [])
          .map((note) => BbmpNote.fromJson(note as Map<String, dynamic>))
          .toList(),
      isVerified: json['isVerified'] as bool? ?? false,
      assignedTo: json['assignedTo'] as String?,
      assignedAt: json['assignedAt'] != null ? DateTime.parse(json['assignedAt'] as String) : null,
      resolvedAt: json['resolvedAt'] != null ? DateTime.parse(json['resolvedAt'] as String) : null,
      metadata: json['metadata'] as Map<String, dynamic>?,
      roadmapSteps: (json['roadmapSteps'] as List? ?? [])
          .map((step) => RoadmapStep.fromJson(step as Map<String, dynamic>))
          .toList(),
    );
  }
  
  /// Convert Post to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'username': username,
      'area': area,
      'category': category,
      'title': title,
      'description': description,
      'images': images,
      'latitude': latitude,
      'longitude': longitude,
      'upvotes': upvotes,
      'downvotes': downvotes,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'comments': comments.map((comment) => comment.toJson()).toList(),
      'bbmpNotes': bbmpNotes.map((note) => note.toJson()).toList(),
      'isVerified': isVerified,
      'assignedTo': assignedTo,
      'assignedAt': assignedAt?.toIso8601String(),
      'resolvedAt': resolvedAt?.toIso8601String(),
      'metadata': metadata,
      'roadmapSteps': roadmapSteps.map((step) => step.toJson()).toList(),
    };
  }
  
  /// Create a copy of this Post with updated fields
  Post copyWith({
    String? id,
    String? userId,
    String? username,
    String? area,
    String? category,
    String? title,
    String? description,
    List<String>? images,
    double? latitude,
    double? longitude,
    int? upvotes,
    int? downvotes,
    String? status,
    String? severity,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<Comment>? comments,
    List<BbmpNote>? bbmpNotes,
    bool? isVerified,
    String? assignedTo,
    DateTime? assignedAt,
    DateTime? resolvedAt,
    Map<String, dynamic>? metadata,
    List<RoadmapStep>? roadmapSteps,
  }) {
    return Post(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      area: area ?? this.area,
      category: category ?? this.category,
      title: title ?? this.title,
      description: description ?? this.description,
      images: images ?? this.images,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      upvotes: upvotes ?? this.upvotes,
      downvotes: downvotes ?? this.downvotes,
      status: status ?? this.status,
      severity: severity ?? this.severity,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      comments: comments ?? this.comments,
      bbmpNotes: bbmpNotes ?? this.bbmpNotes,
      isVerified: isVerified ?? this.isVerified,
      assignedTo: assignedTo ?? this.assignedTo,
      assignedAt: assignedAt ?? this.assignedAt,
      resolvedAt: resolvedAt ?? this.resolvedAt,
      metadata: metadata ?? this.metadata,
      roadmapSteps: roadmapSteps ?? this.roadmapSteps,
    );
  }
  
  /// Get net votes (upvotes - downvotes)
  int get netVotes => upvotes - downvotes;
  
  /// Get vote percentage
  double get votePercentage {
    final total = upvotes + downvotes;
    if (total == 0) return 0.0;
    return (upvotes / total) * 100;
  }
  
  /// Check if post is resolved
  bool get isResolved => status == 'Resolved' || status == 'Closed';
  
  /// Check if post is in progress
  bool get isInProgress => status == 'In Progress' || status == 'Assigned';
  
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
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Post && other.id == id;
  }
  
  @override
  int get hashCode => id.hashCode;
  
  @override
  String toString() {
    return 'Post(id: $id, title: $title, category: $category, status: $status, severity: $severity)';
  }
}

/// Comment model for post comments
class Comment {
  final String id;
  final String postId;
  final String userId;
  final String username;
  final String text;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? parentCommentId;
  final List<Comment> replies;
  final int upvotes;
  final int downvotes;
  final bool isFromAdmin;
  
  const Comment({
    required this.id,
    required this.postId,
    required this.userId,
    required this.username,
    required this.text,
    required this.createdAt,
    this.updatedAt,
    this.parentCommentId,
    required this.replies,
    this.upvotes = 0,
    this.downvotes = 0,
    this.isFromAdmin = false,
  });
  
  /// Create a Comment from JSON
  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'] as String,
      postId: json['postId'] as String,
      userId: json['userId'] as String,
      username: json['username'] as String,
      text: json['text'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt'] as String) : null,
      parentCommentId: json['parentCommentId'] as String?,
      replies: (json['replies'] as List? ?? [])
          .map((reply) => Comment.fromJson(reply as Map<String, dynamic>))
          .toList(),
      upvotes: json['upvotes'] as int? ?? 0,
      downvotes: json['downvotes'] as int? ?? 0,
      isFromAdmin: json['isFromAdmin'] as bool? ?? false,
    );
  }
  
  /// Convert Comment to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'postId': postId,
      'userId': userId,
      'username': username,
      'text': text,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'parentCommentId': parentCommentId,
      'replies': replies.map((reply) => reply.toJson()).toList(),
      'upvotes': upvotes,
      'downvotes': downvotes,
      'isFromAdmin': isFromAdmin,
    };
  }
  
  /// Get net votes (upvotes - downvotes)
  int get netVotes => upvotes - downvotes;
  
  /// Check if comment is a reply
  bool get isReply => parentCommentId != null;
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Comment && other.id == id;
  }
  
  @override
  int get hashCode => id.hashCode;
}

/// BBMP Note model for official updates
class BbmpNote {
  final String id;
  final String postId;
  final String adminId;
  final String adminName;
  final String text;
  final DateTime createdAt;
  final String? status;
  final List<String> attachments;
  
  const BbmpNote({
    required this.id,
    required this.postId,
    required this.adminId,
    required this.adminName,
    required this.text,
    required this.createdAt,
    this.status,
    required this.attachments,
  });
  
  /// Create a BbmpNote from JSON
  factory BbmpNote.fromJson(Map<String, dynamic> json) {
    return BbmpNote(
      id: json['id'] as String,
      postId: json['postId'] as String,
      adminId: json['adminId'] as String,
      adminName: json['adminName'] as String,
      text: json['text'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      status: json['status'] as String?,
      attachments: List<String>.from(json['attachments'] as List? ?? []),
    );
  }
  
  /// Convert BbmpNote to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'postId': postId,
      'adminId': adminId,
      'adminName': adminName,
      'text': text,
      'createdAt': createdAt.toIso8601String(),
      'status': status,
      'attachments': attachments,
    };
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BbmpNote && other.id == id;
  }
  
  @override
  int get hashCode => id.hashCode;
}

/// Create Post request model
class CreatePostRequest {
  final String title;
  final String description;
  final String category;
  final String severity;
  final double latitude;
  final double longitude;
  final String area;
  final List<String> images;
  
  const CreatePostRequest({
    required this.title,
    required this.description,
    required this.category,
    required this.severity,
    required this.latitude,
    required this.longitude,
    required this.area,
    required this.images,
  });
  
  /// Convert CreatePostRequest to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'severity': severity,
      'latitude': latitude,
      'longitude': longitude,
      'area': area,
      'images': images,
    };
  }
}

/// Update Post request model
class UpdatePostRequest {
  final String? status;
  final String? bbmpNote;
  final String? assignedTo;
  final Map<String, dynamic>? metadata;
  
  const UpdatePostRequest({
    this.status,
    this.bbmpNote,
    this.assignedTo,
    this.metadata,
  });
  
  /// Convert UpdatePostRequest to JSON
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (status != null) json['status'] = status;
    if (bbmpNote != null) json['bbmpNote'] = bbmpNote;
    if (assignedTo != null) json['assignedTo'] = assignedTo;
    if (metadata != null) json['metadata'] = metadata;
    return json;
  }
}

/// Post filter parameters
class PostFilters {
  final String? area;
  final String? category;
  final String? status;
  final String? severity;
  final String? sortBy; // 'newest', 'oldest', 'most_voted', 'near_me'
  final int page;
  final int limit;
  final double? userLatitude;
  final double? userLongitude;
  final double? radius; // in kilometers
  
  const PostFilters({
    this.area,
    this.category,
    this.status,
    this.severity,
    this.sortBy,
    this.page = 1,
    this.limit = 20,
    this.userLatitude,
    this.userLongitude,
    this.radius,
  });
  
  /// Convert PostFilters to query parameters
  Map<String, dynamic> toQueryParams() {
    final params = <String, dynamic>{
      'page': page,
      'limit': limit,
    };
    
    if (area != null) params['area'] = area;
    if (category != null) params['category'] = category;
    if (status != null) params['status'] = status;
    if (severity != null) params['severity'] = severity;
    if (sortBy != null) params['sort'] = sortBy;
    if (userLatitude != null) params['lat'] = userLatitude;
    if (userLongitude != null) params['lng'] = userLongitude;
    if (radius != null) params['radius'] = radius;
    
    return params;
  }
  
  /// Create a copy of PostFilters with updated fields
  PostFilters copyWith({
    String? area,
    String? category,
    String? status,
    String? severity,
    String? sortBy,
    int? page,
    int? limit,
    double? userLatitude,
    double? userLongitude,
    double? radius,
  }) {
    return PostFilters(
      area: area ?? this.area,
      category: category ?? this.category,
      status: status ?? this.status,
      severity: severity ?? this.severity,
      sortBy: sortBy ?? this.sortBy,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      userLatitude: userLatitude ?? this.userLatitude,
      userLongitude: userLongitude ?? this.userLongitude,
      radius: radius ?? this.radius,
    );
  }
}
