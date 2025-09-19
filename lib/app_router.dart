import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';
import 'pages/post_detail_page.dart';
import 'pages/create_post_page.dart';
import 'pages/maps_page.dart';
import 'pages/my_posts_page.dart';
import 'pages/inbox_page.dart';
import 'pages/admin_dashboard_page.dart';
import 'providers/auth_provider.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);
  
  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final isAuthenticated = authState.isAuthenticated;
      final isLoggingIn = state.uri.path == '/login';
      
      // If not authenticated and not on login page, redirect to login
      if (!isAuthenticated && !isLoggingIn) {
        return '/login';
      }
      
      // If authenticated and on login page, redirect to home
      if (isAuthenticated && isLoggingIn) {
        return '/home';
      }
      
      // No redirect needed
      return null;
    },
    routes: [
      // Login Route
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      
      // Home Route
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      
      // Post Detail Route
      GoRoute(
        path: '/post/:id',
        name: 'post-detail',
        builder: (context, state) {
          final postId = state.pathParameters['id']!;
          return PostDetailPage(postId: postId);
        },
      ),
      
      // Create Post Route
      GoRoute(
        path: '/create-post',
        name: 'create-post',
        builder: (context, state) => const CreatePostPage(),
      ),
      
      // Maps Route
      GoRoute(
        path: '/maps',
        name: 'maps',
        builder: (context, state) => const MapsPage(),
      ),
      
      // My Posts Route
      GoRoute(
        path: '/my-posts',
        name: 'my-posts',
        builder: (context, state) => const MyPostsPage(),
      ),
      
      // Inbox Route
      GoRoute(
        path: '/inbox',
        name: 'inbox',
        builder: (context, state) => const InboxPage(),
      ),
      
      // Admin Dashboard Route
      GoRoute(
        path: '/admin-dashboard',
        name: 'admin-dashboard',
        builder: (context, state) => const AdminDashboardPage(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'The page you are looking for does not exist.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/home'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
});
