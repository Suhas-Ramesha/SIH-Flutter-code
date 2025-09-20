import 'package:flutter/material.dart';
import '../core/theme.dart';

class InteractiveRoadmap extends StatefulWidget {
  final String currentStatus;
  final List<String> statuses;
  final List<DateTime>? timestamps;
  final List<String>? descriptions;
  final bool isInteractive;
  final Function(String)? onStatusTap;
  
  const InteractiveRoadmap({
    super.key,
    required this.currentStatus,
    required this.statuses,
    this.timestamps,
    this.descriptions,
    this.isInteractive = true,
    this.onStatusTap,
  });
  
  @override
  State<InteractiveRoadmap> createState() => _InteractiveRoadmapState();
}

class _InteractiveRoadmapState extends State<InteractiveRoadmap>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    final currentIndex = widget.statuses.indexOf(widget.currentStatus);
    final progress = currentIndex / (widget.statuses.length - 1);
    
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: progress,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _animationController.forward();
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderColor.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 16,
            offset: const Offset(0, 8),
            spreadRadius: 2,
          ),
          BoxShadow(
            color: AppTheme.secondaryColor.withOpacity(0.05),
            blurRadius: 24,
            offset: const Offset(0, 12),
            spreadRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.route,
                color: AppTheme.secondaryColor,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Issue Resolution Roadmap',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimaryColor,
                ),
              ),
              const Spacer(),
              _buildProgressIndicator(),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Interactive Timeline
          _buildInteractiveTimeline(),
        ],
      ),
    );
  }
  
  Widget _buildProgressIndicator() {
    return AnimatedBuilder(
      animation: _progressAnimation,
      builder: (context, child) {
        final currentIndex = widget.statuses.indexOf(widget.currentStatus);
        final progress = _progressAnimation.value;
        
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppTheme.secondaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '${(progress * 100).round()}% Complete',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.secondaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildInteractiveTimeline() {
    final currentIndex = widget.statuses.indexOf(widget.currentStatus);
    
    return Column(
      children: widget.statuses.asMap().entries.map((entry) {
        final index = entry.key;
        final status = entry.value;
        final isCompleted = index <= currentIndex;
        final isCurrent = index == currentIndex;
        final timestamp = widget.timestamps != null && index < widget.timestamps!.length 
            ? widget.timestamps![index] 
            : null;
        final description = widget.descriptions != null && index < widget.descriptions!.length
            ? widget.descriptions![index]
            : _getDefaultDescription(status);
        
        return _buildTimelineItem(
          status: status,
          description: description,
          timestamp: timestamp,
          isCompleted: isCompleted,
          isCurrent: isCurrent,
          index: index,
        );
      }).toList(),
    );
  }
  
  Widget _buildTimelineItem({
    required String status,
    required String description,
    DateTime? timestamp,
    required bool isCompleted,
    required bool isCurrent,
    required int index,
  }) {
    return AnimatedBuilder(
      animation: _progressAnimation,
      builder: (context, child) {
        final shouldAnimate = index <= widget.statuses.indexOf(widget.currentStatus);
        final animationValue = shouldAnimate ? _progressAnimation.value : 0.0;
        
        return Transform.translate(
          offset: Offset(0, (1 - animationValue) * 20),
          child: Opacity(
            opacity: shouldAnimate ? animationValue : 0.3,
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Timeline indicator
                  _buildTimelineIndicator(status, isCompleted, isCurrent, index),
                  
                  const SizedBox(width: 16),
                  
                  // Content
                  Expanded(
                    child: GestureDetector(
                      onTap: widget.isInteractive && isCompleted
                          ? () => widget.onStatusTap?.call(status)
                          : null,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isCurrent 
                              ? AppTheme.secondaryColor.withOpacity(0.15)
                              : isCompleted 
                                  ? AppTheme.primaryColor.withOpacity(0.08)
                                  : AppTheme.cardColor,
                          borderRadius: BorderRadius.circular(12),
                          border: isCurrent 
                              ? Border.all(color: AppTheme.secondaryColor, width: 2)
                              : Border.all(color: AppTheme.borderColor.withOpacity(0.3)),
                          boxShadow: [
                            if (isCurrent)
                              BoxShadow(
                                color: AppTheme.secondaryColor.withOpacity(0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                                spreadRadius: 1,
                              ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  status,
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.w600,
                                    color: isCompleted 
                                        ? AppTheme.getStatusColor(status)
                                        : AppTheme.textSecondaryColor,
                                  ),
                                ),
                                if (isCurrent) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppTheme.secondaryColor,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text(
                                      'CURRENT',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                                if (isCompleted && !isCurrent) ...[
                                  const SizedBox(width: 8),
                                  Icon(
                                    Icons.check_circle,
                                    size: 16,
                                    color: AppTheme.getStatusColor(status),
                                  ),
                                ],
                              ],
                            ),
                            
                            const SizedBox(height: 4),
                            
                            Text(
                              description,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: isCompleted 
                                    ? AppTheme.textPrimaryColor
                                    : AppTheme.textSecondaryColor,
                              ),
                            ),
                            
                            if (timestamp != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                _formatTimestamp(timestamp),
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppTheme.textHintColor,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildTimelineIndicator(String status, bool isCompleted, bool isCurrent, int index) {
    final color = AppTheme.getStatusColor(status);
    
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: isCompleted ? color : AppTheme.borderColor,
            shape: BoxShape.circle,
            border: isCurrent ? Border.all(color: color, width: 3) : null,
            boxShadow: isCurrent ? [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ] : null,
          ),
          child: isCompleted
              ? Icon(
                  isCurrent ? Icons.radio_button_checked : Icons.check,
                  size: 16,
                  color: Colors.white,
                )
              : Icon(
                  Icons.radio_button_unchecked,
                  size: 16,
                  color: AppTheme.textSecondaryColor,
                ),
        ),
        
        if (index < widget.statuses.length - 1)
          Container(
            width: 2,
            height: 40,
            color: isCompleted ? color : AppTheme.borderColor,
          ),
      ],
    );
  }
  
  String _getDefaultDescription(String status) {
    switch (status.toLowerCase()) {
      case 'reported':
        return 'Issue has been reported and is awaiting review';
      case 'under review':
        return 'BBMP officials are reviewing the issue';
      case 'assigned':
        return 'Issue has been assigned to a department';
      case 'in progress':
        return 'Work is currently being done to resolve the issue';
      case 'resolved':
        return 'Issue has been successfully resolved';
      case 'closed':
        return 'Issue has been closed and archived';
      default:
        return 'Status update';
    }
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
}

class DetailedRoadmap extends StatelessWidget {
  final String currentStatus;
  final List<RoadmapStep> steps;
  final bool isInteractive;
  final Function(RoadmapStep)? onStepTap;
  
  const DetailedRoadmap({
    super.key,
    required this.currentStatus,
    required this.steps,
    this.isInteractive = true,
    this.onStepTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.timeline,
                color: AppTheme.secondaryColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Detailed Progress Timeline',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimaryColor,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Steps
          ...steps.map((step) => _buildStepCard(context, step)),
        ],
      ),
    );
  }
  
  Widget _buildStepCard(BuildContext context, RoadmapStep step) {
    final isCompleted = _isStepCompleted(step.status);
    final isCurrent = step.status == currentStatus;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: isInteractive ? () => onStepTap?.call(step) : null,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isCurrent 
                ? AppTheme.secondaryColor.withOpacity(0.1)
                : isCompleted 
                    ? AppTheme.primaryColor.withOpacity(0.05)
                    : AppTheme.cardColor,
            borderRadius: BorderRadius.circular(8),
            border: isCurrent 
                ? Border.all(color: AppTheme.secondaryColor, width: 1)
                : null,
          ),
          child: Row(
            children: [
              // Status indicator
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: isCompleted 
                      ? AppTheme.getStatusColor(step.status)
                      : AppTheme.borderColor,
                  shape: BoxShape.circle,
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step.status,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: isCurrent ? FontWeight.bold : FontWeight.w600,
                        color: isCompleted 
                            ? AppTheme.getStatusColor(step.status)
                            : AppTheme.textSecondaryColor,
                      ),
                    ),
                    
                    const SizedBox(height: 4),
                    
                    Text(
                      step.description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isCompleted 
                            ? AppTheme.textPrimaryColor
                            : AppTheme.textSecondaryColor,
                      ),
                    ),
                    
                    if (step.timestamp != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        _formatTimestamp(step.timestamp!),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textHintColor,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              
              // Action indicator
              if (isCurrent)
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: AppTheme.secondaryColor,
                ),
            ],
          ),
        ),
      ),
    );
  }
  
  bool _isStepCompleted(String status) {
    final statusOrder = ['Reported', 'Under Review', 'Assigned', 'In Progress', 'Resolved', 'Closed'];
    final currentIndex = statusOrder.indexOf(currentStatus);
    final stepIndex = statusOrder.indexOf(status);
    
    return stepIndex <= currentIndex;
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
