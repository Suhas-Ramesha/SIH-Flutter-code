import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/post.dart';
import '../services/api_service.dart';
import '../core/mock_data.dart';
import 'auth_provider.dart';

/// Map marker model
class MapMarker {
  final String id;
  final String postId;
  final double latitude;
  final double longitude;
  final String title;
  final String category;
  final String severity;
  final String status;
  final int upvotes;
  final String? description;
  final List<String> images;
  
  const MapMarker({
    required this.id,
    required this.postId,
    required this.latitude,
    required this.longitude,
    required this.title,
    required this.category,
    required this.severity,
    required this.status,
    required this.upvotes,
    this.description,
    required this.images,
  });
  
  factory MapMarker.fromJson(Map<String, dynamic> json) {
    return MapMarker(
      id: json['id'] as String,
      postId: json['postId'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      title: json['title'] as String,
      category: json['category'] as String,
      severity: json['severity'] as String,
      status: json['status'] as String,
      upvotes: json['upvotes'] as int,
      description: json['description'] as String?,
      images: List<String>.from(json['images'] as List? ?? []),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'postId': postId,
      'latitude': latitude,
      'longitude': longitude,
      'title': title,
      'category': category,
      'severity': severity,
      'status': status,
      'upvotes': upvotes,
      'description': description,
      'images': images,
    };
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MapMarker && other.id == id;
  }
  
  @override
  int get hashCode => id.hashCode;
}

/// Map state
class MapState {
  final List<MapMarker> markers;
  final bool isLoading;
  final String? error;
  final double? userLatitude;
  final double? userLongitude;
  final String? selectedArea;
  final String? selectedCategory;
  final MapMarker? selectedMarker;
  final bool showClusters;
  final bool showHeatmap;
  
  const MapState({
    this.markers = const [],
    this.isLoading = false,
    this.error,
    this.userLatitude,
    this.userLongitude,
    this.selectedArea,
    this.selectedCategory,
    this.selectedMarker,
    this.showClusters = true,
    this.showHeatmap = false,
  });
  
  MapState copyWith({
    List<MapMarker>? markers,
    bool? isLoading,
    String? error,
    double? userLatitude,
    double? userLongitude,
    String? selectedArea,
    String? selectedCategory,
    MapMarker? selectedMarker,
    bool? showClusters,
    bool? showHeatmap,
  }) {
    return MapState(
      markers: markers ?? this.markers,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      userLatitude: userLatitude ?? this.userLatitude,
      userLongitude: userLongitude ?? this.userLongitude,
      selectedArea: selectedArea ?? this.selectedArea,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedMarker: selectedMarker ?? this.selectedMarker,
      showClusters: showClusters ?? this.showClusters,
      showHeatmap: showHeatmap ?? this.showHeatmap,
    );
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MapState &&
        other.markers == markers &&
        other.isLoading == isLoading &&
        other.error == error &&
        other.userLatitude == userLatitude &&
        other.userLongitude == userLongitude &&
        other.selectedArea == selectedArea &&
        other.selectedCategory == selectedCategory &&
        other.selectedMarker == selectedMarker &&
        other.showClusters == showClusters &&
        other.showHeatmap == showHeatmap;
  }
  
  @override
  int get hashCode {
    return Object.hash(
      markers,
      isLoading,
      error,
      userLatitude,
      userLongitude,
      selectedArea,
      selectedCategory,
      selectedMarker,
      showClusters,
      showHeatmap,
    );
  }
}

/// Map notifier
class MapNotifier extends StateNotifier<MapState> {
  final ApiService _apiService;
  
  MapNotifier(this._apiService) : super(const MapState()) {
    _initializeMap();
  }
  
  /// Initialize map with default data
  Future<void> _initializeMap() async {
    await fetchMarkers();
  }
  
  /// Fetch map markers
  Future<void> fetchMarkers({String? area, String? category}) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final filters = PostFilters(
        area: area ?? state.selectedArea,
        category: category ?? state.selectedCategory,
      );
      
      final markersData = await _apiService.fetchMapMarkers(filters);
      
      final markers = markersData.map((data) => MapMarker.fromJson(data)).toList();
      
      state = state.copyWith(
        markers: markers,
        isLoading: false,
        selectedArea: area ?? state.selectedArea,
        selectedCategory: category ?? state.selectedCategory,
        error: null,
      );
      
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
  
  /// Refresh markers
  Future<void> refreshMarkers() async {
    await fetchMarkers();
  }
  
  /// Filter markers by area
  Future<void> filterByArea(String? area) async {
    await fetchMarkers(area: area);
  }
  
  /// Filter markers by category
  Future<void> filterByCategory(String? category) async {
    await fetchMarkers(category: category);
  }
  
  /// Clear filters
  Future<void> clearFilters() async {
    await fetchMarkers(area: null, category: null);
  }
  
  /// Update user location
  void updateUserLocation(double latitude, double longitude) {
    state = state.copyWith(
      userLatitude: latitude,
      userLongitude: longitude,
    );
  }
  
  /// Select a marker
  void selectMarker(MapMarker? marker) {
    state = state.copyWith(selectedMarker: marker);
  }
  
