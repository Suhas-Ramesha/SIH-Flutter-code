import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/post.dart';
import '../services/api_service.dart';
import '../core/mock_data.dart';
import 'auth_provider.dart';

/// Posts state
class PostsState {
  final List<Post> posts;
  final bool isLoading;
  final bool isLoadingMore;
  final String? error;
  final bool hasMore;
  final int currentPage;
  final PostFilters currentFilters;
  
  const PostsState({
    this.posts = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
    this.hasMore = true,
    this.currentPage = 1,
    this.currentFilters = const PostFilters(),
  });
  
  PostsState copyWith({
    List<Post>? posts,
    bool? isLoading,
    bool? isLoadingMore,
    String? error,
    bool? hasMore,
    int? currentPage,
    PostFilters? currentFilters,
  }) {
    return PostsState(
      posts: posts ?? this.posts,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      currentFilters: currentFilters ?? this.currentFilters,
    );
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PostsState &&
        other.posts == posts &&
        other.isLoading == isLoading &&
        other.isLoadingMore == isLoadingMore &&
        other.error == error &&
        other.hasMore == hasMore &&
        other.currentPage == currentPage &&
        other.currentFilters == currentFilters;
  }
  
  @override
  int get hashCode {
    return Object.hash(posts, isLoading, isLoadingMore, error, hasMore, currentPage, currentFilters);
  }
}

/// Posts notifier
class PostsNotifier extends StateNotifier<PostsState> {
  final ApiService _apiService;
  
  PostsNotifier(this._apiService) : super(const PostsState());
  
  /// Fetch posts with filters
  Future<void> fetchPosts({PostFilters? filters, bool refresh = false}) async {
    final newFilters = filters ?? state.currentFilters;
    
    if (refresh) {
      state = state.copyWith(
        isLoading: true,
        error: null,
        currentPage: 1,
        posts: [],
        hasMore: true,
      );
    } else {
      state = state.copyWith(isLoading: true, error: null);
    }
    
    try {
      final fetchedPosts = await _apiService.fetchPosts(newFilters);
      
      state = state.copyWith(
        posts: refresh ? fetchedPosts : [...state.posts, ...fetchedPosts],
        isLoading: false,
        currentFilters: newFilters,
        currentPage: newFilters.page,
        hasMore: fetchedPosts.length >= newFilters.limit,
        error: null,
      );
      
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
  
  /// Load more posts (pagination)
  Future<void> loadMorePosts() async {
    if (state.isLoadingMore || !state.hasMore) return;
    
    state = state.copyWith(isLoadingMore: true, error: null);
    
    try {
      final nextPage = state.currentPage + 1;
      final nextFilters = state.currentFilters.copyWith(page: nextPage);
      
      final fetchedPosts = await _apiService.fetchPosts(nextFilters);
      
      state = state.copyWith(
        posts: [...state.posts, ...fetchedPosts],
        isLoadingMore: false,
        currentPage: nextPage,
        hasMore: fetchedPosts.length >= nextFilters.limit,
        error: null,
      );
      
    } catch (e) {
      state = state.copyWith(
        isLoadingMore: false,
        error: e.toString(),
      );
    }
  }
  
  /// Refresh posts
  Future<void> refreshPosts() async {
    await fetchPosts(refresh: true);
  }
  
  /// Get a specific post by ID
  Future<Post?> getPost(String id) async {
    try {
      return await _apiService.getPost(id);
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return null;
    }
  }
  
  /// Create a new post
  Future<Post?> createPost(CreatePostRequest request) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final newPost = await _apiService.createPost(request);
      
      // Add new post to the beginning of the list
      state = state.copyWith(
        posts: [newPost, ...state.posts],
        isLoading: false,
        error: null,
      );
      
      return newPost;
      
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return null;
    }
  }
  
