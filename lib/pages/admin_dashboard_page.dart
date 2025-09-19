import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../providers/posts_provider.dart';
import '../core/theme.dart';
import '../core/constants.dart';
import '../core/mock_data.dart';

class AdminDashboardPage extends ConsumerStatefulWidget {
  const AdminDashboardPage({super.key});
  
  @override
  ConsumerState<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends ConsumerState<AdminDashboardPage> {
  String _selectedFilter = 'all';
  String _selectedStatus = 'all';
  
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    
    // Check if user is admin
    if (authState.user?.isAdmin != true) {
      return Scaffold(
        appBar: AppBar(title: const Text('Admin Dashboard')),
        body: const Center(
          child: Text('Access denied. Admin privileges required.'),
        ),
      );
    }
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // TODO: Refresh dashboard data
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Dashboard refreshed')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Statistics Cards
            _buildStatisticsCards(),
            
            const SizedBox(height: 24),
            
            // Filter Controls
            _buildFilterControls(),
            
            const SizedBox(height: 24),
            
            // Reports List
            _buildReportsList(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStatisticsCards() {
    // Get mock statistics
    final totalReports = MockData.mockPosts.length;
    final reportedCount = MockData.getPostsByStatus('Reported').length;
    final underReviewCount = MockData.getPostsByStatus('Under Review').length;
    final assignedCount = MockData.getPostsByStatus('Assigned').length;
    final inProgressCount = MockData.getPostsByStatus('In Progress').length;
    final resolvedCount = MockData.getPostsByStatus('Resolved').length;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overview',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.5,
          children: [
            _buildStatCard('Total Reports', totalReports.toString(), AppTheme.primaryColor),
            _buildStatCard('Reported', reportedCount.toString(), AppTheme.reportedColor),
            _buildStatCard('Under Review', underReviewCount.toString(), AppTheme.underReviewColor),
            _buildStatCard('Assigned', assignedCount.toString(), AppTheme.assignedColor),
            _buildStatCard('In Progress', inProgressCount.toString(), AppTheme.inProgressColor),
            _buildStatCard('Resolved', resolvedCount.toString(), AppTheme.resolvedColor),
          ],
        ),
      ],
    );
  }
  
  Widget _buildStatCard(String title, String value, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondaryColor,
              ),
            ),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildFilterControls() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Filters',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _selectedFilter,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items: [
                  const DropdownMenuItem(value: 'all', child: Text('All Categories')),
                  ...AppConstants.categories.map((category) => DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  )),
                ],
                onChanged: (value) => setState(() => _selectedFilter = value!),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _selectedStatus,
                decoration: const InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                ),
                items: [
                  const DropdownMenuItem(value: 'all', child: Text('All Statuses')),
                  ...AppConstants.postStatuses.map((status) => DropdownMenuItem(
                    value: status,
                    child: Text(status),
                  )),
                ],
                onChanged: (value) => setState(() => _selectedStatus = value!),
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildReportsList() {
    // Get filtered reports
    List<dynamic> reports = MockData.mockPosts;
    
    if (_selectedFilter != 'all') {
      reports = reports.where((report) => report.category == _selectedFilter).toList();
    }
    
    if (_selectedStatus != 'all') {
      reports = reports.where((report) => report.status == _selectedStatus).toList();
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Reports (${reports.length})',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton.icon(
              onPressed: () {
                // TODO: Export reports
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Export feature coming soon')),
                );
              },
              icon: const Icon(Icons.download),
              label: const Text('Export'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...reports.map((report) => _buildReportCard(report)),
      ],
    );
  }
  
  Widget _buildReportCard(report) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                _buildCategoryChip(report.category),
                const SizedBox(width: 8),
                _buildSeverityChip(report.severity),
                const Spacer(),
                _buildStatusChip(report.status),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Title
            Text(
              report.title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Description
            Text(
              report.description,
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            
            const SizedBox(height: 12),
            
            // Meta Info
            Row(
              children: [
                const Icon(Icons.person, size: 16, color: AppTheme.textSecondaryColor),
                const SizedBox(width: 4),
                Text(
                  report.username,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.location_on, size: 16, color: AppTheme.textSecondaryColor),
                const SizedBox(width: 4),
                Text(
                  report.area,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
                const Spacer(),
                Text(
                  report.timeAgo,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Actions
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _assignReport(report),
                    icon: const Icon(Icons.assignment),
                    label: const Text('Assign'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _changeStatus(report),
                    icon: const Icon(Icons.update),
                    label: const Text('Status'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _addNote(report),
                    icon: const Icon(Icons.note_add),
                    label: const Text('Note'),
                  ),
                ),
              ],
            ),
          ],
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
  
  void _assignReport(report) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Assign Report'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Select team to assign this report to:'),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Team',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'drainage', child: Text('Drainage Team')),
                DropdownMenuItem(value: 'electrical', child: Text('Electrical Team')),
                DropdownMenuItem(value: 'road', child: Text('Road Maintenance')),
                DropdownMenuItem(value: 'sanitation', child: Text('Sanitation Team')),
              ],
              onChanged: (value) {
                // TODO: Handle team selection
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement assignment
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Report assigned successfully')),
              );
            },
            child: const Text('Assign'),
          ),
        ],
      ),
    );
  }
  
  void _changeStatus(report) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Select new status for this report:'),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: report.status,
              decoration: const InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(),
              ),
              items: AppConstants.postStatuses.map((status) => DropdownMenuItem(
                value: status,
                child: Text(status),
              )).toList(),
              onChanged: (value) {
                // TODO: Handle status change
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement status change
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Status updated successfully')),
              );
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }
  
  void _addNote(report) {
    final noteController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Note'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Add an official note for this report:'),
            const SizedBox(height: 16),
            TextField(
              controller: noteController,
              decoration: const InputDecoration(
                labelText: 'Note',
                border: OutlineInputBorder(),
                hintText: 'Enter your note here...',
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement note addition
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Note added successfully')),
              );
            },
            child: const Text('Add Note'),
          ),
        ],
      ),
    );
  }
}
