import '../models/user.dart';
import '../models/post.dart';
import '../models/notification.dart';

/// Mock data for development and testing
/// 
/// TODO: Remove this file when connecting to real API
class MockData {
  // Mock Users
  static final List<User> mockUsers = [
    User(
      id: 'u1',
      email: 'anu@example.com',
      username: 'Anu',
      role: 'user',
      area: 'Koramangala 4th Block',
      reputation: 150,
      createdAt: DateTime.parse('2024-01-15T10:00:00Z'),
    ),
    User(
      id: 'u2',
      email: 'ravi@example.com',
      username: 'Ravi',
      role: 'user',
      area: 'Jayanagar',
      reputation: 89,
      createdAt: DateTime.parse('2024-02-20T14:30:00Z'),
    ),
    User(
      id: 'u3',
      email: 'priya@example.com',
      username: 'Priya',
      role: 'user',
      area: 'Malleshwaram',
      reputation: 203,
      createdAt: DateTime.parse('2024-01-08T09:15:00Z'),
    ),
    User(
      id: 'u4',
      email: 'kumar@example.com',
      username: 'Kumar',
      role: 'user',
      area: 'Koramangala 5th Block',
      reputation: 67,
      createdAt: DateTime.parse('2024-03-10T16:45:00Z'),
    ),
    User(
      id: 'u5',
      email: 'meera@example.com',
      username: 'Meera',
      role: 'user',
      area: 'HSR Layout',
      reputation: 134,
      createdAt: DateTime.parse('2024-02-05T11:20:00Z'),
    ),
    User(
      id: 'u6',
      email: 'suresh@example.com',
      username: 'Suresh',
      role: 'user',
      area: 'Indiranagar',
      reputation: 98,
      createdAt: DateTime.parse('2024-03-15T13:10:00Z'),
    ),
    User(
      id: 'u7',
      email: 'latha@example.com',
      username: 'Latha',
      role: 'user',
      area: 'Basavanagudi',
      reputation: 187,
      createdAt: DateTime.parse('2024-01-25T08:30:00Z'),
    ),
    User(
      id: 'u8',
      email: 'arjun@example.com',
      username: 'Arjun',
      role: 'user',
      area: 'Koramangala',
      reputation: 112,
      createdAt: DateTime.parse('2024-02-28T15:00:00Z'),
    ),
    // Admin user for testing
    User(
      id: 'admin1',
      email: 'admin@civicreporter.com',
      username: 'Admin',
      role: 'admin',
      area: 'Bangalore',
      reputation: 500,
      createdAt: DateTime.parse('2024-01-01T00:00:00Z'),
    ),
  ];
  
