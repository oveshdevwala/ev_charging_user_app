/// File: lib/features/main_shell/ui/main_shell_page.dart
/// Purpose: Main navigation shell for user app with bottom navigation
/// Belongs To: main_shell feature
/// Route: Main shell wrapper for tab-based navigation
/// Customization Guide:
///    - Add/remove tabs by modifying _tabPages list
///    - Tab navigation uses IndexedStack for instant switching without transitions
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../routes/app_routes.dart';
import '../../bookings/bookings.dart';
import '../../favorites/favorites.dart';
import '../../home/home.dart';
import '../../profile/profile.dart';
import '../../search/search.dart';
import '../widgets/bottom_nav_bar.dart';

/// Main shell page with bottom navigation for user app.
/// Uses IndexedStack for instant tab switching without transitions.
class MainShellPage extends StatefulWidget {
  const MainShellPage({this.initialIndex = 0, super.key});

  /// Initial tab index when the shell is created
  final int initialIndex;

  @override
  State<MainShellPage> createState() => _MainShellPageState();
}

class _MainShellPageState extends State<MainShellPage> {
  /// Current selected tab index
  late int _currentIndex;

  /// Tab pages - created once and kept in memory
  final List<Widget> _tabPages = const [
    HomePage(),
    SearchPage(),
    FavoritesPage(),
    BookingsPage(),
    ProfilePage(),
  ];

  /// Route paths corresponding to each tab index
  static const List<AppRoutes> _tabRoutes = [
    AppRoutes.userHome,
    AppRoutes.userSearch,
    AppRoutes.userFavorites,
    AppRoutes.userBookings,
    AppRoutes.userProfile,
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  void didUpdateWidget(MainShellPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update index if navigated from deep link
    if (widget.initialIndex != oldWidget.initialIndex) {
      _currentIndex = widget.initialIndex;
    }
  }

  /// Handle tab selection - updates UI and syncs URL
  void _onTabSelected(int index) {
    if (index != _currentIndex) {
      setState(() {
        _currentIndex = index;
      });
      // Update the URL without transition (for back button support)
      context.go(_tabRoutes[index].path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _tabPages),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTabSelected: _onTabSelected,
      ),
    );
  }
}
