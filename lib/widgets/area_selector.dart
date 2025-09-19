import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/constants.dart';

class AreaSelector extends StatelessWidget {
  final String? selectedArea;
  final Function(String)? onAreaSelected;
  final bool showSearch;
  final String? hintText;
  
  const AreaSelector({
    super.key,
    this.selectedArea,
    this.onAreaSelected,
    this.showSearch = true,
    this.hintText,
  });
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Area',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        
        if (showSearch)
          _buildSearchField(),
        
        const SizedBox(height: 16),
        
        _buildAreaGrid(),
      ],
    );
  }
  
  Widget _buildSearchField() {
    return TextField(
      decoration: InputDecoration(
        hintText: hintText ?? 'Search areas...',
        prefixIcon: const Icon(Icons.search),
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      onChanged: (value) {
        // TODO: Implement search functionality
      },
    );
  }
  
  Widget _buildAreaGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 3,
      ),
      itemCount: AppConstants.areas.length,
      itemBuilder: (context, index) {
        final area = AppConstants.areas[index];
        final isSelected = selectedArea == area;
        
        return _buildAreaCard(area, isSelected);
      },
    );
  }
  
  Widget _buildAreaCard(String area, bool isSelected) {
    return InkWell(
      onTap: () => onAreaSelected?.call(area),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : AppTheme.borderColor,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.location_on,
              size: 16,
              color: isSelected ? Colors.white : AppTheme.primaryColor,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                area,
                style: TextStyle(
                  color: isSelected ? Colors.white : AppTheme.textPrimaryColor,
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                size: 16,
                color: Colors.white,
              ),
          ],
        ),
      ),
    );
  }
}

class AreaSelectorDialog extends StatefulWidget {
  final String? selectedArea;
  final Function(String)? onAreaSelected;
  
  const AreaSelectorDialog({
    super.key,
    this.selectedArea,
    this.onAreaSelected,
  });
  
  @override
  State<AreaSelectorDialog> createState() => _AreaSelectorDialogState();
}

class _AreaSelectorDialogState extends State<AreaSelectorDialog> {
  String? _selectedArea;
  String _searchQuery = '';
  
  @override
  void initState() {
    super.initState();
    _selectedArea = widget.selectedArea;
  }
  
  @override
  Widget build(BuildContext context) {
    final filteredAreas = AppConstants.areas.where((area) {
      return area.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
    
    return AlertDialog(
      title: const Text('Select Area'),
      content: SizedBox(
        width: double.maxFinite,
        height: 400,
        child: Column(
          children: [
            // Search Field
            TextField(
              decoration: const InputDecoration(
                hintText: 'Search areas...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
            
            const SizedBox(height: 16),
            
            // Areas List
            Expanded(
              child: ListView.builder(
                itemCount: filteredAreas.length,
                itemBuilder: (context, index) {
                  final area = filteredAreas[index];
                  final isSelected = _selectedArea == area;
                  
                  return ListTile(
                    leading: Icon(
                      Icons.location_on,
                      color: isSelected ? AppTheme.primaryColor : AppTheme.textSecondaryColor,
                    ),
                    title: Text(
                      area,
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        color: isSelected ? AppTheme.primaryColor : AppTheme.textPrimaryColor,
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check_circle, color: AppTheme.primaryColor)
                        : null,
                    onTap: () {
                      setState(() {
                        _selectedArea = area;
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _selectedArea != null
              ? () {
                  widget.onAreaSelected?.call(_selectedArea!);
                  Navigator.pop(context);
                }
              : null,
          child: const Text('Select'),
        ),
      ],
    );
  }
}

class AreaChip extends StatelessWidget {
  final String area;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;
  
  const AreaChip({
    super.key,
    required this.area,
    this.isSelected = false,
    this.onTap,
    this.onRemove,
  });
  
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : AppTheme.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppTheme.primaryColor,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.location_on,
              size: 16,
              color: AppTheme.primaryColor,
            ),
            const SizedBox(width: 6),
            Text(
              area,
              style: const TextStyle(
                color: AppTheme.primaryColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (onRemove != null) ...[
              const SizedBox(width: 6),
              GestureDetector(
                onTap: onRemove,
                child: const Icon(
                  Icons.close,
                  size: 16,
                  color: AppTheme.primaryColor,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class AreaChipList extends StatelessWidget {
  final List<String> areas;
  final List<String> selectedAreas;
  final Function(String, bool)? onAreaChanged;
  final bool multiSelect;
  final bool showRemoveButtons;
  
  const AreaChipList({
    super.key,
    required this.areas,
    this.selectedAreas = const [],
    this.onAreaChanged,
    this.multiSelect = true,
    this.showRemoveButtons = false,
  });
  
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: areas.map((area) {
        final isSelected = selectedAreas.contains(area);
        
        return AreaChip(
          area: area,
          isSelected: isSelected,
          onTap: onAreaChanged != null
              ? () => onAreaChanged!(area, !isSelected)
              : null,
          onRemove: showRemoveButtons && isSelected
              ? () => onAreaChanged?.call(area, false)
              : null,
        );
      }).toList(),
    );
  }
}
