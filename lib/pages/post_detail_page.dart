import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/post.dart';
import '../providers/posts_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/vote_button.dart';
import '../widgets/status_timeline.dart';
import '../core/theme.dart';
import '../core/constants.dart';

class PostDetailPage extends ConsumerStatefulWidget {
  final String postId;
  
  const PostDetailPage({super.key, required this.postId});
  
  @override
  ConsumerState<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends ConsumerState<PostDetailPage> {
  final _commentController = TextEditingController();
  Post? _post;
  bool _isLoading = true;
  String? _error;
  
  @override
  void initState() {
    super.initState();
    _loadPost();
  }
  
  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
  
  Future<void> _loadPost() async {
    try {
      final post = await ref.read(postsProvider.notifier).getPost(widget.postId);
      if (mounted) {
        setState(() {
          _post = post;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final postsNotifier = ref.read(postsProvider.notifier);
    
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Loading...')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    
    if (_error != null || _post == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(
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
                'Failed to load post',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                _error ?? 'Post not found',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                    _error = null;
                  });
                  _loadPost();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _sharePost(),
          ),
          if (authState.user?.isAdmin == true)
            PopupMenuButton<String>(
              onSelected: (value) => _handleAdminAction(value),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'assign',
                  child: Text('Assign to Team'),
                ),
                const PopupMenuItem(
                  value: 'status',
                  child: Text('Change Status'),
                ),
                const PopupMenuItem(
                  value: 'note',
                  child: Text('Add Note'),
                ),
              ],
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Post Header
            _buildPostHeader(),
            
            // Post Images
            if (_post!.images.isNotEmpty) _buildPostImages(),
            
            // Post Content
            _buildPostContent(),
            
            // Voting Section
            _buildVotingSection(),
            
            // Status Timeline
            _buildStatusTimeline(),
            
            // BBMP Notes
            if (_post!.bbmpNotes.isNotEmpty) _buildBbmpNotes(),
            
            // Comments Section
            _buildCommentsSection(),
            
            const SizedBox(height: 100), // Space for bottom navigation
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }
  
  Widget _buildPostHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category and Severity Chips
          Row(
            children: [
              _buildCategoryChip(_post!.category),
              const SizedBox(width: 8),
              _buildSeverityChip(_post!.severity),
              const Spacer(),
              _buildStatusChip(_post!.status),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Title
          Text(
            _post!.title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // User and Location Info
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: AppTheme.primaryColor,
                child: Text(
                  _post!.username.substring(0, 1).toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _post!.username,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.location_on, size: 16, color: AppTheme.textSecondaryColor),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  _post!.area,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
              ),
              Text(
                _post!.timeAgo,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildPostImages() {
    return Container(
      height: 200,
      child: PageView.builder(
        itemCount: _post!.images.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey[200],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                _post!.images[index],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    child: const Center(
                      child: Icon(
                        Icons.image_not_supported,
                        size: 48,
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildPostContent() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Description',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _post!.description,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          
          const SizedBox(height: 16),
          
          // Location Details
          Row(
            children: [
              const Icon(Icons.location_on, color: AppTheme.textSecondaryColor),
              const SizedBox(width: 8),
              Text(
                'Lat: ${_post!.latitude.toStringAsFixed(4)}, Lng: ${_post!.longitude.toStringAsFixed(4)}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildVotingSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: [
          VoteButton(
            icon: Icons.thumb_up,
            count: _post!.upvotes,
            onPressed: () => ref.read(postsProvider.notifier).upvotePost(_post!.id),
          ),
          const SizedBox(width: 16),
          VoteButton(
            icon: Icons.thumb_down,
            count: _post!.downvotes,
            onPressed: () => ref.read(postsProvider.notifier).downvotePost(_post!.id),
          ),
          const Spacer(),
          Text(
            '${_post!.netVotes} net votes',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildStatusTimeline() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Status Timeline',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          StatusTimeline(
            currentStatus: _post!.status,
            statuses: AppConstants.postStatuses,
          ),
        ],
      ),
    );
  }
  
  Widget _buildBbmpNotes() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Official Updates',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ..._post!.bbmpNotes.map((note) => _buildBbmpNote(note)),
        ],
      ),
    );
  }
  
  Widget _buildBbmpNote(BbmpNote note) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.admin_panel_settings, size: 16, color: AppTheme.primaryColor),
              const SizedBox(width: 8),
              Text(
                note.adminName,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryColor,
                ),
              ),
              const Spacer(),
              Text(
                _formatDateTime(note.createdAt),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            note.text,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
  
  Widget _buildCommentsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Comments (${_post!.comments.length})',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          
          // Comments List
          if (_post!.comments.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text('No comments yet. Be the first to comment!'),
              ),
            )
          else
            ..._post!.comments.map((comment) => _buildComment(comment)),
        ],
      ),
    );
  }
  
  Widget _buildComment(Comment comment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: comment.isFromAdmin ? AppTheme.primaryColor : Colors.grey,
                child: Text(
                  comment.username.substring(0, 1).toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                comment.username,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (comment.isFromAdmin) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'ADMIN',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
              const Spacer(),
              Text(
                _formatDateTime(comment.createdAt),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            comment.text,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
  
  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppTheme.borderColor)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _commentController,
              decoration: const InputDecoration(
                hintText: 'Add a comment...',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              maxLines: null,
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            onPressed: _addComment,
            icon: const Icon(Icons.send),
            style: IconButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
            ),
          ),
        ],
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
  
  void _sharePost() {
    // TODO: Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Share feature coming soon')),
    );
  }
  
  void _handleAdminAction(String action) {
    switch (action) {
      case 'assign':
        _showAssignDialog();
        break;
      case 'status':
        _showStatusDialog();
        break;
      case 'note':
        _showNoteDialog();
        break;
    }
  }
  
  void _showAssignDialog() {
    // TODO: Implement assign dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Assign feature coming soon')),
    );
  }
  
  void _showStatusDialog() {
    // TODO: Implement status change dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Status change feature coming soon')),
    );
  }
  
  void _showNoteDialog() {
    // TODO: Implement note dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Add note feature coming soon')),
    );
  }
  
  void _addComment() {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;
    
    ref.read(postsProvider.notifier).addComment(_post!.id, text);
    _commentController.clear();
  }
  
  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
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
}
