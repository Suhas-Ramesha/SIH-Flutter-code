import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../core/env.dart';

/// WebSocket event types
enum WebSocketEventType {
  postCreated,
  statusChanged,
  newMessage,
  userTyping,
  postUpdated,
  commentAdded,
  voteChanged,
  connectionEstablished,
  connectionLost,
  error,
}

/// WebSocket event model
class WebSocketEvent {
  final WebSocketEventType type;
  final Map<String, dynamic> data;
  final DateTime timestamp;
  
  const WebSocketEvent({
    required this.type,
    required this.data,
    required this.timestamp,
  });
  
  factory WebSocketEvent.fromJson(Map<String, dynamic> json) {
    return WebSocketEvent(
      type: WebSocketEventType.values.firstWhere(
        (type) => type.name == json['type'],
        orElse: () => WebSocketEventType.error,
      ),
      data: json['data'] as Map<String, dynamic>,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'data': data,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

/// Abstract WebSocket service interface
abstract class WebSocketService {
  Stream<WebSocketEvent> get eventStream;
  bool get isConnected;
  
  Future<void> connect();
  Future<void> disconnect();
  Future<void> subscribe(String channel);
  Future<void> unsubscribe(String channel);
  Future<void> sendMessage(String message);
  
  // Event subscription methods
  Stream<Map<String, dynamic>> subscribeToPostEvents();
  Stream<Map<String, dynamic>> subscribeToMessageEvents();
  Stream<Map<String, dynamic>> subscribeToStatusEvents();
}

/// Mock WebSocket service for development
class MockWebSocketService implements WebSocketService {
  final StreamController<WebSocketEvent> _eventController = StreamController<WebSocketEvent>.broadcast();
  Timer? _mockEventTimer;
  bool _isConnected = false;
  
  @override
  Stream<WebSocketEvent> get eventStream => _eventController.stream;
  
  @override
  bool get isConnected => _isConnected;
  
  @override
  Future<void> connect() async {
    if (_isConnected) return;
    
    // Simulate connection delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    _isConnected = true;
    
    // Emit connection established event
    _eventController.add(WebSocketEvent(
      type: WebSocketEventType.connectionEstablished,
      data: {'message': 'Connected to mock WebSocket'},
      timestamp: DateTime.now(),
    ));
    
    // Start emitting mock events
    _startMockEvents();
  }
  
  @override
  Future<void> disconnect() async {
    if (!_isConnected) return;
    
    _isConnected = false;
    _mockEventTimer?.cancel();
    
    // Emit connection lost event
    _eventController.add(WebSocketEvent(
      type: WebSocketEventType.connectionLost,
      data: {'message': 'Disconnected from mock WebSocket'},
      timestamp: DateTime.now(),
    ));
  }
  
  @override
  Future<void> subscribe(String channel) async {
    // Mock subscription
    await Future.delayed(const Duration(milliseconds: 100));
  }
  
  @override
  Future<void> unsubscribe(String channel) async {
    // Mock unsubscription
    await Future.delayed(const Duration(milliseconds: 100));
  }
  
  @override
  Future<void> sendMessage(String message) async {
    if (!_isConnected) {
      throw Exception('WebSocket not connected');
    }
    
    // Mock sending message
    await Future.delayed(const Duration(milliseconds: 200));
  }
  
  void _startMockEvents() {
    _mockEventTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (!_isConnected) {
        timer.cancel();
        return;
      }
      
      // Emit random mock events
      final random = DateTime.now().millisecondsSinceEpoch % 4;
      
      switch (random) {
        case 0:
          _emitPostCreatedEvent();
          break;
        case 1:
          _emitStatusChangedEvent();
          break;
        case 2:
          _emitNewMessageEvent();
          break;
        case 3:
          _emitUserTypingEvent();
          break;
      }
    });
  }
  
  void _emitPostCreatedEvent() {
    _eventController.add(WebSocketEvent(
      type: WebSocketEventType.postCreated,
      data: {
        'postId': 'p${DateTime.now().millisecondsSinceEpoch}',
        'title': 'New report: Streetlight not working',
        'category': 'Streetlights not working',
        'area': 'Koramangala',
        'severity': 'Medium',
        'username': 'New User',
        'createdAt': DateTime.now().toIso8601String(),
      },
      timestamp: DateTime.now(),
    ));
  }
  
  void _emitStatusChangedEvent() {
    _eventController.add(WebSocketEvent(
      type: WebSocketEventType.statusChanged,
      data: {
        'postId': 'p1',
        'oldStatus': 'Reported',
        'newStatus': 'Under Review',
        'adminName': 'Admin',
        'note': 'Report is being reviewed by our team',
        'updatedAt': DateTime.now().toIso8601String(),
      },
      timestamp: DateTime.now(),
    ));
  }
  
  void _emitNewMessageEvent() {
    _eventController.add(WebSocketEvent(
      type: WebSocketEventType.newMessage,
      data: {
        'conversationId': 'conv1',
        'messageId': 'msg${DateTime.now().millisecondsSinceEpoch}',
        'senderId': 'admin1',
        'senderName': 'Admin',
        'text': 'Thank you for your report. We are working on it.',
        'isFromAdmin': true,
        'timestamp': DateTime.now().toIso8601String(),
      },
      timestamp: DateTime.now(),
    ));
  }
  
  void _emitUserTypingEvent() {
    _eventController.add(WebSocketEvent(
      type: WebSocketEventType.userTyping,
      data: {
        'conversationId': 'conv1',
        'userId': 'u1',
        'username': 'Test User',
        'isTyping': true,
      },
      timestamp: DateTime.now(),
    ));
  }
  
  @override
  Stream<Map<String, dynamic>> subscribeToPostEvents() async* {
    // Mock post events
    while (_isConnected) {
      await Future.delayed(const Duration(seconds: 45));
      
      yield {
        'type': 'post_created',
        'data': {
          'postId': 'p${DateTime.now().millisecondsSinceEpoch}',
          'title': 'New report: ${_getRandomCategory()}',
          'category': _getRandomCategory(),
          'area': _getRandomArea(),
          'severity': _getRandomSeverity(),
          'username': 'New User',
          'createdAt': DateTime.now().toIso8601String(),
        },
      };
    }
  }
  
  @override
  Stream<Map<String, dynamic>> subscribeToMessageEvents() async* {
    // Mock message events
    while (_isConnected) {
      await Future.delayed(const Duration(seconds: 60));
      
      yield {
        'type': 'new_message',
        'data': {
          'conversationId': 'conv${DateTime.now().millisecondsSinceEpoch % 3 + 1}',
          'messageId': 'msg${DateTime.now().millisecondsSinceEpoch}',
          'senderId': 'admin1',
          'senderName': 'Admin',
          'text': 'Thank you for your report. We are working on it.',
          'isFromAdmin': true,
          'timestamp': DateTime.now().toIso8601String(),
        },
      };
    }
  }
  
  @override
  Stream<Map<String, dynamic>> subscribeToStatusEvents() async* {
    // Mock status change events
    while (_isConnected) {
      await Future.delayed(const Duration(seconds: 90));
      
      yield {
        'type': 'status_changed',
        'data': {
          'postId': 'p${DateTime.now().millisecondsSinceEpoch % 8 + 1}',
          'oldStatus': 'Reported',
          'newStatus': 'Under Review',
          'adminName': 'Admin',
          'note': 'Report is being reviewed by our team',
          'updatedAt': DateTime.now().toIso8601String(),
        },
      };
    }
  }
  
  String _getRandomCategory() {
    final categories = [
      'Potholes',
      'Streetlights not working',
      'Waterlogging / Drainage blockages',
      'Trash / Illegal dumping',
      'Sidewalk / Footpath damage',
    ];
    return categories[DateTime.now().millisecondsSinceEpoch % categories.length];
  }
  
  String _getRandomArea() {
    final areas = [
      'Koramangala 4th Block',
      'Jayanagar',
      'Malleshwaram',
      'HSR Layout',
      'Indiranagar',
    ];
    return areas[DateTime.now().millisecondsSinceEpoch % areas.length];
  }
  
  String _getRandomSeverity() {
    final severities = ['Low', 'Medium', 'High'];
    return severities[DateTime.now().millisecondsSinceEpoch % severities.length];
  }
  
  void dispose() {
    _mockEventTimer?.cancel();
    _eventController.close();
  }
}

/// Real WebSocket service for production
/// 
/// TODO: Implement when connecting to real WebSocket server
class RealWebSocketService implements WebSocketService {
  WebSocketChannel? _channel;
  final StreamController<WebSocketEvent> _eventController = StreamController<WebSocketEvent>.broadcast();
  bool _isConnected = false;
  String? _authToken;
  final Set<String> _subscribedChannels = {};
  
