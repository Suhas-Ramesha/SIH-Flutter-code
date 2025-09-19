import 'package:flutter/material.dart';
import '../core/theme.dart';

class CategoryChip extends StatelessWidget {
  final String category;
  final bool isSelected;
  final VoidCallback? onTap;
  final bool showIcon;
  final Color? color;
  
  const CategoryChip({
    super.key,
    required this.category,
    this.isSelected = false,
    this.onTap,
    this.showIcon = true,
    this.color,
  });
  
  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? _getCategoryColor(category);
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? effectiveColor : effectiveColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: effectiveColor,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showIcon) ...[
              Icon(
                _getCategoryIcon(category),
                size: 16,
                color: isSelected ? Colors.white : effectiveColor,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              category,
              style: TextStyle(
                color: isSelected ? Colors.white : effectiveColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'potholes':
        return const Color(0xFF8D6E63); // Brown
      case 'streetlights not working':
        return const Color(0xFFFFC107); // Amber
      case 'waterlogging / drainage blockages':
        return const Color(0xFF2196F3); // Blue
      case 'broken / missing road signs':
        return const Color(0xFF9C27B0); // Purple
      case 'trash / illegal dumping':
        return const Color(0xFF795548); // Brown
      case 'sidewalk / footpath damage':
        return const Color(0xFF607D8B); // Blue Grey
      case 'fallen trees / vegetation blocking road':
        return const Color(0xFF4CAF50); // Green
      case 'unsafe manhole / missing covers':
        return const Color(0xFFF44336); // Red
      case 'bus-shelter / public furniture damage':
        return const Color(0xFF3F51B5); // Indigo
      case 'traffic signal faults':
        return const Color(0xFFFF5722); // Deep Orange
      case 'encroachments / illegal constructions':
        return const Color(0xFFE91E63); // Pink
      case 'public toilet issues':
        return const Color(0xFF009688); // Teal
      case 'road markings faded':
        return const Color(0xFF9E9E9E); // Grey
      case 'sewage / water leak complaints':
        return const Color(0xFF00BCD4); // Cyan
      case 'noise / pollution complaints':
        return const Color(0xFF673AB7); // Deep Purple
      case 'tree trimming requests':
        return const Color(0xFF8BC34A); // Light Green
      default:
        return AppTheme.primaryColor;
    }
  }
  
  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'potholes':
        return Icons.pothole;
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
        return Icons.road;
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

class CategoryChipList extends StatelessWidget {
  final List<String> categories;
  final List<String> selectedCategories;
  final Function(String, bool)? onCategoryChanged;
  final bool multiSelect;
  final bool showIcons;
  
  const CategoryChipList({
    super.key,
    required this.categories,
    this.selectedCategories = const [],
    this.onCategoryChanged,
    this.multiSelect = true,
    this.showIcons = true,
  });
  
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: categories.map((category) {
        final isSelected = selectedCategories.contains(category);
        
        return CategoryChip(
          category: category,
          isSelected: isSelected,
          showIcon: showIcons,
          onTap: onCategoryChanged != null
              ? () => onCategoryChanged!(category, !isSelected)
              : null,
        );
      }).toList(),
    );
  }
}

class CategoryFilterChips extends StatelessWidget {
  final List<String> categories;
  final List<String> selectedCategories;
  final Function(String, bool)? onCategoryChanged;
  final bool showClearAll;
  
  const CategoryFilterChips({
    super.key,
    required this.categories,
    this.selectedCategories = const [],
    this.onCategoryChanged,
    this.showClearAll = true,
  });
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Categories',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            if (showClearAll && selectedCategories.isNotEmpty)
              TextButton(
                onPressed: () {
                  for (final category in selectedCategories) {
                    onCategoryChanged?.call(category, false);
                  }
                },
                child: const Text('Clear All'),
              ),
          ],
        ),
        
        const SizedBox(height: 12),
        
        // Chips
        CategoryChipList(
          categories: categories,
          selectedCategories: selectedCategories,
          onCategoryChanged: onCategoryChanged,
          multiSelect: true,
        ),
        
        // Selected Count
        if (selectedCategories.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            '${selectedCategories.length} category${selectedCategories.length == 1 ? '' : 'ies'} selected',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.textSecondaryColor,
            ),
          ),
        ],
      ],
    );
  }
}
