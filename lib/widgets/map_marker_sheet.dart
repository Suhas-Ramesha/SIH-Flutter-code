import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/theme.dart';

class MapMarkerSheet extends StatelessWidget {
  final Map<String, dynamic> marker;
  final VoidCallback? onOpenPost;
  final VoidCallback? onNavigate;
  final VoidCallback? onShare;
  
  const MapMarkerSheet({
    super.key,
    required this.marker,
    this.onOpenPost,
    this.onNavigate,
    this.onShare,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle Bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Header
          Row(
            children: [
              // Category Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _getCategoryColor(marker['category']).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getCategoryIcon(marker['category']),
                  color: _getCategoryColor(marker['category']),
                  size: 24,
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Title and Status
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      marker['title'],
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        _buildStatusChip(marker['status']),
                        const SizedBox(width: 8),
                        _buildSeverityChip(marker['severity']),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Close Button
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Category
          Row(
            children: [
              const Icon(Icons.category, size: 16, color: AppTheme.textSecondaryColor),
              const SizedBox(width: 8),
              Text(
                marker['category'],
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondaryColor,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          // Location
          Row(
            children: [
              const Icon(Icons.location_on, size: 16, color: AppTheme.textSecondaryColor),
              const SizedBox(width: 8),
              Text(
                'Lat: ${marker['latitude'].toStringAsFixed(4)}, Lng: ${marker['longitude'].toStringAsFixed(4)}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondaryColor,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          // Upvotes
          Row(
            children: [
              const Icon(Icons.thumb_up, size: 16, color: AppTheme.textSecondaryColor),
              const SizedBox(width: 8),
              Text(
                '${marker['upvotes']} upvotes',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondaryColor,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onNavigate,
                  icon: const Icon(Icons.navigation),
                  label: const Text('Navigate'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onShare,
                  icon: const Icon(Icons.share),
                  label: const Text('Share'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onOpenPost,
                  icon: const Icon(Icons.open_in_new),
                  label: const Text('Open Post'),
                ),
              ),
            ],
          ),
        ],
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
        style: TextStyle(
          color: color,
          fontSize: 12,
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
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
  
  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'potholes':
        return const Color(0xFF8D6E63);
      case 'streetlights not working':
        return const Color(0xFFFFC107);
      case 'waterlogging / drainage blockages':
        return const Color(0xFF2196F3);
      case 'broken / missing road signs':
        return const Color(0xFF9C27B0);
      case 'trash / illegal dumping':
        return const Color(0xFF795548);
      case 'sidewalk / footpath damage':
        return const Color(0xFF607D8B);
      case 'fallen trees / vegetation blocking road':
        return const Color(0xFF4CAF50);
      case 'unsafe manhole / missing covers':
        return const Color(0xFFF44336);
      case 'bus-shelter / public furniture damage':
        return const Color(0xFF3F51B5);
      case 'traffic signal faults':
        return const Color(0xFFFF5722);
      case 'encroachments / illegal constructions':
        return const Color(0xFFE91E63);
      case 'public toilet issues':
        return const Color(0xFF009688);
      case 'road markings faded':
        return const Color(0xFF9E9E9E);
      case 'sewage / water leak complaints':
        return const Color(0xFF00BCD4);
      case 'noise / pollution complaints':
        return const Color(0xFF673AB7);
      case 'tree trimming requests':
        return const Color(0xFF8BC34A);
      default:
        return AppTheme.primaryColor;
    }
  }
  
  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'potholes':
        return Icons.construction;
      case 'streetlights not working':
        return Icons.lightbulb_outline;
      case 'waterlogging / drainage blockages':
        return Icons.water_drop;
      case 'broken / missing road signs':
        return Icons.traffic;
      case 'trash / illegal dumping':
        return Icons.delete_outline;
      case 'sidewalk / footpath damage':
        return Icons.directions_walk;
      case 'fallen trees / vegetation blocking road':
        return Icons.park;
      case 'unsafe manhole / missing covers':
        return Icons.dangerous;
      case 'bus-shelter / public furniture damage':
        return Icons.bus_alert;
      case 'traffic signal faults':
        return Icons.traffic;
      case 'encroachments / illegal constructions':
        return Icons.home_work;
      case 'public toilet issues':
        return Icons.wc;
      case 'road markings faded':
        return Icons.directions;
      case 'sewage / water leak complaints':
        return Icons.plumbing;
      case 'noise / pollution complaints':
        return Icons.volume_up;
      case 'tree trimming requests':
        return Icons.content_cut;
      default:
        return Icons.report_problem;
    }
  }
}