  @override
  Stream<WebSocketEvent> get eventStream => _eventController.stream;
  
  @override
  bool get isConnected => _isConnected;
  
  void setAuthToken(String token) {
    _authToken = token;
  }
  
  @override
  Future<void> connect() async {
    if (_isConnected) return;
    
    try {
      // TODO: Implement real WebSocket connection
      final wsUrl = Env.effectiveWsUrl;
      
      // Add auth token to WebSocket URL or headers
      final uri = Uri.parse(wsUrl);
      
      _channel = WebSocketChannel.connect(uri);
      
      // Listen to incoming messages
      _channel!.stream.listen(
        (data) {
          try {
            final json = jsonDecode(data as String);
            final event = WebSocketEvent.fromJson(json);
            _eventController.add(event);
          } catch (e) {
            _eventController.add(WebSocketEvent(
              type: WebSocketEventType.error,
              data: {'error': 'Failed to parse WebSocket message: $e'},
              timestamp: DateTime.now(),
            ));
          }
        },
        onError: (error) {
          _eventController.add(WebSocketEvent(
            type: WebSocketEventType.error,
            data: {'error': 'WebSocket error: $error'},
            timestamp: DateTime.now(),
          ));
        },
        onDone: () {
          _isConnected = false;
          _eventController.add(WebSocketEvent(
            type: WebSocketEventType.connectionLost,
            data: {'message': 'WebSocket connection closed'},
            timestamp: DateTime.now(),
          ));
        },
      );
      
      _isConnected = true;
      
      // Emit connection established event
      _eventController.add(WebSocketEvent(
        type: WebSocketEventType.connectionEstablished,
        data: {'message': 'Connected to WebSocket server'},
        timestamp: DateTime.now(),
      ));
      
      // Re-subscribe to channels
      for (final channel in _subscribedChannels) {
        await subscribe(channel);
      }
      
    } catch (e) {
      _eventController.add(WebSocketEvent(
        type: WebSocketEventType.error,
        data: {'error': 'Failed to connect to WebSocket: $e'},
        timestamp: DateTime.now(),
      ));
      throw Exception('Failed to connect to WebSocket: $e');
    }
  }
  
