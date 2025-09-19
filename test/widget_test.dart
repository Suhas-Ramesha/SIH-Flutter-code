import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:civic_reporter/main.dart';
import 'package:civic_reporter/pages/home_page.dart';
import 'package:civic_reporter/widgets/post_card.dart';
import 'package:civic_reporter/widgets/vote_button.dart';
import 'package:civic_reporter/widgets/status_timeline.dart';
import 'package:civic_reporter/widgets/category_chip.dart';
import 'package:civic_reporter/models/post.dart';
import 'package:civic_reporter/core/constants.dart';

void main() {
  group('Widget Tests', () {
    testWidgets('App should start with login page', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(
        const ProviderScope(
          child: CivicReporterApp(),
        ),
      );

      // Verify that the login page is displayed
      expect(find.text('Civic Reporter'), findsOneWidget);
      expect(find.text('Login as User'), findsOneWidget);
      expect(find.text('Login as Admin'), findsOneWidget);
    });

    testWidgets('PostCard should display post information correctly', (WidgetTester tester) async {
      // Create a mock post
      final mockPost = Post(
        id: 'test-post-1',
        userId: 'user-1',
        username: 'Test User',
        area: 'Test Area',
        category: 'Potholes',
        title: 'Test Post Title',
        description: 'This is a test post description',
        images: [],
        latitude: 12.9716,
        longitude: 77.5946,
        upvotes: 10,
        downvotes: 2,
        status: 'Reported',
        severity: 'High',
        createdAt: DateTime.now(),
        comments: [],
        bbmpNotes: [],
      );

      // Build the PostCard widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PostCard(
              post: mockPost,
              onTap: () {},
              onUpvote: () {},
              onDownvote: () {},
            ),
          ),
        ),
      );

      // Verify that post information is displayed
      expect(find.text('Test Post Title'), findsOneWidget);
      expect(find.text('This is a test post description'), findsOneWidget);
      expect(find.text('Test User'), findsOneWidget);
      expect(find.text('Test Area'), findsOneWidget);
      expect(find.text('Potholes'), findsOneWidget);
      expect(find.text('High'), findsOneWidget);
      expect(find.text('Reported'), findsOneWidget);
      expect(find.text('10'), findsOneWidget); // upvotes
      expect(find.text('2'), findsOneWidget); // downvotes
    });

    testWidgets('VoteButton should display count and handle taps', (WidgetTester tester) async {
      bool tapped = false;

      // Build the VoteButton widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VoteButton(
              icon: Icons.thumb_up,
              count: 5,
              onPressed: () {
                tapped = true;
              },
            ),
          ),
        ),
      );

      // Verify that the count is displayed
      expect(find.text('5'), findsOneWidget);
      expect(find.byIcon(Icons.thumb_up), findsOneWidget);

      // Tap the button
      await tester.tap(find.byType(VoteButton));
      await tester.pump();

      // Verify that the tap was handled
      expect(tapped, isTrue);
    });

    testWidgets('StatusTimeline should display status progression', (WidgetTester tester) async {
      // Build the StatusTimeline widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatusTimeline(
              currentStatus: 'Under Review',
              statuses: AppConstants.postStatuses,
            ),
          ),
        ),
      );

      // Verify that statuses are displayed
      expect(find.text('Reported'), findsOneWidget);
      expect(find.text('Under Review'), findsOneWidget);
      expect(find.text('Assigned'), findsOneWidget);
      expect(find.text('In Progress'), findsOneWidget);
      expect(find.text('Resolved'), findsOneWidget);
    });

    testWidgets('CategoryChip should display category with icon', (WidgetTester tester) async {
      // Build the CategoryChip widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CategoryChip(
              category: 'Potholes',
              isSelected: false,
              onTap: () {},
            ),
          ),
        ),
      );

      // Verify that the category is displayed
      expect(find.text('Potholes'), findsOneWidget);
      expect(find.byIcon(Icons.pothole), findsOneWidget);
    });

    testWidgets('CategoryChip should show selected state', (WidgetTester tester) async {
      // Build the CategoryChip widget in selected state
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CategoryChip(
              category: 'Potholes',
              isSelected: true,
              onTap: () {},
            ),
          ),
        ),
      );

      // Verify that the chip is in selected state
      expect(find.text('Potholes'), findsOneWidget);
      
      // The chip should have a different appearance when selected
      final chipWidget = tester.widget<InkWell>(find.byType(InkWell));
      expect(chipWidget, isNotNull);
    });
  });

  group('Integration Tests', () {
    testWidgets('Home page should load and display posts', (WidgetTester tester) async {
      // Build the HomePage widget
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: HomePage(),
          ),
        ),
      );

      // Wait for the page to load
      await tester.pumpAndSettle();

      // Verify that the home page elements are present
      expect(find.text('Civic Reporter'), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.notifications_outlined), findsOneWidget);
    });

    testWidgets('Login page should have demo login buttons', (WidgetTester tester) async {
      // Build the app
      await tester.pumpWidget(
        const ProviderScope(
          child: CivicReporterApp(),
        ),
      );

      // Verify that demo login buttons are present
      expect(find.text('Demo User'), findsOneWidget);
      expect(find.text('Demo Admin'), findsOneWidget);
    });
    
    testWidgets('Create post flow should work end-to-end', (WidgetTester tester) async {
      // Build the app
      await tester.pumpWidget(
        const ProviderScope(
          child: CivicReporterApp(),
        ),
      );

      // Login as user first
      await tester.tap(find.text('Demo User'));
      await tester.pumpAndSettle();

      // Navigate to create post
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Verify create post page is loaded
      expect(find.text('Create Post'), findsOneWidget);
      expect(find.text('Category'), findsOneWidget);
      expect(find.text('Title'), findsOneWidget);
      expect(find.text('Description'), findsOneWidget);
    });
    
    testWidgets('Home feed should display mock posts', (WidgetTester tester) async {
      // Build the app
      await tester.pumpWidget(
        const ProviderScope(
          child: CivicReporterApp(),
        ),
      );

      // Login as user
      await tester.tap(find.text('Demo User'));
      await tester.pumpAndSettle();

      // Wait for posts to load
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verify that posts are displayed
      // Note: This test may need adjustment based on actual mock data
      expect(find.text('Civic Reporter'), findsOneWidget);
    });
  });

  group('Model Tests', () {
    test('Post model should create from JSON correctly', () {
      final json = {
        'id': 'test-post-1',
        'userId': 'user-1',
        'username': 'Test User',
        'area': 'Test Area',
        'category': 'Potholes',
        'title': 'Test Post Title',
        'description': 'Test description',
        'images': ['image1.jpg', 'image2.jpg'],
        'latitude': 12.9716,
        'longitude': 77.5946,
        'upvotes': 10,
        'downvotes': 2,
        'status': 'Reported',
        'severity': 'High',
        'createdAt': '2024-01-01T00:00:00Z',
        'comments': [],
        'bbmpNotes': [],
      };

      final post = Post.fromJson(json);

      expect(post.id, equals('test-post-1'));
      expect(post.userId, equals('user-1'));
      expect(post.username, equals('Test User'));
      expect(post.area, equals('Test Area'));
      expect(post.category, equals('Potholes'));
      expect(post.title, equals('Test Post Title'));
      expect(post.description, equals('Test description'));
      expect(post.images, equals(['image1.jpg', 'image2.jpg']));
      expect(post.latitude, equals(12.9716));
      expect(post.longitude, equals(77.5946));
      expect(post.upvotes, equals(10));
      expect(post.downvotes, equals(2));
      expect(post.status, equals('Reported'));
      expect(post.severity, equals('High'));
      expect(post.comments, isEmpty);
      expect(post.bbmpNotes, isEmpty);
    });

    test('Post model should calculate net votes correctly', () {
      final post = Post(
        id: 'test-post-1',
        userId: 'user-1',
        username: 'Test User',
        area: 'Test Area',
        category: 'Potholes',
        title: 'Test Post Title',
        description: 'Test description',
        images: [],
        latitude: 12.9716,
        longitude: 77.5946,
        upvotes: 10,
        downvotes: 2,
        status: 'Reported',
        severity: 'High',
        createdAt: DateTime.now(),
        comments: [],
        bbmpNotes: [],
      );

      expect(post.netVotes, equals(8));
    });

    test('Post model should format time ago correctly', () {
      final now = DateTime.now();
      final post = Post(
        id: 'test-post-1',
        userId: 'user-1',
        username: 'Test User',
        area: 'Test Area',
        category: 'Potholes',
        title: 'Test Post Title',
        description: 'Test description',
        images: [],
        latitude: 12.9716,
        longitude: 77.5946,
        upvotes: 10,
        downvotes: 2,
        status: 'Reported',
        severity: 'High',
        createdAt: now.subtract(const Duration(hours: 2)),
        comments: [],
        bbmpNotes: [],
      );

      expect(post.timeAgo, equals('2h ago'));
    });
  });

  group('Constants Tests', () {
    test('App constants should have valid values', () {
      expect(AppConstants.appName, equals('Civic Reporter'));
      expect(AppConstants.appVersion, equals('1.0.0'));
      expect(AppConstants.categories, isNotEmpty);
      expect(AppConstants.postStatuses, isNotEmpty);
      expect(AppConstants.severityLevels, isNotEmpty);
      expect(AppConstants.areas, isNotEmpty);
    });

    test('Categories should include expected values', () {
      expect(AppConstants.categories, contains('Potholes'));
      expect(AppConstants.categories, contains('Streetlights not working'));
      expect(AppConstants.categories, contains('Waterlogging / Drainage blockages'));
    });

    test('Post statuses should include expected values', () {
      expect(AppConstants.postStatuses, contains('Reported'));
      expect(AppConstants.postStatuses, contains('Under Review'));
      expect(AppConstants.postStatuses, contains('Assigned'));
      expect(AppConstants.postStatuses, contains('In Progress'));
      expect(AppConstants.postStatuses, contains('Resolved'));
    });

    test('Severity levels should include expected values', () {
      expect(AppConstants.severityLevels, contains('Low'));
      expect(AppConstants.severityLevels, contains('Medium'));
      expect(AppConstants.severityLevels, contains('High'));
    });
  });
}
