import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/map_provider.dart';
import '../widgets/map_marker_sheet.dart';
import '../core/theme.dart';
import '../core/constants.dart';
import '../core/env.dart';

class MapsPage extends ConsumerStatefulWidget {
  const MapsPage({super.key});
  
  @override
  ConsumerState<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends ConsumerState<MapsPage> {
  @override
  void initState() {
    super.initState();
    // Load map markers
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(mapProvider.notifier).fetchMarkers();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final mapState = ref.watch(mapProvider);
    final mapNotifier = ref.read(mapProvider.notifier);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Maps'),
        actions: [
          IconButton(
            icon: Icon(mapState.showClusters ? Icons.layers : Icons.layers_outlined),
            onPressed: () => mapNotifier.toggleClusters(),
            tooltip: 'Toggle Clusters',
          ),
          IconButton(
            icon: Icon(mapState.showHeatmap ? Icons.whatshot : Icons.whatshot_outlined),
            onPressed: () => mapNotifier.toggleHeatmap(),
            tooltip: 'Toggle Heatmap',
          ),
          PopupMenuButton<String>(
            onSelected: (value) => _handleFilterAction(value),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'area',
                child: Text('Filter by Area'),
              ),
              const PopupMenuItem(
                value: 'category',
                child: Text('Filter by Category'),
              ),
              const PopupMenuItem(
                value: 'severity',
                child: Text('Filter by Severity'),
              ),
              const PopupMenuItem(
                value: 'clear',
                child: Text('Clear Filters'),
              ),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          // Map View
          _buildMapView(mapState),
          
          // Loading Overlay
          if (mapState.isLoading)
            Container(
              color: Colors.black26,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          
          // Error Overlay
          if (mapState.error != null)
            Container(
              color: Colors.black26,
              child: Center(
                child: Container(
                  margin: const EdgeInsets.all(32),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 48,
                        color: AppTheme.errorColor,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Failed to load map',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        mapState.error!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textSecondaryColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => ref.read(mapProvider.notifier).refreshMarkers(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          
          // Map Controls
          _buildMapControls(mapState),
          
          // Statistics Panel
          _buildStatisticsPanel(mapState),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }
  
  Widget _buildMapView(MapState mapState) {
    if (Env.isMapsEnabled) {
      // TODO: Implement Google Maps or Flutter Map
      return _buildMockMapView(mapState);
    } else {
      return _buildMockMapView(mapState);
    }
  }
  
  Widget _buildMockMapView(MapState mapState) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF4CAF50),
            Color(0xFF8BC34A),
            Color(0xFFCDDC39),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Mock map background
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.map,
                  size: 64,
                  color: Colors.white,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Map View',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${mapState.markers.length} markers loaded',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
                if (!Env.isMapsEnabled) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Mock Map - Set MAPS_API_KEY to enable real maps',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          // Mock markers
          ...mapState.markers.map((marker) => _buildMockMarker(marker)),
        ],
      ),
    );
  }
  
  Widget _buildMockMarker(marker) {
    final severityColor = AppTheme.getSeverityColor(marker.severity);
    final statusColor = AppTheme.getStatusColor(marker.status);
    
    return Positioned(
      left: (marker.latitude - 12.9) * 1000 + 50, // Mock positioning
      top: (marker.longitude - 77.5) * 1000 + 100, // Mock positioning
      child: GestureDetector(
        onTap: () => _showMarkerDetails(marker),
        child: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: severityColor,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: statusColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildMapControls(MapState mapState) {
    return Positioned(
      top: 16,
      right: 16,
      child: Column(
        children: [
          // My Location Button
          FloatingActionButton.small(
            onPressed: _getCurrentLocation,
            backgroundColor: Colors.white,
            child: const Icon(Icons.my_location, color: AppTheme.primaryColor),
          ),
          const SizedBox(height: 8),
          
          // Refresh Button
          FloatingActionButton.small(
            onPressed: () => ref.read(mapProvider.notifier).refreshMarkers(),
            backgroundColor: Colors.white,
            child: const Icon(Icons.refresh, color: AppTheme.primaryColor),
          ),
        ],
      ),
    );
  }
  
  Widget _buildStatisticsPanel(MapState mapState) {
    return Positioned(
      bottom: 16,
      left: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Statistics',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Total',
                    mapState.markers.length.toString(),
                    AppTheme.primaryColor,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'High',
                    mapState.markers.where((m) => m.severity == 'High').length.toString(),
                    AppTheme.highSeverityColor,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Medium',
                    mapState.markers.where((m) => m.severity == 'Medium').length.toString(),
                    AppTheme.mediumSeverityColor,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Low',
                    mapState.markers.where((m) => m.severity == 'Low').length.toString(),
                    AppTheme.lowSeverityColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppTheme.textSecondaryColor,
          ),
        ),
      ],
    );
  }
  
  Widget _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: 1, // Maps is selected
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
            // Already on maps
            break;
          case 2:
            context.push('/create-post');
            break;
          case 3:
            context.push('/my-posts');
            break;
          case 4:
            context.push('/inbox');
            break;
        }
      },
    );
  }
  
  void _handleFilterAction(String action) {
    switch (action) {
      case 'area':
        _showAreaFilter();
        break;
      case 'category':
        _showCategoryFilter();
        break;
      case 'severity':
        _showSeverityFilter();
        break;
      case 'clear':
        ref.read(mapProvider.notifier).clearFilters();
        break;
    }
  }
  
  void _showAreaFilter() {
    showModalBottomSheet(
      context: context,
      builder: (context) => _buildFilterBottomSheet(
        'Filter by Area',
        AppConstants.areas,
        (area) => ref.read(mapProvider.notifier).filterByArea(area),
      ),
    );
  }
  
  void _showCategoryFilter() {
    showModalBottomSheet(
      context: context,
      builder: (context) => _buildFilterBottomSheet(
        'Filter by Category',
        AppConstants.categories,
        (category) => ref.read(mapProvider.notifier).filterByCategory(category),
      ),
    );
  }
  
  void _showSeverityFilter() {
    showModalBottomSheet(
      context: context,
      builder: (context) => _buildFilterBottomSheet(
        'Filter by Severity',
        AppConstants.severityLevels,
        (severity) {
          // TODO: Implement severity filtering
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Filtering by $severity')),
          );
        },
      ),
    );
  }
  
  Widget _buildFilterBottomSheet(String title, List<String> items, Function(String) onSelected) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ...items.map((item) => ListTile(
            title: Text(item),
            onTap: () {
              Navigator.pop(context);
              onSelected(item);
            },
          )),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(mapProvider.notifier).clearFilters();
            },
            child: const Text('Clear Filters'),
          ),
        ],
      ),
    );
  }
  
  void _showMarkerDetails(marker) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => MapMarkerSheet(
        marker: marker,
        onOpenPost: () {
          Navigator.pop(context);
          context.push('/post/${marker.postId}');
        },
      ),
    );
  }
  
  void _getCurrentLocation() {
    // TODO: Implement real location service
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Getting current location...')),
    );
  }
}
