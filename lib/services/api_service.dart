import 'dart:io';
import 'package:dio/dio.dart';
import '../models/user.dart';
import '../models/post.dart';
import '../core/env.dart';

/// Abstract API service interface
/// 
/// This interface defines all the methods required for the Civic Reporter app.
/// Implementations should handle authentication, error handling, and data transformation.
abstract class ApiService {
  // Authentication
  Future<AuthResponse> login(LoginRequest request);
  Future<AuthResponse> refreshToken(String refreshToken);
  Future<void> logout();
  
  // Posts
  Future<List<Post>> fetchPosts(PostFilters filters);
  Future<Post> getPost(String id);
  Future<Post> createPost(CreatePostRequest request);
  Future<Post> updatePost(String id, UpdatePostRequest request);
  Future<Post> updatePostStatus(String id, Map<String, dynamic> payload);
  Future<void> deletePost(String id);
  
  // Voting
  Future<void> upvotePost(String postId);
  Future<void> downvotePost(String postId);
  Future<void> removeVote(String postId);
  
  // Comments
  Future<List<Comment>> getPostComments(String postId);
  Future<Comment> addComment(String postId, String text, {String? parentCommentId});
  Future<void> deleteComment(String commentId);
  
  // User Posts
  Future<List<Post>> fetchUserPosts(String userId, {int page = 1, int limit = 20});
  
  // Map Markers
  Future<List<Map<String, dynamic>>> fetchMapMarkers(PostFilters filters);
  
  // File Upload
  Future<String> uploadImage(File image);
  Future<List<String>> uploadImages(List<File> images);
  
  // Conversations
  Future<List<Map<String, dynamic>>> fetchConversations();
  Future<List<Map<String, dynamic>>> getConversationMessages(String conversationId);
  Future<void> sendMessage(String conversationId, Map<String, dynamic> payload);
  
  // User Profile
  Future<User> getCurrentUser();
  Future<User> updateUserProfile(Map<String, dynamic> updates);
  Future<void> changePassword(String currentPassword, String newPassword);
  
  // WebSocket Events
  Stream<Map<String, dynamic>> subscribeToWsEvents();
}