  // Mock Posts
  static final List<Post> mockPosts = [
    Post(
      id: 'p1',
      userId: 'u1',
      username: 'Anu',
      area: 'Koramangala 4th Block',
      category: 'Potholes',
      title: 'Deep pothole near gate',
      description: 'Huge pothole causing two-wheeler falls. This has been here for weeks and is getting worse with each rain.',
      images: ['assets/images/pothole1.jpg'],
      latitude: 12.935,
      longitude: 77.623,
      upvotes: 42,
      downvotes: 3,
      status: 'Reported',
      severity: 'High',
      createdAt: DateTime.parse('2025-07-01T08:30:00Z'),
      comments: [],
      bbmpNotes: [],
      roadmapSteps: [
        RoadmapStep(
          status: 'Reported',
          description: 'Issue has been reported and is awaiting review',
          timestamp: DateTime.parse('2025-07-01T08:30:00Z'),
        ),
      ],
    ),
    Post(
      id: 'p2',
      userId: 'u2',
      username: 'Ravi',
      area: 'Jayanagar',
      category: 'Streetlights not working',
      title: 'Streetlight not working',
      description: 'Whole street dark after 8pm. Very dangerous for pedestrians and vehicles.',
      images: ['assets/images/streetlight1.jpg'],
      latitude: 12.92,
      longitude: 77.58,
      upvotes: 15,
      downvotes: 0,
      status: 'Under Review',
      severity: 'Medium',
      createdAt: DateTime.parse('2025-07-02T10:00:00Z'),
      comments: [],
      bbmpNotes: [
        BbmpNote(
          id: 'note_1',
          postId: 'p2',
          adminId: 'admin1',
          adminName: 'Admin',
          text: 'Report received and under review',
          createdAt: DateTime(2025, 7, 2, 11, 0),
          attachments: [],
        ),
      ],
      roadmapSteps: [
        RoadmapStep(
          status: 'Reported',
          description: 'Issue has been reported and is awaiting review',
          timestamp: DateTime.parse('2025-07-02T10:00:00Z'),
        ),
        RoadmapStep(
          status: 'Under Review',
          description: 'BBMP officials are reviewing the issue',
          timestamp: DateTime.parse('2025-07-02T11:00:00Z'),
        ),
      ],
    ),
    Post(
      id: 'p3',
      userId: 'u3',
      username: 'Priya',
      area: 'Malleshwaram',
      category: 'Waterlogging / Drainage blockages',
      title: 'Drain blocked after rain',
      description: 'Waterlogging reaches knee height. Children cannot go to school safely.',
      images: ['assets/images/water1.jpg'],
      latitude: 13.01,
      longitude: 77.57,
      upvotes: 33,
      downvotes: 1,
      status: 'Assigned',
      severity: 'High',
      createdAt: DateTime.parse('2025-07-03T07:20:00Z'),
      comments: [],
      bbmpNotes: [
        BbmpNote(
          id: 'note_2',
          postId: 'p3',
          adminId: 'admin1',
          adminName: 'Admin',
          text: 'Assigned to drainage team',
          createdAt: DateTime(2025, 7, 3, 8, 0),
          attachments: [],
        ),
        BbmpNote(
          id: 'note_3',
          postId: 'p3',
          adminId: 'admin1',
          adminName: 'Admin',
          text: 'Work order created',
          createdAt: DateTime(2025, 7, 3, 9, 0),
          attachments: [],
        ),
      ],
      roadmapSteps: [
        RoadmapStep(
          status: 'Reported',
          description: 'Issue has been reported and is awaiting review',
          timestamp: DateTime.parse('2025-07-03T07:20:00Z'),
        ),
        RoadmapStep(
          status: 'Under Review',
          description: 'BBMP officials are reviewing the issue',
          timestamp: DateTime.parse('2025-07-03T07:45:00Z'),
        ),
        RoadmapStep(
          status: 'Assigned',
          description: 'Issue has been assigned to a department',
          timestamp: DateTime.parse('2025-07-03T08:00:00Z'),
        ),
      ],
    ),
    Post(
      id: 'p4',
      userId: 'u4',
      username: 'Kumar',
      area: 'Koramangala 5th Block',
      category: 'Broken / Missing Road Signs',
      title: 'Missing road sign',
      description: 'Stop sign removed. Traffic confusion at intersection.',
      images: ['assets/images/sign1.jpg'],
      latitude: 12.936,
      longitude: 77.62,
      upvotes: 5,
      downvotes: 0,
      status: 'Reported',
      severity: 'Low',
      createdAt: DateTime.parse('2025-07-03T11:05:00Z'),
      comments: [],
      bbmpNotes: [],
      roadmapSteps: [
        RoadmapStep(
          status: 'Reported',
          description: 'Issue has been reported and is awaiting review',
          timestamp: DateTime.parse('2025-07-03T11:05:00Z'),
        ),
      ],
    ),
    Post(
      id: 'p5',
      userId: 'u5',
      username: 'Meera',
      area: 'HSR Layout',
      category: 'Trash / Illegal dumping',
      title: 'Illegal dumping near lane',
      description: 'Trash accumulated for 2 weeks. Health hazard for residents.',
      images: ['assets/images/trash1.jpg'],
      latitude: 12.91,
      longitude: 77.64,
      upvotes: 20,
      downvotes: 2,
      status: 'In Progress',
      severity: 'Medium',
      createdAt: DateTime.parse('2025-06-30T16:45:00Z'),
      comments: [],
      bbmpNotes: [
        BbmpNote(
          id: 'note_4',
          postId: 'p5',
          adminId: 'admin1',
          adminName: 'Admin',
          text: 'Cleanup team dispatched',
          createdAt: DateTime(2025, 7, 1, 8, 0),
          attachments: [],
        ),
        BbmpNote(
          id: 'note_5',
          postId: 'p5',
          adminId: 'admin1',
          adminName: 'Admin',
          text: 'Regular monitoring scheduled',
          createdAt: DateTime(2025, 7, 1, 9, 0),
          attachments: [],
        ),
      ],
      roadmapSteps: [
        RoadmapStep(
          status: 'Reported',
          description: 'Issue has been reported and is awaiting review',
          timestamp: DateTime.parse('2025-06-30T16:45:00Z'),
        ),
        RoadmapStep(
          status: 'Under Review',
          description: 'BBMP officials are reviewing the issue',
          timestamp: DateTime.parse('2025-06-30T17:00:00Z'),
        ),
        RoadmapStep(
          status: 'Assigned',
          description: 'Issue has been assigned to a department',
          timestamp: DateTime.parse('2025-07-01T07:30:00Z'),
        ),
        RoadmapStep(
          status: 'In Progress',
          description: 'Work is currently being done to resolve the issue',
          timestamp: DateTime.parse('2025-07-01T08:00:00Z'),
        ),
      ],
    ),
    Post(
      id: 'p6',
      userId: 'u6',
      username: 'Suresh',
      area: 'Indiranagar',
      category: 'Sidewalk / Footpath damage',
      title: 'Broken footpath slab',
      description: 'Tripping hazard for elderly. Multiple complaints from residents.',
      images: ['assets/images/sidewalk1.jpg'],
      latitude: 12.97,
      longitude: 77.64,
      upvotes: 8,
      downvotes: 0,
      status: 'Reported',
      severity: 'Medium',
      createdAt: DateTime.parse('2025-07-04T09:00:00Z'),
      comments: [],
      bbmpNotes: [],
      roadmapSteps: [
        RoadmapStep(
          status: 'Reported',
          description: 'Issue has been reported and is awaiting review',
          timestamp: DateTime.parse('2025-07-04T09:00:00Z'),
        ),
      ],
    ),
    Post(
      id: 'p7',
      userId: 'u7',
      username: 'Latha',
      area: 'Basavanagudi',
      category: 'Unsafe manhole / Missing covers',
      title: 'Open manhole cover missing',
      description: 'Dangerous for children. Deep hole with no warning signs.',
      images: ['assets/images/manhole1.jpg'],
      latitude: 12.95,
      longitude: 77.57,
      upvotes: 55,
      downvotes: 1,
      status: 'Assigned',
      severity: 'High',
      createdAt: DateTime.parse('2025-06-29T06:15:00Z'),
      comments: [],
      bbmpNotes: [
        BbmpNote(
          id: 'note_6',
          postId: 'p7',
          adminId: 'admin1',
          adminName: 'Admin',
          text: 'Emergency work order created',
          createdAt: DateTime(2025, 6, 29, 7, 0),
          attachments: [],
        ),
        BbmpNote(
          id: 'note_7',
          postId: 'p7',
          adminId: 'admin1',
          adminName: 'Admin',
          text: 'Safety barriers installed',
          createdAt: DateTime(2025, 6, 29, 8, 0),
          attachments: [],
        ),
      ],
      roadmapSteps: [
        RoadmapStep(
          status: 'Reported',
          description: 'Issue has been reported and is awaiting review',
          timestamp: DateTime.parse('2025-06-29T06:15:00Z'),
        ),
        RoadmapStep(
          status: 'Under Review',
          description: 'BBMP officials are reviewing the issue',
          timestamp: DateTime.parse('2025-06-29T06:30:00Z'),
        ),
        RoadmapStep(
          status: 'Assigned',
          description: 'Issue has been assigned to a department',
          timestamp: DateTime.parse('2025-06-29T07:00:00Z'),
        ),
      ],
    ),
    Post(
      id: 'p8',
      userId: 'u8',
      username: 'Arjun',
      area: 'Koramangala',
      category: 'Fallen trees / Vegetation blocking road',
      title: 'Fallen tree blocking road',
      description: 'Tree down after storm. Traffic completely blocked.',
      images: ['assets/images/tree1.jpg'],
      latitude: 12.9355,
      longitude: 77.6225,
      upvotes: 13,
      downvotes: 0,
      status: 'Resolved',
      severity: 'Medium',
      createdAt: DateTime.parse('2025-06-28T14:00:00Z'),
      comments: [],
      bbmpNotes: [
        BbmpNote(
          id: 'note_8',
          postId: 'p8',
          adminId: 'admin1',
          adminName: 'Admin',
          text: 'Tree removed successfully',
          createdAt: DateTime(2025, 6, 28, 15, 0),
          attachments: [],
        ),
        BbmpNote(
          id: 'note_9',
          postId: 'p8',
          adminId: 'admin1',
          adminName: 'Admin',
          text: 'Road cleared',
          createdAt: DateTime(2025, 6, 28, 16, 0),
          attachments: [],
        ),
        BbmpNote(
          id: 'note_10',
          postId: 'p8',
          adminId: 'admin1',
          adminName: 'Admin',
          text: 'Traffic restored',
          createdAt: DateTime(2025, 6, 28, 17, 0),
          attachments: [],
        ),
      ],
      roadmapSteps: [
        RoadmapStep(
          status: 'Reported',
          description: 'Issue has been reported and is awaiting review',
          timestamp: DateTime.parse('2025-06-28T14:00:00Z'),
        ),
        RoadmapStep(
          status: 'Under Review',
          description: 'BBMP officials are reviewing the issue',
          timestamp: DateTime.parse('2025-06-28T14:15:00Z'),
        ),
        RoadmapStep(
          status: 'Assigned',
          description: 'Issue has been assigned to a department',
          timestamp: DateTime.parse('2025-06-28T14:30:00Z'),
        ),
        RoadmapStep(
          status: 'In Progress',
          description: 'Work is currently being done to resolve the issue',
          timestamp: DateTime.parse('2025-06-28T14:45:00Z'),
        ),
        RoadmapStep(
          status: 'Resolved',
          description: 'Issue has been successfully resolved',
          timestamp: DateTime.parse('2025-06-28T16:00:00Z'),
        ),
      ],
    ),
  ];
  
