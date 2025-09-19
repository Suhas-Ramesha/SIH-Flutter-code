import 'package:flutter/material.dart';
import '../models/post.dart';
import '../core/theme.dart';

class PostCard extends StatelessWidget {
  final Post post;
  final VoidCallback? onTap;
  final VoidCallback? onUpvote;
  final VoidCallback? onDownvote;
  final VoidCallback? onComment;
  final VoidCallback? onShare;
  
  const PostCard({
    super.key,
    required this.post,
    this.onTap,
    this.onUpvote,
    this.onDownvote,
    this.onComment,
    this.onShare,
  });
  
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(),
              
              const SizedBox(height: 12),
              
              // Title
              Text(
                post.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              const SizedBox(height: 8),
              
              // Description
              Text(
                post.description,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              
              const SizedBox(height: 12),
              
              // Images
              if (post.images.isNotEmpty) _buildImages(),
              
              const SizedBox(height: 12),
              
              // Footer
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildHeader() {
    return Row(
      children: [
        // Category Chip
        _buildCategoryChip(),
        
        const SizedBox(width: 8),
        
        // Severity Chip
        _buildSeverityChip(),
        
        const Spacer(),
        
        // Status Chip
        _buildStatusChip(),
      ],
    );
  }
  
  Widget _buildCategoryChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        post.category,
        style: const TextStyle(
          color: AppTheme.primaryColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
  
  Widget _buildSeverityChip() {
    final color = AppTheme.getSeverityColor(post.severity);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        post.severity,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
  
  Widget _buildStatusChip() {
    final color = AppTheme.getStatusColor(post.status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        post.status,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
  
  Widget _buildImages() {
    if (post.images.isEmpty) return const SizedBox.shrink();
    
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: post.images.length,
        itemBuilder: (context, index) {
          return Container(
            width: 120,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[200],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                post.images[index],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    child: const Center(
                      child: Icon(
                        Icons.image_not_supported,
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
  
  Widget _buildFooter() {
    return Column(
      children: [
        // User and Location Info
        Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: AppTheme.primaryColor,
              child: Text(
                post.username.substring(0, 1).toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              post.username,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.location_on, size: 16, color: AppTheme.textSecondaryColor),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                post.area,
                style: const TextStyle(
                  color: AppTheme.textSecondaryColor,
                  fontSize: 14,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              post.timeAgo,
              style: const TextStyle(
                color: AppTheme.textSecondaryColor,
                fontSize: 12,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 12),
        
        // Actions
        Row(
          children: [
            // Upvote Button
            _buildActionButton(
              icon: Icons.thumb_up_outlined,
              label: post.upvotes.toString(),
              onPressed: onUpvote,
              color: AppTheme.primaryColor,
            ),
            
            const SizedBox(width: 16),
            
            // Downvote Button
            _buildActionButton(
              icon: Icons.thumb_down_outlined,
              label: post.downvotes.toString(),
              onPressed: onDownvote,
              color: AppTheme.textSecondaryColor,
            ),
            
            const SizedBox(width: 16),
            
            // Net Votes
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: post.netVotes >= 0 ? AppTheme.successColor.withOpacity(0.1) : AppTheme.errorColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${post.netVotes >= 0 ? '+' : ''}${post.netVotes}',
                style: TextStyle(
                  color: post.netVotes >= 0 ? AppTheme.successColor : AppTheme.errorColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            
            const Spacer(),
            
            // Comment Button
            _buildActionButton(
              icon: Icons.comment_outlined,
              label: post.comments.length.toString(),
              onPressed: onComment,
              color: AppTheme.textSecondaryColor,
            ),
            
            const SizedBox(width: 8),
            
            // Share Button
            _buildActionButton(
              icon: Icons.share_outlined,
              label: 'Share',
              onPressed: onShare,
              color: AppTheme.textSecondaryColor,
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback? onPressed,
    required Color color,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