/// Mock API service implementation for development
class MockApiService implements ApiService {
  @override
  Future<AuthResponse> login(LoginRequest request) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1000));
    
    // Mock authentication logic
    if (request.email == 'admin@civicreporter.com' && request.password == 'password123') {
      return AuthResponse(
        token: 'mock_admin_token_${DateTime.now().millisecondsSinceEpoch}',
        refreshToken: 'mock_admin_refresh_token_${DateTime.now().millisecondsSinceEpoch}',
        user: User(
          id: 'admin1',
          email: 'admin@civicreporter.com',
          username: 'Admin',
          role: 'admin',
          area: 'Bangalore',
          reputation: 500,
          createdAt: DateTime(2024, 1, 1),
        ),
        expiresAt: DateTime.now().add(const Duration(hours: 24)),
      );
    } else if (request.email == 'user@example.com' && request.password == 'password123') {
      return AuthResponse(
        token: 'mock_user_token_${DateTime.now().millisecondsSinceEpoch}',
        refreshToken: 'mock_user_refresh_token_${DateTime.now().millisecondsSinceEpoch}',
        user: User(
          id: 'u1',
          email: 'user@example.com',
          username: 'Test User',
          role: 'user',
          area: 'Koramangala 4th Block',
          reputation: 150,
          createdAt: DateTime(2024, 1, 15),
        ),
        expiresAt: DateTime.now().add(const Duration(hours: 24)),
      );
    } else {
      throw Exception('Invalid credentials');
    }
  }
  
  @override
  Future<AuthResponse> refreshToken(String refreshToken) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Mock token refresh
    return AuthResponse(
      token: 'mock_refreshed_token_${DateTime.now().millisecondsSinceEpoch}',
      refreshToken: 'mock_new_refresh_token_${DateTime.now().millisecondsSinceEpoch}',
      user: User(
        id: 'u1',
        email: 'user@example.com',
        username: 'Test User',
        role: 'user',
        area: 'Koramangala 4th Block',
        reputation: 150,
        createdAt: DateTime(2024, 1, 15),
      ),
      expiresAt: DateTime.now().add(const Duration(hours: 24)),
    );
  }
  
  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
    // Mock logout - just clear local storage
  }
  
  @override
  Future<List<Post>> fetchPosts(PostFilters filters) async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Import mock data
    final mockPosts = await _getMockPosts();
    
    // Apply filters
    List<Post> filteredPosts = mockPosts;
    
    if (filters.area != null) {
      filteredPosts = filteredPosts.where((post) => post.area == filters.area).toList();
    }
    
    if (filters.category != null) {
      filteredPosts = filteredPosts.where((post) => post.category == filters.category).toList();
    }
    
    if (filters.status != null) {
      filteredPosts = filteredPosts.where((post) => post.status == filters.status).toList();
    }
    
    if (filters.severity != null) {
      filteredPosts = filteredPosts.where((post) => post.severity == filters.severity).toList();
    }
    
    // Apply sorting
    switch (filters.sortBy) {
      case 'newest':
        filteredPosts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case 'oldest':
        filteredPosts.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case 'most_voted':
        filteredPosts.sort((a, b) => b.netVotes.compareTo(a.netVotes));
        break;
      case 'near_me':
        // Mock proximity sort
        filteredPosts.sort((a, b) => b.upvotes.compareTo(a.upvotes));
        break;
      default:
        filteredPosts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }
    
    // Apply pagination
    final startIndex = (filters.page - 1) * filters.limit;
    final endIndex = startIndex + filters.limit;
    
    if (startIndex >= filteredPosts.length) {
      return [];
    }
    
    return filteredPosts.sublist(
      startIndex,
      endIndex > filteredPosts.length ? filteredPosts.length : endIndex,
    );
  }
  
  @override
  Future<Post> getPost(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    final mockPosts = await _getMockPosts();
    final post = mockPosts.firstWhere((post) => post.id == id);
    
    if (post == null) {
      throw Exception('Post not found');
    }
    
    return post;
  }
  
  @override
  Future<Post> createPost(CreatePostRequest request) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    
    // Create new post
    final newPost = Post(
      id: 'p${DateTime.now().millisecondsSinceEpoch}',
      userId: 'u1', // Mock current user
      username: 'Test User',
      area: request.area,
      category: request.category,
      title: request.title,
      description: request.description,
      images: request.images,
      latitude: request.latitude,
      longitude: request.longitude,
      upvotes: 0,
      downvotes: 0,
      status: 'Reported',
      severity: request.severity,
      createdAt: DateTime.now(),
      comments: [],
      bbmpNotes: [],
    );
    
    return newPost;
  }
  
  @override
  Future<Post> updatePost(String id, UpdatePostRequest request) async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    final mockPosts = await _getMockPosts();
    final postIndex = mockPosts.indexWhere((post) => post.id == id);
    
    if (postIndex == -1) {
      throw Exception('Post not found');
    }
    
    final existingPost = mockPosts[postIndex];
    final updatedPost = existingPost.copyWith(
      status: request.status,
      updatedAt: DateTime.now(),
      bbmpNotes: request.bbmpNote != null
          ? [
              ...existingPost.bbmpNotes,
              BbmpNote(
                id: 'note_${DateTime.now().millisecondsSinceEpoch}',
                postId: id,
                adminId: 'admin1',
                adminName: 'Admin',
                text: request.bbmpNote!,
                createdAt: DateTime.now(),
                attachments: [],
              ),
            ]
          : existingPost.bbmpNotes,
    );
    
    return updatedPost;
  }
  
  @override
  Future<void> deletePost(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Mock delete - just return success
  }
  
  @override
  Future<void> upvotePost(String postId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // Mock upvote - just return success
  }
  
  @override
  Future<void> downvotePost(String postId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // Mock downvote - just return success
  }
  
  @override
  Future<void> removeVote(String postId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // Mock remove vote - just return success
  }
  
  @override
  Future<List<Comment>> getPostComments(String postId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Mock comments
    return [
      Comment(
        id: 'c1',
        postId: postId,
        userId: 'u2',
        username: 'Ravi',
        text: 'This is a serious issue. Hope it gets resolved soon.',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        replies: [],
      ),
      Comment(
        id: 'c2',
        postId: postId,
        userId: 'admin1',
        username: 'Admin',
        text: 'Thank you for reporting. We are looking into this.',
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        replies: [],
        isFromAdmin: true,
      ),
    ];
  }
  
  @override
  Future<Comment> addComment(String postId, String text, {String? parentCommentId}) async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    return Comment(
      id: 'c${DateTime.now().millisecondsSinceEpoch}',
      postId: postId,
      userId: 'u1',
      username: 'Test User',
      text: text,
      createdAt: DateTime.now(),
      parentCommentId: parentCommentId,
      replies: [],
    );
  }
  
  @override
  Future<void> deleteComment(String commentId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // Mock delete comment
  }
  
  @override
  Future<List<Post>> fetchUserPosts(String userId, {int page = 1, int limit = 20}) async {
    await Future.delayed(const Duration(milliseconds: 600));
    
    final mockPosts = await _getMockPosts();
    final userPosts = mockPosts.where((post) => post.userId == userId).toList();
    
    // Apply pagination
    final startIndex = (page - 1) * limit;
    final endIndex = startIndex + limit;
    
    if (startIndex >= userPosts.length) {
      return [];
    }
    
    return userPosts.sublist(
      startIndex,
      endIndex > userPosts.length ? userPosts.length : endIndex,
    );
  }
  
  @override
  Future<List<Map<String, dynamic>>> fetchMapMarkers(PostFilters filters) async {
    await Future.delayed(const Duration(milliseconds: 400));
    
    // Import mock markers
    final mockMarkers = await _getMockMarkers();
    
    // Apply filters
    List<Map<String, dynamic>> filteredMarkers = mockMarkers;
    
    if (filters.area != null) {
      filteredMarkers = filteredMarkers.where((marker) {
        // Mock area filtering
        return true; // Simplified for mock
      }).toList();
    }
    
    if (filters.category != null) {
      filteredMarkers = filteredMarkers.where((marker) {
        return marker['category'] == filters.category;
      }).toList();
    }
    
    return filteredMarkers;
  }
  
  @override
  Future<String> uploadImage(File image) async {
    await Future.delayed(const Duration(milliseconds: 2000));
    
    // Mock image upload - return mock URL
    return 'https://storage.civicreporter.com/mock/${DateTime.now().millisecondsSinceEpoch}.jpg';
  }
  
  @override
  Future<List<String>> uploadImages(List<File> images) async {
    await Future.delayed(const Duration(milliseconds: 3000));
    
    // Mock multiple image uploads
    final urls = <String>[];
    for (int i = 0; i < images.length; i++) {
      urls.add('https://storage.civicreporter.com/mock/${DateTime.now().millisecondsSinceEpoch}_$i.jpg');
    }
    
    return urls;
  }
  
  @override
  Future<List<Map<String, dynamic>>> fetchConversations() async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Import mock conversations
    return await _getMockConversations();
  }
  
  @override
  Future<List<Map<String, dynamic>>> getConversationMessages(String conversationId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    
    // Import mock messages
    final mockMessages = await _getMockMessages();
    return mockMessages.where((msg) => msg['conversationId'] == conversationId).toList();
  }
  
  @override
  Future<void> sendMessage(String conversationId, Map<String, dynamic> payload) async {
    await Future.delayed(const Duration(milliseconds: 600));
    // Mock send message
  }
  
  @override
  Future<User> getCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    return User(
      id: 'u1',
      email: 'user@example.com',
      username: 'Test User',
      role: 'user',
      area: 'Koramangala 4th Block',
      reputation: 150,
      createdAt: DateTime(2024, 1, 15),
    );
  }
  
  @override
  Future<User> updateUserProfile(Map<String, dynamic> updates) async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Mock profile update
    return User(
      id: 'u1',
      email: 'user@example.com',
      username: 'Updated User',
      role: 'user',
      area: 'Koramangala 4th Block',
      reputation: 150,
      createdAt: DateTime(2024, 1, 15),
    );
  }
  
  @override
  Future<void> changePassword(String currentPassword, String newPassword) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    // Mock password change
  }
  
  @override
  Future<Post> updatePostStatus(String id, Map<String, dynamic> payload) async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    final mockPosts = await _getMockPosts();
    final postIndex = mockPosts.indexWhere((post) => post.id == id);
    
    if (postIndex == -1) {
      throw Exception('Post not found');
    }
    
    final existingPost = mockPosts[postIndex];
    final updatedPost = existingPost.copyWith(
      status: payload['status'],
      updatedAt: DateTime.now(),
      bbmpNotes: payload['bbmpNote'] != null
          ? [
              ...existingPost.bbmpNotes,
              BbmpNote(
                id: 'note_${DateTime.now().millisecondsSinceEpoch}',
                postId: id,
                adminId: 'admin1',
                adminName: 'Admin',
                text: payload['bbmpNote'],
                createdAt: DateTime.now(),
                attachments: [],
              ),
            ]
          : existingPost.bbmpNotes,
    );
    
    return updatedPost;
  }
  
  @override
  Stream<Map<String, dynamic>> subscribeToWsEvents() async* {
    // Mock WebSocket events
    while (true) {
      await Future.delayed(const Duration(seconds: 30));
      
      final events = [
        {
          'type': 'post_created',
          'data': {
            'postId': 'p${DateTime.now().millisecondsSinceEpoch}',
            'title': 'New report: Streetlight not working',
            'category': 'Streetlights not working',
            'area': 'Koramangala',
            'severity': 'Medium',
            'username': 'New User',
            'createdAt': DateTime.now().toIso8601String(),
          },
        },
        {
          'type': 'post_updated',
          'data': {
            'postId': 'p1',
            'status': 'Under Review',
            'updatedAt': DateTime.now().toIso8601String(),
          },
        },
        {
          'type': 'status_changed',
          'data': {
            'postId': 'p1',
            'oldStatus': 'Reported',
            'newStatus': 'Under Review',
            'adminName': 'Admin',
            'note': 'Report is being reviewed by our team',
            'updatedAt': DateTime.now().toIso8601String(),
          },
        },
        {
          'type': 'new_message',
          'data': {
            'conversationId': 'conv1',
            'messageId': 'msg${DateTime.now().millisecondsSinceEpoch}',
            'senderId': 'admin1',
            'senderName': 'Admin',
            'text': 'Thank you for your report. We are working on it.',
            'isFromAdmin': true,
            'timestamp': DateTime.now().toIso8601String(),
          },
        },
        {
          'type': 'user_typing',
          'data': {
            'conversationId': 'conv1',
            'userId': 'u1',
            'username': 'Test User',
            'isTyping': true,
          },
        },
      ];
      
      yield events[DateTime.now().millisecondsSinceEpoch % events.length];
    }
  }
  
  // Helper methods to get mock data
  Future<List<Post>> _getMockPosts() async {
    // Import mock data
    final mockData = await _importMockData();
    return mockData['posts'] as List<Post>;
  }
  
  Future<List<Map<String, dynamic>>> _getMockMarkers() async {
    final mockData = await _importMockData();
    return mockData['markers'] as List<Map<String, dynamic>>;
  }
  
  Future<List<Map<String, dynamic>>> _getMockConversations() async {
    final mockData = await _importMockData();
    return mockData['conversations'] as List<Map<String, dynamic>>;
  }
  
  Future<List<Map<String, dynamic>>> _getMockMessages() async {
    final mockData = await _importMockData();
    return mockData['messages'] as List<Map<String, dynamic>>;
  }
  
  Future<Map<String, dynamic>> _importMockData() async {
    // This would normally import from mock_data.dart
    // For now, return empty data
    return {
      'posts': <Post>[],
      'markers': <Map<String, dynamic>>[],
      'conversations': <Map<String, dynamic>>[],
      'messages': <Map<String, dynamic>>[],
    };
  }
}