  // Mock Conversations
  static final List<Map<String, dynamic>> mockConversations = [
    {
      'id': 'conv1',
      'userId': 'u1',
      'username': 'Anu',
      'lastMessage': 'Thank you for the update!',
      'lastMessageTime': DateTime.parse('2025-07-01T10:30:00Z'),
      'unreadCount': 0,
    },
    {
      'id': 'conv2',
      'userId': 'u2',
      'username': 'Ravi',
      'lastMessage': 'When will the streetlight be fixed?',
      'lastMessageTime': DateTime.parse('2025-07-02T11:00:00Z'),
      'unreadCount': 1,
    },
    {
      'id': 'conv3',
      'userId': 'u3',
      'username': 'Priya',
      'lastMessage': 'The drainage work has started',
      'lastMessageTime': DateTime.parse('2025-07-03T08:00:00Z'),
      'unreadCount': 0,
    },
  ];
  
  // Mock Messages
  static final List<Map<String, dynamic>> mockMessages = [
    {
      'id': 'msg1',
      'conversationId': 'conv1',
      'senderId': 'admin1',
      'senderName': 'Admin',
      'text': 'Your report has been received and is under review.',
      'timestamp': DateTime.parse('2025-07-01T09:00:00Z'),
      'isFromAdmin': true,
    },
    {
      'id': 'msg2',
      'conversationId': 'conv1',
      'senderId': 'u1',
      'senderName': 'Anu',
      'text': 'Thank you for the update!',
      'timestamp': DateTime.parse('2025-07-01T10:30:00Z'),
      'isFromAdmin': false,
    },
    {
      'id': 'msg3',
      'conversationId': 'conv2',
      'senderId': 'u2',
      'senderName': 'Ravi',
      'text': 'When will the streetlight be fixed?',
      'timestamp': DateTime.parse('2025-07-02T11:00:00Z'),
      'isFromAdmin': false,
    },
    {
      'id': 'msg4',
      'conversationId': 'conv3',
      'senderId': 'admin1',
      'senderName': 'Admin',
      'text': 'The drainage work has started',
      'timestamp': DateTime.parse('2025-07-03T08:00:00Z'),
      'isFromAdmin': true,
    },
  ];
  