  /// Toggle clusters
  void toggleClusters() {
    state = state.copyWith(showClusters: !state.showClusters);
  }
  
  /// Toggle heatmap
  void toggleHeatmap() {
    state = state.copyWith(showHeatmap: !state.showHeatmap);
  }
  
  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }
  
  /// Get markers by severity
  List<MapMarker> getMarkersBySeverity(String severity) {
    return state.markers.where((marker) => marker.severity == severity).toList();
  }
  
  /// Get markers by status
  List<MapMarker> getMarkersByStatus(String status) {
    return state.markers.where((marker) => marker.status == status).toList();
  }
  
  /// Get markers by category
  List<MapMarker> getMarkersByCategory(String category) {
    return state.markers.where((marker) => marker.category == category).toList();
  }
  
  /// Get markers near location
  List<MapMarker> getMarkersNearLocation(double latitude, double longitude, double radiusKm) {
    if (state.markers.isEmpty) return [];
    
    return state.markers.where((marker) {
      final distance = _calculateDistance(
        latitude,
        longitude,
        marker.latitude,
        marker.longitude,
      );
      return distance <= radiusKm;
    }).toList();
  }
  
  /// Calculate distance between two points in kilometers
  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371; // Earth's radius in kilometers
    
    final dLat = _degreesToRadians(lat2 - lat1);
    final dLon = _degreesToRadians(lon2 - lon1);
    
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2);
    
    final c = 2 * asin(sqrt(a));
    
    return earthRadius * c;
  }
  
  double _degreesToRadians(double degrees) {
    return degrees * (3.14159265359 / 180);
  }
  
  /// Get marker statistics
  Map<String, int> getMarkerStatistics() {
    final stats = <String, int>{};
    
    // Count by category
    for (final marker in state.markers) {
      stats[marker.category] = (stats[marker.category] ?? 0) + 1;
    }
    
    return stats;
  }
  
  /// Get severity statistics
  Map<String, int> getSeverityStatistics() {
    final stats = <String, int>{};
    
    // Count by severity
    for (final marker in state.markers) {
      stats[marker.severity] = (stats[marker.severity] ?? 0) + 1;
    }
    
    return stats;
  }
  
  /// Get status statistics
  Map<String, int> getStatusStatistics() {
    final stats = <String, int>{};
    
    // Count by status
    for (final marker in state.markers) {
      stats[marker.status] = (stats[marker.status] ?? 0) + 1;
    }
    
    return stats;
  }
}

/// Map provider
final mapProvider = StateNotifierProvider<MapNotifier, MapState>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return MapNotifier(apiService);
});

/// Map markers provider
final mapMarkersProvider = Provider<List<MapMarker>>((ref) {
  final mapState = ref.watch(mapProvider);
  return mapState.markers;
});

/// Map loading state provider
final mapLoadingProvider = Provider<bool>((ref) {
  final mapState = ref.watch(mapProvider);
  return mapState.isLoading;
});

/// Map error provider
final mapErrorProvider = Provider<String?>((ref) {
  final mapState = ref.watch(mapProvider);
  return mapState.error;
});

/// Selected marker provider
final selectedMarkerProvider = Provider<MapMarker?>((ref) {
  final mapState = ref.watch(mapProvider);
  return mapState.selectedMarker;
});

/// User location provider
final userLocationProvider = Provider<Map<String, double>?>((ref) {
  final mapState = ref.watch(mapProvider);
  if (mapState.userLatitude != null && mapState.userLongitude != null) {
    return {
      'latitude': mapState.userLatitude!,
      'longitude': mapState.userLongitude!,
    };
  }
  return null;
});

/// Map statistics provider
final mapStatisticsProvider = Provider<Map<String, Map<String, int>>>((ref) {
  final mapNotifier = ref.watch(mapProvider.notifier);
  
  return {
    'category': mapNotifier.getMarkerStatistics(),
    'severity': mapNotifier.getSeverityStatistics(),
    'status': mapNotifier.getStatusStatistics(),
  };
});

/// Markers by severity provider
final markersBySeverityProvider = Provider.family<List<MapMarker>, String>((ref, severity) {
  final mapNotifier = ref.watch(mapProvider.notifier);
  return mapNotifier.getMarkersBySeverity(severity);
});

/// Markers by status provider
final markersByStatusProvider = Provider.family<List<MapMarker>, String>((ref, status) {
  final mapNotifier = ref.watch(mapProvider.notifier);
  return mapNotifier.getMarkersByStatus(status);
});

/// Markers by category provider
final markersByCategoryProvider = Provider.family<List<MapMarker>, String>((ref, category) {
  final mapNotifier = ref.watch(mapProvider.notifier);
  return mapNotifier.getMarkersByCategory(category);
});

/// Markers near location provider
final markersNearLocationProvider = Provider.family<List<MapMarker>, Map<String, double>>((ref, location) {
  final mapNotifier = ref.watch(mapProvider.notifier);
  final latitude = location['latitude']!;
  final longitude = location['longitude']!;
  const radiusKm = 5.0; // 5km radius
  
  return mapNotifier.getMarkersNearLocation(latitude, longitude, radiusKm);
});