  /// Update a post
  Future<Post?> updatePost(String id, UpdatePostRequest request) async {
    try {
      final updatedPost = await _apiService.updatePost(id, request);
      
      // Update post in the list
      final updatedPosts = state.posts.map((post) {
        return post.id == id ? updatedPost : post;
      }).toList();
      
      state = state.copyWith(posts: updatedPosts);
      
      return updatedPost;
      
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return null;
    }
  }
  
  /// Delete a post
  Future<void> deletePost(String id) async {
    try {
      await _apiService.deletePost(id);
      
      // Remove post from the list
      final updatedPosts = state.posts.where((post) => post.id != id).toList();
      
      state = state.copyWith(posts: updatedPosts);
      
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
  
  /// Upvote a post
  Future<void> upvotePost(String postId) async {
    try {
      await _apiService.upvotePost(postId);
      
      // Update post in the list
      final updatedPosts = state.posts.map((post) {
        if (post.id == postId) {
          return post.copyWith(upvotes: post.upvotes + 1);
        }
        return post;
      }).toList();
      
      state = state.copyWith(posts: updatedPosts);
      
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
  
  /// Downvote a post
  Future<void> downvotePost(String postId) async {
    try {
      await _apiService.downvotePost(postId);
      
      // Update post in the list
      final updatedPosts = state.posts.map((post) {
        if (post.id == postId) {
          return post.copyWith(downvotes: post.downvotes + 1);
        }
        return post;
      }).toList();
      
      state = state.copyWith(posts: updatedPosts);
      
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
  
  /// Remove vote from a post
  Future<void> removeVote(String postId) async {
    try {
      await _apiService.removeVote(postId);
      
      // Update post in the list (mock implementation)
      final updatedPosts = state.posts.map((post) {
        if (post.id == postId) {
          // Mock: remove one upvote
          return post.copyWith(upvotes: post.upvotes > 0 ? post.upvotes - 1 : 0);
        }
        return post;
      }).toList();
      
      state = state.copyWith(posts: updatedPosts);
      
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
  
  /// Add a comment to a post
  Future<Comment?> addComment(String postId, String text, {String? parentCommentId}) async {
    try {
      final comment = await _apiService.addComment(postId, text, parentCommentId: parentCommentId);
      
      // Update post in the list
      final updatedPosts = state.posts.map((post) {
        if (post.id == postId) {
          return post.copyWith(comments: [...post.comments, comment]);
        }
        return post;
      }).toList();
      
      state = state.copyWith(posts: updatedPosts);
      
      return comment;
      
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return null;
    }
  }
  
  /// Get comments for a post
  Future<List<Comment>> getPostComments(String postId) async {
    try {
      return await _apiService.getPostComments(postId);
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return [];
    }
  }
  
  /// Filter posts by area
  Future<void> filterByArea(String? area) async {
    final newFilters = state.currentFilters.copyWith(area: area, page: 1);
    await fetchPosts(filters: newFilters, refresh: true);
  }
  
  /// Filter posts by category
  Future<void> filterByCategory(String? category) async {
    final newFilters = state.currentFilters.copyWith(category: category, page: 1);
    await fetchPosts(filters: newFilters, refresh: true);
  }
  
  /// Filter posts by status
  Future<void> filterByStatus(String? status) async {
    final newFilters = state.currentFilters.copyWith(status: status, page: 1);
    await fetchPosts(filters: newFilters, refresh: true);
  }
  
  /// Filter posts by severity
  Future<void> filterBySeverity(String? severity) async {
    final newFilters = state.currentFilters.copyWith(severity: severity, page: 1);
    await fetchPosts(filters: newFilters, refresh: true);
  }
  
  /// Sort posts
  Future<void> sortPosts(String sortBy) async {
    final newFilters = state.currentFilters.copyWith(sortBy: sortBy, page: 1);
    await fetchPosts(filters: newFilters, refresh: true);
  }
  
  /// Clear filters
  Future<void> clearFilters() async {
    const newFilters = PostFilters();
    await fetchPosts(filters: newFilters, refresh: true);
  }
  
  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }
  
  /// Get posts by user ID
  Future<List<Post>> getUserPosts(String userId, {int page = 1, int limit = 20}) async {
    try {
      return await _apiService.fetchUserPosts(userId, page: page, limit: limit);
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return [];
    }
  }
}

/// User posts state
class UserPostsState {
  final List<Post> posts;
  final bool isLoading;
  final String? error;
  final bool hasMore;
  final int currentPage;
  
  const UserPostsState({
    this.posts = const [],
    this.isLoading = false,
    this.error,
    this.hasMore = true,
    this.currentPage = 1,
  });
  
  UserPostsState copyWith({
    List<Post>? posts,
    bool? isLoading,
    String? error,
    bool? hasMore,
    int? currentPage,
  }) {
    return UserPostsState(
      posts: posts ?? this.posts,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

/// User posts notifier
class UserPostsNotifier extends StateNotifier<UserPostsState> {
  final ApiService _apiService;
  final String userId;
  
  UserPostsNotifier(this._apiService, this.userId) : super(const UserPostsState());
  
  /// Fetch user posts
  Future<void> fetchUserPosts({bool refresh = false}) async {
    print('UserPostsNotifier: fetchUserPosts called for userId: $userId, refresh: $refresh');
    
    if (refresh) {
      state = state.copyWith(
        isLoading: true,
        error: null,
        currentPage: 1,
        posts: [],
        hasMore: true,
      );
    } else {
      state = state.copyWith(isLoading: true, error: null);
    }
    
    try {
      final fetchedPosts = await _apiService.fetchUserPosts(
        userId,
        page: state.currentPage,
        limit: 20,
      );
      
      print('UserPostsNotifier: Fetched ${fetchedPosts.length} posts for userId: $userId');
      for (final post in fetchedPosts) {
        print('UserPostsNotifier: Post ${post.id} - ${post.title}');
      }
      
      state = state.copyWith(
        posts: refresh ? fetchedPosts : [...state.posts, ...fetchedPosts],
        isLoading: false,
        hasMore: fetchedPosts.length >= 20,
        error: null,
      );
      
    } catch (e) {
      print('UserPostsNotifier: Error fetching posts: $e');
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
  
  /// Load more user posts
  Future<void> loadMoreUserPosts() async {
    if (state.isLoading || !state.hasMore) return;
    
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final nextPage = state.currentPage + 1;
      final fetchedPosts = await _apiService.fetchUserPosts(
        userId,
        page: nextPage,
        limit: 20,
      );
      
      state = state.copyWith(
        posts: [...state.posts, ...fetchedPosts],
        isLoading: false,
        currentPage: nextPage,
        hasMore: fetchedPosts.length >= 20,
        error: null,
      );
      
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
  
  /// Refresh user posts
  Future<void> refreshUserPosts() async {
    await fetchUserPosts(refresh: true);
  }
}

/// Posts provider
final postsProvider = StateNotifierProvider<PostsNotifier, PostsState>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return PostsNotifier(apiService);
});

/// User posts provider
final userPostsProvider = StateNotifierProvider.family<UserPostsNotifier, UserPostsState, String>((ref, userId) {
  final apiService = ref.watch(apiServiceProvider);
  return UserPostsNotifier(apiService, userId);
});

/// Posts loading state provider
final postsLoadingProvider = Provider<bool>((ref) {
  final postsState = ref.watch(postsProvider);
  return postsState.isLoading;
});

/// Posts error provider
final postsErrorProvider = Provider<String?>((ref) {
  final postsState = ref.watch(postsProvider);
  return postsState.error;
});

/// Posts list provider
final postsListProvider = Provider<List<Post>>((ref) {
  final postsState = ref.watch(postsProvider);
  return postsState.posts;
});

/// Has more posts provider
final hasMorePostsProvider = Provider<bool>((ref) {
  final postsState = ref.watch(postsProvider);
  return postsState.hasMore;
});

/// Current filters provider
final currentFiltersProvider = Provider<PostFilters>((ref) {
  final postsState = ref.watch(postsProvider);
  return postsState.currentFilters;
});