  // Mock Map Markers
  static final List<Map<String, dynamic>> mockMapMarkers = [
    {
      'id': 'marker1',
      'postId': 'p1',
      'latitude': 12.935,
      'longitude': 77.623,
      'title': 'Deep pothole near gate',
      'category': 'Potholes',
      'severity': 'High',
      'status': 'Reported',
      'upvotes': 42,
    },
    {
      'id': 'marker2',
      'postId': 'p2',
      'latitude': 12.92,
      'longitude': 77.58,
      'title': 'Streetlight not working',
      'category': 'Streetlights not working',
      'severity': 'Medium',
      'status': 'Under Review',
      'upvotes': 15,
    },
    {
      'id': 'marker3',
      'postId': 'p3',
      'latitude': 13.01,
      'longitude': 77.57,
      'title': 'Drain blocked after rain',
      'category': 'Waterlogging / Drainage blockages',
      'severity': 'High',
      'status': 'Assigned',
      'upvotes': 33,
    },
    {
      'id': 'marker4',
      'postId': 'p4',
      'latitude': 12.936,
      'longitude': 77.62,
      'title': 'Missing road sign',
      'category': 'Broken / Missing Road Signs',
      'severity': 'Low',
      'status': 'Reported',
      'upvotes': 5,
    },
    {
      'id': 'marker5',
      'postId': 'p5',
      'latitude': 12.91,
      'longitude': 77.64,
      'title': 'Illegal dumping near lane',
      'category': 'Trash / Illegal dumping',
      'severity': 'Medium',
      'status': 'In Progress',
      'upvotes': 20,
    },
    {
      'id': 'marker6',
      'postId': 'p6',
      'latitude': 12.97,
      'longitude': 77.64,
      'title': 'Broken footpath slab',
      'category': 'Sidewalk / Footpath damage',
      'severity': 'Medium',
      'status': 'Reported',
      'upvotes': 8,
    },
    {
      'id': 'marker7',
      'postId': 'p7',
      'latitude': 12.95,
      'longitude': 77.57,
      'title': 'Open manhole cover missing',
      'category': 'Unsafe manhole / Missing covers',
      'severity': 'High',
      'status': 'Assigned',
      'upvotes': 55,
    },
    {
      'id': 'marker8',
      'postId': 'p8',
      'latitude': 12.9355,
      'longitude': 77.6225,
      'title': 'Fallen tree blocking road',
      'category': 'Fallen trees / Vegetation blocking road',
      'severity': 'Medium',
      'status': 'Resolved',
      'upvotes': 13,
    },
  ];
  
