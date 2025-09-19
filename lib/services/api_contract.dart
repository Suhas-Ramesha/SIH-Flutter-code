/// API Contract for Civic Reporter Backend
/// 
/// This file defines the expected API endpoints, request/response formats,
/// and data structures that the backend must implement.
/// 
/// TODO: Update all endpoints to include proper JWT authentication headers
/// TODO: Implement proper error handling and status codes
/// TODO: Add request/response validation

class ApiContract {
  // Base URLs
  static const String baseUrl = 'https://api.civicreporter.com';
  static const String wsUrl = 'wss://api.civicreporter.com/ws';
  static const String storageUrl = 'https://storage.civicreporter.com';
  
  // Authentication Endpoints
  static const String loginEndpoint = '/auth/login';
  static const String refreshEndpoint = '/auth/refresh';
  static const String logoutEndpoint = '/auth/logout';
  
  // Posts Endpoints
  static const String postsEndpoint = '/posts';
  static const String postDetailEndpoint = '/posts/{id}';
  static const String postStatusEndpoint = '/posts/{id}/status';
  static const String postVoteEndpoint = '/posts/{id}/vote';
  static const String postCommentsEndpoint = '/posts/{id}/comments';
  
  // User Endpoints
  static const String userProfileEndpoint = '/users/me';
  static const String userPostsEndpoint = '/users/{userId}/posts';
  static const String userPasswordEndpoint = '/users/me/password';
  
  // Map Endpoints
  static const String mapMarkersEndpoint = '/map/markers';
  
  // Upload Endpoints
  static const String uploadEndpoint = '/uploads';
  static const String batchUploadEndpoint = '/uploads/batch';
  
  // Conversation Endpoints
  static const String conversationsEndpoint = '/conversations';
  static const String conversationMessagesEndpoint = '/conversations/{id}/messages';
  
  // WebSocket Events
  static const String wsPostEvents = 'post_events';
  static const String wsMessageEvents = 'message_events';
  static const String wsStatusEvents = 'status_events';
}

/// Sample Request/Response JSON structures
class ApiSamples {
  
  // Authentication Samples
  static const Map<String, dynamic> loginRequest = {
    'email': 'user@example.com',
    'password': 'password123',
    'rememberMe': false,
  };
  
  static const Map<String, dynamic> loginResponse = {
    'token': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
    'refreshToken': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
    'user': {
      'id': 'u1',
      'email': 'user@example.com',
      'username': 'Test User',
      'role': 'user',
      'area': 'Koramangala 4th Block',
      'reputation': 150,
      'createdAt': '2024-01-15T10:00:00Z',
      'isVerified': false,
    },
    'expiresAt': '2024-01-16T10:00:00Z',
  };
  
  static const Map<String, dynamic> refreshRequest = {
    'refreshToken': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
  };
  
  static const Map<String, dynamic> refreshResponse = {
    'token': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
    'expiresAt': '2024-01-16T10:00:00Z',
  };
  
  // Posts Samples
  static const Map<String, dynamic> fetchPostsRequest = {
    'page': 1,
    'limit': 20,
    'area': 'Koramangala 4th Block',
    'category': 'Potholes',
    'status': 'Reported',
    'severity': 'High',
    'sort': 'newest',
    'lat': 12.9716,
    'lng': 77.5946,
    'radius': 5.0,
  };
  
  static const Map<String, dynamic> fetchPostsResponse = {
    'posts': [
      {
        'id': 'p1',
        'userId': 'u1',
        'username': 'Anu',
        'area': 'Koramangala 4th Block',
        'category': 'Potholes',
        'title': 'Deep pothole near gate',
        'description': 'Huge pothole causing two-wheeler falls.',
        'images': ['https://storage.civicreporter.com/images/pothole1.jpg'],
        'latitude': 12.935,
        'longitude': 77.623,
        'upvotes': 42,
        'downvotes': 3,
        'status': 'Reported',
        'severity': 'High',
        'createdAt': '2025-07-01T08:30:00Z',
        'updatedAt': null,
        'comments': [],
        'bbmpNotes': [],
        'isVerified': false,
        'assignedTo': null,
        'assignedAt': null,
        'resolvedAt': null,
      }
    ],
    'pagination': {
      'page': 1,
      'limit': 20,
      'total': 1,
      'hasMore': false,
    },
  };
  
  static const Map<String, dynamic> createPostRequest = {
    'title': 'New pothole report',
    'description': 'Large pothole on main road causing traffic issues',
    'category': 'Potholes',
    'severity': 'High',
    'latitude': 12.9716,
    'longitude': 77.5946,
    'area': 'Koramangala 4th Block',
    'images': ['https://storage.civicreporter.com/images/pothole_new.jpg'],
  };
  