  @override
  Future<void> disconnect() async {
    if (!_isConnected) return;
    
    try {
      await _channel?.sink.close();
      _isConnected = false;
      
      _eventController.add(WebSocketEvent(
        type: WebSocketEventType.connectionLost,
        data: {'message': 'Disconnected from WebSocket server'},
        timestamp: DateTime.now(),
      ));
    } catch (e) {
      _eventController.add(WebSocketEvent(
        type: WebSocketEventType.error,
        data: {'error': 'Error disconnecting from WebSocket: $e'},
        timestamp: DateTime.now(),
      ));
    }
  }
  
  @override
  Future<void> subscribe(String channel) async {
    if (!_isConnected) {
      throw Exception('WebSocket not connected');
    }
    
    try {
      // TODO: Implement real subscription logic
      final message = {
        'type': 'subscribe',
        'channel': channel,
        'timestamp': DateTime.now().toIso8601String(),
      };
      
      _channel?.sink.add(jsonEncode(message));
      _subscribedChannels.add(channel);
      
    } catch (e) {
      throw Exception('Failed to subscribe to channel $channel: $e');
    }
  }
  
  @override
  Future<void> unsubscribe(String channel) async {
    if (!_isConnected) {
      throw Exception('WebSocket not connected');
    }
    
    try {
      // TODO: Implement real unsubscription logic
      final message = {
        'type': 'unsubscribe',
        'channel': channel,
        'timestamp': DateTime.now().toIso8601String(),
      };
      
      _channel?.sink.add(jsonEncode(message));
      _subscribedChannels.remove(channel);
      
    } catch (e) {
      throw Exception('Failed to unsubscribe from channel $channel: $e');
    }
  }
  
  @override
  Future<void> sendMessage(String message) async {
    if (!_isConnected) {
      throw Exception('WebSocket not connected');
    }
    
    try {
      _channel?.sink.add(message);
    } catch (e) {
      throw Exception('Failed to send WebSocket message: $e');
    }
  }
  
  @override
  Stream<Map<String, dynamic>> subscribeToPostEvents() async* {
    // TODO: Implement real post event subscription
    // This should filter WebSocket events for post-related events
    throw UnimplementedError('Post events not implemented in RealWebSocketService');
  }
  
  @override
  Stream<Map<String, dynamic>> subscribeToMessageEvents() async* {
    // TODO: Implement real message event subscription
    // This should filter WebSocket events for message-related events
    throw UnimplementedError('Message events not implemented in RealWebSocketService');
  }
  
  @override
  Stream<Map<String, dynamic>> subscribeToStatusEvents() async* {
    // TODO: Implement real status event subscription
    // This should filter WebSocket events for status-related events
    throw UnimplementedError('Status events not implemented in RealWebSocketService');
  }
  
  void dispose() {
    _channel?.sink.close();
    _eventController.close();
  }
}

/// WebSocket service factory
class WebSocketServiceFactory {
  static WebSocketService create() {
    if (Env.shouldUseRealWebSocket) {
      return RealWebSocketService();
    } else {
      return MockWebSocketService();
    }
  }
}
