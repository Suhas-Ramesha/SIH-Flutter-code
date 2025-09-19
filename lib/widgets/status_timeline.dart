import 'package:flutter/material.dart';
import '../core/theme.dart';

class StatusTimeline extends StatelessWidget {
  final String currentStatus;
  final List<String> statuses;
  final bool showConnectors;
  
  const StatusTimeline({
    super.key,
    required this.currentStatus,
    required this.statuses,
    this.showConnectors = true,
  });
  
  @override
  Widget build(BuildContext context) {
    final currentIndex = statuses.indexOf(currentStatus);
    
    return Row(
      children: statuses.asMap().entries.map((entry) {
        final index = entry.key;
        final status = entry.value;
        final isCompleted = index <= currentIndex;
        final isCurrent = index == currentIndex;
        
        return Expanded(
          child: Row(
            children: [
              // Status Circle
              _buildStatusCircle(status, isCompleted, isCurrent),
              
              // Connector Line
              if (index < statuses.length - 1 && showConnectors)
                Expanded(
                  child: Container(
                    height: 2,
                    color: isCompleted ? AppTheme.primaryColor : AppTheme.borderColor,
                  ),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }
  
  Widget _buildStatusCircle(String status, bool isCompleted, bool isCurrent) {
    final color = AppTheme.getStatusColor(status);
    
    return Column(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: isCompleted ? color : Colors.grey[300],
            shape: BoxShape.circle,
            border: isCurrent ? Border.all(color: color, width: 2) : null,
          ),
          child: isCompleted
              ? Icon(
                  isCurrent ? Icons.radio_button_checked : Icons.check,
                  size: 16,
                  color: Colors.white,
                )
              : null,
        ),
        const SizedBox(height: 4),
        Text(
          status,
          style: TextStyle(
            fontSize: 10,
            fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
            color: isCompleted ? color : AppTheme.textSecondaryColor,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class VerticalStatusTimeline extends StatelessWidget {
  final String currentStatus;
  final List<String> statuses;
  final List<DateTime>? timestamps;
  
  const VerticalStatusTimeline({
    super.key,
    required this.currentStatus,
    required this.statuses,
    this.timestamps,
  });
  
  @override
  Widget build(BuildContext context) {
    final currentIndex = statuses.indexOf(currentStatus);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: statuses.asMap().entries.map((entry) {
        final index = entry.key;
        final status = entry.value;
        final isCompleted = index <= currentIndex;
        final isCurrent = index == currentIndex;
        final timestamp = timestamps != null && index < timestamps!.length 
            ? timestamps![index] 
            : null;
        
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timeline Line and Circle
            Column(
              children: [
                _buildStatusCircle(status, isCompleted, isCurrent),
                if (index < statuses.length - 1)
                  Container(
                    width: 2,
                    height: 40,
                    color: isCompleted ? AppTheme.primaryColor : AppTheme.borderColor,
                  ),
              ],
            ),
            
            const SizedBox(width: 16),
            
            // Status Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    status,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isCurrent ? FontWeight.bold : FontWeight.w600,
                      color: isCompleted ? AppTheme.getStatusColor(status) : AppTheme.textSecondaryColor,
                    ),
                  ),
                  if (timestamp != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      _formatTimestamp(timestamp),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
  
  Widget _buildStatusCircle(String status, bool isCompleted, bool isCurrent) {
    final color = AppTheme.getStatusColor(status);
    
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: isCompleted ? color : Colors.grey[300],
        shape: BoxShape.circle,
        border: isCurrent ? Border.all(color: color, width: 2) : null,
      ),
      child: isCompleted
          ? Icon(
              isCurrent ? Icons.radio_button_checked : Icons.check,
              size: 16,
              color: Colors.white,
            )
          : null,
    );
  }
  
  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }
}

class StatusProgressIndicator extends StatelessWidget {
  final String currentStatus;
  final List<String> statuses;
  final double height;
  
  const StatusProgressIndicator({
    super.key,
    required this.currentStatus,
    required this.statuses,
    this.height = 8,
  });
  
  @override
  Widget build(BuildContext context) {
    final currentIndex = statuses.indexOf(currentStatus);
    final progress = currentIndex / (statuses.length - 1);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Progress Bar
        Container(
          height: height,
          decoration: BoxDecoration(
            color: AppTheme.borderColor,
            borderRadius: BorderRadius.circular(height / 2),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progress,
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.circular(height / 2),
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Status Text
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Progress: ${((progress * 100).round())}%',
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondaryColor,
              ),
            ),
            Text(
              currentStatus,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppTheme.getStatusColor(currentStatus),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
