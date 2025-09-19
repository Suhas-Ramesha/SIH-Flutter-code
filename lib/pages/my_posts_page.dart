import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../providers/posts_provider.dart';
import '../widgets/post_card.dart';
import '../widgets/status_timeline.dart';
import '../core/theme.dart';
import '../core/constants.dart';

class MyPostsPage extends ConsumerStatefulWidget {
  const MyPostsPage({super.key});
  
  @override
  ConsumerState<MyPostsPage> createState() => _MyPostsPageState();
}

class _MyPostsPageState extends ConsumerState<MyPostsPage> {
  final _scrollController = ScrollController();
  String _selectedFilter = 'all';
  
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    
    // Load user posts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = ref.read(authProvider);
      if (authState.user != null) {
        ref.read(userPostsProvider(authState.user!.id).notifier).fetchUserPosts(refresh: true);
      }
    });
  }
  
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  
  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // Load more posts when near bottom
      final authState = ref.read(authProvider);
      if (authState.user != null) {
        ref.read(userPostsProvider(authState.user!.id).notifier).loadMoreUserPosts();
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final userPostsState = authState.user != null 
        ? ref.watch(userPostsProvider(authState.user!.id))
        : null;
    
    if (authState.user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('My Posts')),
        body: const Center(
          child: Text('Please login to view your posts'),
        ),
      );
    }
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Posts'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) => setState(() => _selectedFilter = value),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'all',
                child: Text('All Posts'),
              ),
              const PopupMenuItem(
                value: 'reported',
                child: Text('Reported'),
              ),
              const PopupMenuItem(
                value: 'under_review',
                child: Text('Under Review'),
              ),
              const PopupMenuItem(
                value: 'assigned',
                child: Text('Assigned'),
              ),
              const PopupMenuItem(
                value: 'in_progress',
                child: Text('In Progress'),
              ),
              const PopupMenuItem(
                value: 'resolved',
                child: Text('Resolved'),
              ),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(userPostsProvider(authState.user!.id).notifier).refreshUserPosts(),
        child: Column(
          children: [
            // Filter Tabs
            _buildFilterTabs(),
            
            // Posts List
            Expanded(
              child: _buildPostsList(userPostsState),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }
  
  Widget _buildFilterTabs() {
    return Container(
      height: 50,
      color: Colors.white,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildFilterTab('All', 'all'),
          _buildFilterTab('Reported', 'reported'),
          _buildFilterTab('Under Review', 'under_review'),
          _buildFilterTab('Assigned', 'assigned'),
          _buildFilterTab('In Progress', 'in_progress'),
          _buildFilterTab('Resolved', 'resolved'),
        ],
      ),
    );
  }
  
  Widget _buildFilterTab(String label, String value) {
    final isSelected = _selectedFilter == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = value),
      child: Container(
        margin: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppTheme.textPrimaryColor,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
  
  Widget _buildPostsList(userPostsState) {
    if (userPostsState == null) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (userPostsState.isLoading && userPostsState.posts.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (userPostsState.error != null && userPostsState.posts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: AppTheme.errorColor,
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to load posts',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              userPostsState.error!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final authState = ref.read(authProvider);
                if (authState.user != null) {
                  ref.read(userPostsProvider(authState.user!.id).notifier).refreshUserPosts();
                }
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }
    
    // Filter posts based on selected filter
    final filteredPosts = _selectedFilter == 'all'
        ? userPostsState.posts
        : userPostsState.posts.where((post) {
            switch (_selectedFilter) {
              case 'reported':
                return post.status == 'Reported';
              case 'under_review':
                return post.status == 'Under Review';
              case 'assigned':
                return post.status == 'Assigned';
              case 'in_progress':
                return post.status == 'In Progress';
              case 'resolved':
                return post.status == 'Resolved';
              default:
                return true;
            }
          }).toList();
    
    if (filteredPosts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.inbox_outlined,
              size: 64,
              color: AppTheme.textSecondaryColor,
            ),
            const SizedBox(height: 16),
            Text(
              _selectedFilter == 'all' ? 'No posts yet' : 'No posts in this category',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              _selectedFilter == 'all'
                  ? 'Start by reporting an issue in your area'
                  : 'Try selecting a different filter',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            if (_selectedFilter == 'all') ...[
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.push('/create-post'),
                child: const Text('Create First Post'),
              ),
            ],
          ],
        ),
      );
    }
    
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: filteredPosts.length + (userPostsState.isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == filteredPosts.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            ),
          );
        }
        
        final post = filteredPosts[index];
        return _buildPostCard(post);
      },
    );
  }
  
  Widget _buildPostCard(post) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => context.push('/post/${post.id}'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  _buildCategoryChip(post.category),
                  const SizedBox(width: 8),
                  _buildSeverityChip(post.severity),
                  const Spacer(),
                  _buildStatusChip(post.status),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Title
              Text(
                post.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 8),
              
              // Description
              Text(
                post.description,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              const SizedBox(height: 12),
              
              // Status Timeline
              StatusTimeline(
                currentStatus: post.status,
                statuses: AppConstants.postStatuses,
              ),
              
              const SizedBox(height: 12),
              
              // Footer
              Row(
                children: [
                  const Icon(Icons.location_on, size: 16, color: AppTheme.textSecondaryColor),
                  const SizedBox(width: 4),
                  Text(
                    post.area,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    post.timeAgo,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              // Actions
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.thumb_up_outlined),
                    onPressed: () {
                      // TODO: Implement upvote
                    },
                  ),
                  Text('${post.upvotes}'),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.thumb_down_outlined),
                    onPressed: () {
                      // TODO: Implement downvote
                    },
                  ),
                  Text('${post.downvotes}'),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.comment_outlined),
                    onPressed: () {
                      // TODO: Show comments
                    },
                  ),
                  Text('${post.comments.length}'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildCategoryChip(String category) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        category,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: AppTheme.primaryColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
  
  Widget _buildSeverityChip(String severity) {
    final color = AppTheme.getSeverityColor(severity);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        severity,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
  
  Widget _buildStatusChip(String status) {
    final color = AppTheme.getStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
  
  Widget _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: 3, // My Posts is selected
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          label: 'Maps',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add),
          label: 'Create',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'My Posts',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.inbox),
          label: 'Inbox',
        ),
      ],
      onTap: (index) {
        switch (index) {
          case 0:
            context.push('/home');
            break;
          case 1:
            context.push('/maps');
            break;
          case 2:
            context.push('/create-post');
            break;
          case 3:
            // Already on my posts
            break;
          case 4:
            context.push('/inbox');
            break;
        }
      },
    );
  }
}