/// HTTP API service implementation for production
/// 
/// TODO: Implement all methods when connecting to real backend
class HttpApiService implements ApiService {
  final Dio _dio;
  String? _authToken;
  
  HttpApiService({required Dio dio}) : _dio = dio {
    _setupInterceptors();
  }
  
  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Add auth token to requests
          if (_authToken != null) {
            options.headers['Authorization'] = 'Bearer $_authToken';
          }
          handler.next(options);
        },
        onError: (error, handler) {
          // Handle auth errors
          if (error.response?.statusCode == 401) {
            // TODO: Handle token refresh or redirect to login
            _authToken = null;
          }
          handler.next(error);
        },
      ),
    );
  }
  
  void setAuthToken(String token) {
    _authToken = token;
  }
  
  @override
  Future<AuthResponse> login(LoginRequest request) async {
    try {
      final response = await _dio.post(
        '${Env.effectiveApiBaseUrl}/auth/login',
        data: request.toJson(),
      );
      
      return AuthResponse.fromJson(response.data);
    } catch (e) {
      // TODO: Handle specific error types
      throw Exception('Login failed: ${e.toString()}');
    }
  }
  
  @override
  Future<AuthResponse> refreshToken(String refreshToken) async {
    try {
      final response = await _dio.post(
        '${Env.effectiveApiBaseUrl}/auth/refresh',
        data: {'refreshToken': refreshToken},
      );
      
      return AuthResponse.fromJson(response.data);
    } catch (e) {
      // TODO: Handle refresh token errors
      throw Exception('Token refresh failed: ${e.toString()}');
    }
  }
  
  @override
  Future<void> logout() async {
    try {
      await _dio.post('${Env.effectiveApiBaseUrl}/auth/logout');
      _authToken = null;
    } catch (e) {
      // TODO: Handle logout errors
      _authToken = null; // Clear token even if request fails
    }
  }
  
  @override
  Future<List<Post>> fetchPosts(PostFilters filters) async {
    try {
      final response = await _dio.get(
        '${Env.effectiveApiBaseUrl}/posts',
        queryParameters: filters.toQueryParams(),
      );
      
      final posts = (response.data['posts'] as List)
          .map((json) => Post.fromJson(json as Map<String, dynamic>))
          .toList();
      
      return posts;
    } catch (e) {
      // TODO: Handle specific error types
      throw Exception('Failed to fetch posts: ${e.toString()}');
    }
  }
  
  @override
  Future<Post> getPost(String id) async {
    try {
      final response = await _dio.get('${Env.effectiveApiBaseUrl}/posts/$id');
      return Post.fromJson(response.data);
    } catch (e) {
      // TODO: Handle specific error types
      throw Exception('Failed to fetch post: ${e.toString()}');
    }
  }
  
  @override
  Future<Post> createPost(CreatePostRequest request) async {
    try {
      // TODO: Implement multipart form data for image uploads
      final response = await _dio.post(
        '${Env.effectiveApiBaseUrl}/posts',
        data: request.toJson(),
      );
      
      return Post.fromJson(response.data);
    } catch (e) {
      // TODO: Handle specific error types
      throw Exception('Failed to create post: ${e.toString()}');
    }
  }
  
  @override
  Future<Post> updatePost(String id, UpdatePostRequest request) async {
    try {
      final response = await _dio.patch(
        '${Env.effectiveApiBaseUrl}/posts/$id',
        data: request.toJson(),
      );
      
      return Post.fromJson(response.data);
    } catch (e) {
      // TODO: Handle specific error types
      throw Exception('Failed to update post: ${e.toString()}');
    }
  }
  
  @override
  Future<void> deletePost(String id) async {
    try {
      await _dio.delete('${Env.effectiveApiBaseUrl}/posts/$id');
    } catch (e) {
      // TODO: Handle specific error types
      throw Exception('Failed to delete post: ${e.toString()}');
    }
  }
  
  @override
  Future<void> upvotePost(String postId) async {
    try {
      await _dio.post('${Env.effectiveApiBaseUrl}/posts/$postId/upvote');
    } catch (e) {
      // TODO: Handle specific error types
      throw Exception('Failed to upvote post: ${e.toString()}');
    }
  }
  
  @override
  Future<void> downvotePost(String postId) async {
    try {
      await _dio.post('${Env.effectiveApiBaseUrl}/posts/$postId/downvote');
    } catch (e) {
      // TODO: Handle specific error types
      throw Exception('Failed to downvote post: ${e.toString()}');
    }
  }
  
  @override
  Future<void> removeVote(String postId) async {
    try {
      await _dio.delete('${Env.effectiveApiBaseUrl}/posts/$postId/vote');
    } catch (e) {
      // TODO: Handle specific error types
      throw Exception('Failed to remove vote: ${e.toString()}');
    }
  }
  
  @override
  Future<List<Comment>> getPostComments(String postId) async {
    try {
      final response = await _dio.get('${Env.effectiveApiBaseUrl}/posts/$postId/comments');
      
      final comments = (response.data['comments'] as List)
          .map((json) => Comment.fromJson(json as Map<String, dynamic>))
          .toList();
      
      return comments;
    } catch (e) {
      // TODO: Handle specific error types
      throw Exception('Failed to fetch comments: ${e.toString()}');
    }
  }
  
  @override
  Future<Comment> addComment(String postId, String text, {String? parentCommentId}) async {
    try {
      final response = await _dio.post(
        '${Env.effectiveApiBaseUrl}/posts/$postId/comments',
        data: {
          'text': text,
          if (parentCommentId != null) 'parentCommentId': parentCommentId,
        },
      );
      
      return Comment.fromJson(response.data);
    } catch (e) {
      // TODO: Handle specific error types
      throw Exception('Failed to add comment: ${e.toString()}');
    }
  }
  
  @override
  Future<void> deleteComment(String commentId) async {
    try {
      await _dio.delete('${Env.effectiveApiBaseUrl}/comments/$commentId');
    } catch (e) {
      // TODO: Handle specific error types
      throw Exception('Failed to delete comment: ${e.toString()}');
    }
  }
  
  @override
  Future<List<Post>> fetchUserPosts(String userId, {int page = 1, int limit = 20}) async {
    try {
      final response = await _dio.get(
        '${Env.effectiveApiBaseUrl}/users/$userId/posts',
        queryParameters: {'page': page, 'limit': limit},
      );
      
      final posts = (response.data['posts'] as List)
          .map((json) => Post.fromJson(json as Map<String, dynamic>))
          .toList();
      
      return posts;
    } catch (e) {
      // TODO: Handle specific error types
      throw Exception('Failed to fetch user posts: ${e.toString()}');
    }
  }
  
  @override
  Future<List<Map<String, dynamic>>> fetchMapMarkers(PostFilters filters) async {
    try {
      final response = await _dio.get(
        '${Env.effectiveApiBaseUrl}/map/markers',
        queryParameters: filters.toQueryParams(),
      );
      
      return List<Map<String, dynamic>>.from(response.data['markers']);
    } catch (e) {
      // TODO: Handle specific error types
      throw Exception('Failed to fetch map markers: ${e.toString()}');
    }
  }
  
  @override
  Future<String> uploadImage(File image) async {
    try {
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(image.path),
      });
      
      final response = await _dio.post(
        '${Env.effectiveStorageUrl}/uploads',
        data: formData,
      );
      
      return response.data['url'] as String;
    } catch (e) {
      // TODO: Handle specific error types
      throw Exception('Failed to upload image: ${e.toString()}');
    }
  }
  
  @override
  Future<List<String>> uploadImages(List<File> images) async {
    try {
      final formData = FormData.fromMap({
        'images': await Future.wait(
          images.map((image) => MultipartFile.fromFile(image.path)),
        ),
      });
      
      final response = await _dio.post(
        '${Env.effectiveStorageUrl}/uploads/batch',
        data: formData,
      );
      
      return List<String>.from(response.data['urls']);
    } catch (e) {
      // TODO: Handle specific error types
      throw Exception('Failed to upload images: ${e.toString()}');
    }
  }
  
  @override
  Future<List<Map<String, dynamic>>> fetchConversations() async {
    try {
      final response = await _dio.get('${Env.effectiveApiBaseUrl}/conversations');
      return List<Map<String, dynamic>>.from(response.data['conversations']);
    } catch (e) {
      // TODO: Handle specific error types
      throw Exception('Failed to fetch conversations: ${e.toString()}');
    }
  }
  
  @override
  Future<List<Map<String, dynamic>>> getConversationMessages(String conversationId) async {
    try {
      final response = await _dio.get('${Env.effectiveApiBaseUrl}/conversations/$conversationId/messages');
      return List<Map<String, dynamic>>.from(response.data['messages']);
    } catch (e) {
      // TODO: Handle specific error types
      throw Exception('Failed to fetch messages: ${e.toString()}');
    }
  }
  
  @override
  Future<void> sendMessage(String conversationId, Map<String, dynamic> payload) async {
    try {
      await _dio.post(
        '${Env.effectiveApiBaseUrl}/conversations/$conversationId/messages',
        data: payload,
      );
    } catch (e) {
      // TODO: Handle specific error types
      throw Exception('Failed to send message: ${e.toString()}');
    }
  }
  
  @override
  Future<User> getCurrentUser() async {
    try {
      final response = await _dio.get('${Env.effectiveApiBaseUrl}/users/me');
      return User.fromJson(response.data);
    } catch (e) {
      // TODO: Handle specific error types
      throw Exception('Failed to fetch current user: ${e.toString()}');
    }
  }
  
  @override
  Future<User> updateUserProfile(Map<String, dynamic> updates) async {
    try {
      final response = await _dio.patch(
        '${Env.effectiveApiBaseUrl}/users/me',
        data: updates,
      );
      
      return User.fromJson(response.data);
    } catch (e) {
      // TODO: Handle specific error types
      throw Exception('Failed to update profile: ${e.toString()}');
    }
  }
  
  @override
  Future<void> changePassword(String currentPassword, String newPassword) async {
    try {
      await _dio.patch(
        '${Env.effectiveApiBaseUrl}/users/me/password',
        data: {
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        },
      );
    } catch (e) {
      // TODO: Handle specific error types
      throw Exception('Failed to change password: ${e.toString()}');
    }
  }
  
  @override
  Future<Post> updatePostStatus(String id, Map<String, dynamic> payload) async {
    try {
      final response = await _dio.patch(
        '${Env.effectiveApiBaseUrl}/posts/$id/status',
        data: payload,
      );
      
      return Post.fromJson(response.data);
    } catch (e) {
      // TODO: Handle specific error types
      throw Exception('Failed to update post status: ${e.toString()}');
    }
  }
  
  @override
  Stream<Map<String, dynamic>> subscribeToWsEvents() async* {
    // TODO: Implement real WebSocket connection
    // This should connect to the WebSocket server and yield events
    throw UnimplementedError('WebSocket events not implemented in HttpApiService');
  }
}