  // Test credentials for login
  static const Map<String, String> testCredentials = {
    'user': 'user@example.com',
    'admin': 'admin@civicreporter.com',
    'password': 'password123',
  };
  
  /// Get a user by ID
  static User? getUserById(String id) {
    try {
      return mockUsers.firstWhere((user) => user.id == id);
    } catch (e) {
      return null;
    }
  }
  
  /// Get a post by ID
  static Post? getPostById(String id) {
    try {
      return mockPosts.firstWhere((post) => post.id == id);
    } catch (e) {
      return null;
    }
  }
  
  /// Get posts by user ID
  static List<Post> getPostsByUserId(String userId) {
    return mockPosts.where((post) => post.userId == userId).toList();
  }
  
  /// Get posts by area
  static List<Post> getPostsByArea(String area) {
    return mockPosts.where((post) => post.area == area).toList();
  }
  
  /// Get posts by category
  static List<Post> getPostsByCategory(String category) {
    return mockPosts.where((post) => post.category == category).toList();
  }
  
  /// Get posts by status
  static List<Post> getPostsByStatus(String status) {
    return mockPosts.where((post) => post.status == status).toList();
  }
  
  /// Get posts by severity
  static List<Post> getPostsBySeverity(String severity) {
    return mockPosts.where((post) => post.severity == severity).toList();
  }
  
  /// Get conversations for a user
  static List<Map<String, dynamic>> getConversationsForUser(String userId) {
    return mockConversations.where((conv) => conv['userId'] == userId).toList();
  }
  
  /// Get messages for a conversation
  static List<Map<String, dynamic>> getMessagesForConversation(String conversationId) {
    return mockMessages.where((msg) => msg['conversationId'] == conversationId).toList();
  }
  
  /// Get map markers
  static List<Map<String, dynamic>> getMapMarkers() {
    return mockMapMarkers;
  }
  