  static const Map<String, dynamic> createPostResponse = {
    'id': 'p_new',
    'userId': 'u1',
    'username': 'Test User',
    'area': 'Koramangala 4th Block',
    'category': 'Potholes',
    'title': 'New pothole report',
    'description': 'Large pothole on main road causing traffic issues',
    'images': ['https://storage.civicreporter.com/images/pothole_new.jpg'],
    'latitude': 12.9716,
    'longitude': 77.5946,
    'upvotes': 0,
    'downvotes': 0,
    'status': 'Reported',
    'severity': 'High',
    'createdAt': '2024-01-15T10:00:00Z',
    'updatedAt': null,
    'comments': [],
    'bbmpNotes': [],
    'isVerified': false,
    'assignedTo': null,
    'assignedAt': null,
    'resolvedAt': null,
  };
  
  static const Map<String, dynamic> updatePostStatusRequest = {
    'status': 'Under Review',
    'bbmpNote': 'Report received and under review by our team',
    'assignedTo': 'team_drainage',
  };
  
  static const Map<String, dynamic> updatePostStatusResponse = {
    'id': 'p1',
    'userId': 'u1',
    'username': 'Anu',
    'area': 'Koramangala 4th Block',
    'category': 'Potholes',
    'title': 'Deep pothole near gate',
    'description': 'Huge pothole causing two-wheeler falls.',
    'images': ['https://storage.civicreporter.com/images/pothole1.jpg'],
    'latitude': 12.935,
    'longitude': 77.623,
    'upvotes': 42,
    'downvotes': 3,
    'status': 'Under Review',
    'severity': 'High',
    'createdAt': '2025-07-01T08:30:00Z',
    'updatedAt': '2024-01-15T10:00:00Z',
    'comments': [],
    'bbmpNotes': [
      {
        'id': 'note_1',
        'postId': 'p1',
        'adminId': 'admin1',
        'adminName': 'Admin',
        'text': 'Report received and under review by our team',
        'createdAt': '2024-01-15T10:00:00Z',
        'status': null,
        'attachments': [],
      }
    ],
    'isVerified': false,
    'assignedTo': 'team_drainage',
    'assignedAt': '2024-01-15T10:00:00Z',
    'resolvedAt': null,
  };
  
  // Voting Samples
  static const Map<String, dynamic> voteRequest = {
    'action': 'upvote', // 'upvote', 'downvote', 'remove'
  };
  
  static const Map<String, dynamic> voteResponse = {
    'postId': 'p1',
    'upvotes': 43,
    'downvotes': 3,
    'userVote': 'upvote', // 'upvote', 'downvote', null
  };
  
  // Comments Samples
  static const Map<String, dynamic> addCommentRequest = {
    'text': 'This is a serious issue that needs immediate attention',
    'parentCommentId': null, // For replies
  };
  
  static const Map<String, dynamic> addCommentResponse = {
    'id': 'c_new',
    'postId': 'p1',
    'userId': 'u1',
    'username': 'Test User',
    'text': 'This is a serious issue that needs immediate attention',
    'createdAt': '2024-01-15T10:00:00Z',
    'updatedAt': null,
    'parentCommentId': null,
    'replies': [],
    'upvotes': 0,
    'downvotes': 0,
    'isFromAdmin': false,
  };
  
  // Map Markers Samples
  static const Map<String, dynamic> fetchMarkersRequest = {
    'area': 'Koramangala 4th Block',
    'category': 'Potholes',
    'status': 'Reported',
    'severity': 'High',
  };
  
  static const Map<String, dynamic> fetchMarkersResponse = {
    'markers': [
      {
        'id': 'marker_1',
        'postId': 'p1',
        'latitude': 12.935,
        'longitude': 77.623,
        'title': 'Deep pothole near gate',
        'category': 'Potholes',
        'severity': 'High',
        'status': 'Reported',
        'upvotes': 42,
        'description': 'Huge pothole causing two-wheeler falls.',
        'images': ['https://storage.civicreporter.com/images/pothole1.jpg'],
      }
    ],
  };
  
  // Upload Samples
  static const Map<String, dynamic> uploadResponse = {
    'url': 'https://storage.civicreporter.com/images/upload_123.jpg',
    'filename': 'upload_123.jpg',
    'size': 1024000,
    'mimeType': 'image/jpeg',
  };
  
