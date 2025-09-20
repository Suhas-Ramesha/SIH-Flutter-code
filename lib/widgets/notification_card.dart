import 'package:flutter/material.dart';
import '../models/notification.dart';
import '../core/theme.dart';

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback? onTap;
  final VoidCallback? onMarkAsRead;
  final bool showActions;
  
  const NotificationCard({
    super.key,
    required this.notification,
    this.onTap,
    this.onMarkAsRead,
    this.showActions = true,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: notification.isRead ? AppTheme.cardColor : AppTheme.secondaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: notification.isRead 
            ? Border.all(color: AppTheme.borderColor.withOpacity(0.5))
            : Border.all(color: AppTheme.secondaryColor.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 6),
            spreadRadius: 1,
          ),
          if (!notification.isRead)
            BoxShadow(
              color: AppTheme.secondaryColor.withOpacity(0.1),
              blurRadius: 16,
              offset: const Offset(0, 8),
              spreadRadius: 2,
            ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar/Icon
                _buildNotificationIcon(),
                
                const SizedBox(width: 12),
                
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title and time
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: notification.isRead ? FontWeight.w600 : FontWeight.bold,
                                color: AppTheme.textPrimaryColor,
                              ),
                            ),
                          ),
                          Text(
                            notification.timeAgo,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.textSecondaryColor,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 4),
                      
                      // Message
                      Text(
                        notification.message,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: notification.isRead 
                              ? AppTheme.textPrimaryColor
                              : AppTheme.textPrimaryColor,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      
                      // Post title if available
                      if (notification.postTitle != null) ...[
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            notification.postTitle!,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                
                // Actions
                if (showActions) ...[
                  const SizedBox(width: 8),
                  _buildActionButtons(context),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildNotificationIcon() {
    IconData iconData;
    Color iconColor;
    
    switch (notification.type) {
      case 'like':
        iconData = Icons.thumb_up;
        iconColor = AppTheme.successColor;
        break;
      case 'upvote':
        iconData = Icons.keyboard_arrow_up;
        iconColor = AppTheme.secondaryColor;
        break;
      case 'comment':
        iconData = Icons.comment;
        iconColor = AppTheme.warningColor;
        break;
      case 'status_update':
        iconData = Icons.update;
        iconColor = AppTheme.primaryColor;
        break;
      case 'bbmp_message':
        iconData = Icons.admin_panel_settings;
        iconColor = AppTheme.primaryColor;
        break;
      case 'community_message':
        iconData = Icons.message;
        iconColor = AppTheme.secondaryColor;
        break;
      default:
        iconData = Icons.notifications;
        iconColor = AppTheme.textSecondaryColor;
    }
    
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.15),
        shape: BoxShape.circle,
        border: notification.isRead 
            ? Border.all(color: iconColor.withOpacity(0.2))
            : Border.all(color: iconColor.withOpacity(0.4), width: 2),
        boxShadow: [
          BoxShadow(
            color: iconColor.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Icon(
        iconData,
        color: iconColor,
        size: 24,
      ),
    );
  }
  
  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        if (!notification.isRead)
          IconButton(
            onPressed: onMarkAsRead,
            icon: const Icon(Icons.mark_email_read),
            iconSize: 20,
            color: AppTheme.textSecondaryColor,
            tooltip: 'Mark as read',
          ),
        IconButton(
          onPressed: () => _showNotificationDetails(context),
          icon: const Icon(Icons.info_outline),
          iconSize: 20,
          color: AppTheme.textSecondaryColor,
          tooltip: 'View details',
        ),
      ],
    );
  }
  
  void _showNotificationDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(notification.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification.message,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            
            if (notification.postTitle != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.cardColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.borderColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Related Post:',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.postTitle!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            
            const SizedBox(height: 16),
            
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: AppTheme.textSecondaryColor,
                ),
                const SizedBox(width: 8),
                Text(
                  'Received ${notification.timeAgo}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          if (!notification.isRead)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onMarkAsRead?.call();
              },
              child: const Text('Mark as Read'),
            ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class NotificationListTile extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback? onTap;
  final VoidCallback? onMarkAsRead;
  
  const NotificationListTile({
    super.key,
    required this.notification,
    this.onTap,
    this.onMarkAsRead,
  });
  
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: _buildNotificationIcon(),
      title: Text(
        notification.title,
        style: TextStyle(
          fontWeight: notification.isRead ? FontWeight.w600 : FontWeight.bold,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            notification.message,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (notification.postTitle != null) ...[
            const SizedBox(height: 4),
            Text(
              notification.postTitle!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            notification.timeAgo,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.textSecondaryColor,
            ),
          ),
          if (!notification.isRead) ...[
            const SizedBox(height: 4),
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppTheme.secondaryColor,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ],
      ),
      onTap: onTap,
      onLongPress: onMarkAsRead,
    );
  }
  
  Widget _buildNotificationIcon() {
    IconData iconData;
    Color iconColor;
    
    switch (notification.type) {
      case 'like':
        iconData = Icons.thumb_up;
        iconColor = AppTheme.successColor;
        break;
      case 'upvote':
        iconData = Icons.keyboard_arrow_up;
        iconColor = AppTheme.secondaryColor;
        break;
      case 'comment':
        iconData = Icons.comment;
        iconColor = AppTheme.warningColor;
        break;
      case 'status_update':
        iconData = Icons.update;
        iconColor = AppTheme.primaryColor;
        break;
      case 'bbmp_message':
        iconData = Icons.admin_panel_settings;
        iconColor = AppTheme.primaryColor;
        break;
      case 'community_message':
        iconData = Icons.message;
        iconColor = AppTheme.secondaryColor;
        break;
      default:
        iconData = Icons.notifications;
        iconColor = AppTheme.textSecondaryColor;
    }
    
    return CircleAvatar(
      backgroundColor: iconColor.withOpacity(0.1),
      child: Icon(
        iconData,
        color: iconColor,
        size: 20,
      ),
    );
  }
}