  /// Get map markers by area
  static List<Map<String, dynamic>> getMapMarkersByArea(String area) {
    final areaPosts = getPostsByArea(area);
    final postIds = areaPosts.map((post) => post.id).toSet();
    return mockMapMarkers.where((marker) => postIds.contains(marker['postId'])).toList();
  }
  
  /// Get map markers by category
  static List<Map<String, dynamic>> getMapMarkersByCategory(String category) {
    final categoryPosts = getPostsByCategory(category);
    final postIds = categoryPosts.map((post) => post.id).toSet();
    return mockMapMarkers.where((marker) => postIds.contains(marker['postId'])).toList();
  }
  
  // Mock Notifications
  static final List<NotificationModel> mockNotifications = [
    NotificationFactory.createLikeNotification(
      id: 'n1',
      userId: 'u1',
      postId: 'p1',
      postTitle: 'Broken Street Light',
      fromUserId: 'u2',
      fromUsername: 'Ravi',
      fromUserAvatar: 'https://via.placeholder.com/40',
    ),
    NotificationFactory.createUpvoteNotification(
      id: 'n2',
      userId: 'u1',
      postId: 'p1',
      postTitle: 'Broken Street Light',
      fromUserId: 'u3',
      fromUsername: 'Priya',
      fromUserAvatar: 'https://via.placeholder.com/40',
    ),
    NotificationFactory.createCommentNotification(
      id: 'n3',
      userId: 'u1',
      postId: 'p1',
      postTitle: 'Broken Street Light',
      fromUserId: 'u4',
      fromUsername: 'Kumar',
      fromUserAvatar: 'https://via.placeholder.com/40',
      commentText: 'I\'ve seen this issue too. It\'s been there for weeks!',
    ),
    NotificationFactory.createStatusUpdateNotification(
      id: 'n4',
      userId: 'u1',
      postId: 'p1',
      postTitle: 'Broken Street Light',
      newStatus: 'Under Review',
    ),
    NotificationFactory.createBbmpMessageNotification(
      id: 'n5',
      userId: 'u1',
      message: 'We have received your report and are currently reviewing it. We will update you soon.',
      fromAdminName: 'BBMP Admin',
    ),
    NotificationFactory.createLikeNotification(
      id: 'n6',
      userId: 'u1',
      postId: 'p2',
      postTitle: 'Pothole on Main Road',
      fromUserId: 'u5',
      fromUsername: 'Meera',
      fromUserAvatar: 'https://via.placeholder.com/40',
    ),
    NotificationFactory.createUpvoteNotification(
      id: 'n7',
      userId: 'u1',
      postId: 'p2',
      postTitle: 'Pothole on Main Road',
      fromUserId: 'u2',
      fromUsername: 'Ravi',
      fromUserAvatar: 'https://via.placeholder.com/40',
    ),
    NotificationFactory.createStatusUpdateNotification(
      id: 'n8',
      userId: 'u1',
      postId: 'p2',
      postTitle: 'Pothole on Main Road',
      newStatus: 'In Progress',
    ),
    NotificationFactory.createCommunityMessageNotification(
      id: 'n9',
      userId: 'u1',
      message: 'Hey! I live in the same area. Let\'s work together to get this fixed.',
      fromUserId: 'u3',
      fromUsername: 'Priya',
      fromUserAvatar: 'https://via.placeholder.com/40',
    ),
    NotificationFactory.createLikeNotification(
      id: 'n10',
      userId: 'u1',
      postId: 'p3',
      postTitle: 'Garbage Collection Issue',
      fromUserId: 'u4',
      fromUsername: 'Kumar',
      fromUserAvatar: 'https://via.placeholder.com/40',
    ),
  ];
  
  /// Get notifications for a specific user
  static List<NotificationModel> getNotificationsForUser(String userId) {
    return mockNotifications.where((notification) => notification.userId == userId).toList();
  }
  
  /// Get unread notifications for a specific user
  static List<NotificationModel> getUnreadNotificationsForUser(String userId) {
    return mockNotifications
        .where((notification) => notification.userId == userId && !notification.isRead)
        .toList();
  }
  
  /// Get notifications by type for a specific user
  static List<NotificationModel> getNotificationsByTypeForUser(String userId, String type) {
    return mockNotifications
        .where((notification) => notification.userId == userId && notification.type == type)
        .toList();
  }
}