  static const Map<String, dynamic> batchUploadResponse = {
    'urls': [
      'https://storage.civicreporter.com/images/upload_123.jpg',
      'https://storage.civicreporter.com/images/upload_124.jpg',
    ],
    'files': [
      {
        'url': 'https://storage.civicreporter.com/images/upload_123.jpg',
        'filename': 'upload_123.jpg',
        'size': 1024000,
        'mimeType': 'image/jpeg',
      },
      {
        'url': 'https://storage.civicreporter.com/images/upload_124.jpg',
        'filename': 'upload_124.jpg',
        'size': 2048000,
        'mimeType': 'image/jpeg',
      },
    ],
  };
  
  // Conversations Samples
  static const Map<String, dynamic> fetchConversationsResponse = {
    'conversations': [
      {
        'id': 'conv1',
        'userId': 'u1',
        'username': 'Anu',
        'lastMessage': 'Thank you for the update!',
        'lastMessageTime': '2025-07-01T10:30:00Z',
        'unreadCount': 0,
      }
    ],
  };
  
  static const Map<String, dynamic> fetchMessagesResponse = {
    'messages': [
      {
        'id': 'msg1',
        'conversationId': 'conv1',
        'senderId': 'admin1',
        'senderName': 'Admin',
        'text': 'Your report has been received and is under review.',
        'timestamp': '2025-07-01T09:00:00Z',
        'isFromAdmin': true,
        'attachments': [],
      }
    ],
  };
  
  static const Map<String, dynamic> sendMessageRequest = {
    'text': 'Thank you for the update!',
    'attachments': [],
  };
  
  // WebSocket Event Samples
  static const Map<String, dynamic> wsPostCreatedEvent = {
    'type': 'post_created',
    'data': {
      'postId': 'p_new',
      'title': 'New report: Streetlight not working',
      'category': 'Streetlights not working',
      'area': 'Koramangala',
      'severity': 'Medium',
      'username': 'New User',
      'createdAt': '2024-01-15T10:00:00Z',
    },
    'timestamp': '2024-01-15T10:00:00Z',
  };
  
  static const Map<String, dynamic> wsStatusChangedEvent = {
    'type': 'status_changed',
    'data': {
      'postId': 'p1',
      'oldStatus': 'Reported',
      'newStatus': 'Under Review',
      'adminName': 'Admin',
      'note': 'Report is being reviewed by our team',
      'updatedAt': '2024-01-15T10:00:00Z',
    },
    'timestamp': '2024-01-15T10:00:00Z',
  };
  
  static const Map<String, dynamic> wsNewMessageEvent = {
    'type': 'new_message',
    'data': {
      'conversationId': 'conv1',
      'messageId': 'msg_new',
      'senderId': 'admin1',
      'senderName': 'Admin',
      'text': 'Thank you for your report. We are working on it.',
      'isFromAdmin': true,
      'timestamp': '2024-01-15T10:00:00Z',
    },
    'timestamp': '2024-01-15T10:00:00Z',
  };
  
  static const Map<String, dynamic> wsUserTypingEvent = {
    'type': 'user_typing',
    'data': {
      'conversationId': 'conv1',
      'userId': 'u1',
      'username': 'Test User',
      'isTyping': true,
    },
    'timestamp': '2024-01-15T10:00:00Z',
  };
  
  // Error Response Sample
  static const Map<String, dynamic> errorResponse = {
    'error': {
      'code': 'VALIDATION_ERROR',
      'message': 'Invalid input data',
      'details': {
        'field': 'email',
        'reason': 'Invalid email format',
      },
    },
    'timestamp': '2024-01-15T10:00:00Z',
  };
}

/// HTTP Status Codes
class HttpStatus {
  static const int ok = 200;
  static const int created = 201;
  static const int noContent = 204;
  static const int badRequest = 400;
  static const int unauthorized = 401;
  static const int forbidden = 403;
  static const int notFound = 404;
  static const int conflict = 409;
  static const int unprocessableEntity = 422;
  static const int tooManyRequests = 429;
  static const int internalServerError = 500;
  static const int serviceUnavailable = 503;
}

/// Authentication Headers
class AuthHeaders {
  static const String authorization = 'Authorization';
  static const String bearerPrefix = 'Bearer ';
  
  // TODO: Add JWT token to all authenticated requests
  static Map<String, String> getAuthHeaders(String token) {
    return {
      authorization: '$bearerPrefix$token',
      'Content-Type': 'application/json',
    };
  }
  
  static Map<String, String> getUploadHeaders(String token) {
    return {
      authorization: '$bearerPrefix$token',
      'Content-Type': 'multipart/form-data',
    };
  }
}

/// WebSocket Connection Headers
class WsHeaders {
  static const String authorization = 'Authorization';
  static const String bearerPrefix = 'Bearer ';
  
  // TODO: Add JWT token to WebSocket connection
  static Map<String, String> getWsHeaders(String token) {
    return {
      authorization: '$bearerPrefix$token',
    };
  }
}
