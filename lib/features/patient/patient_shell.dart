import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';

class PatientShell extends StatelessWidget {
  final Widget child;

  const PatientShell({super.key, required this.child});

  int _getSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/patient/home')) return 0;
    if (location.startsWith('/patient/appointments')) return 1;
    if (location.startsWith('/patient/chats')) return 2;
    if (location.startsWith('/patient/orders')) return 3;
    if (location.startsWith('/patient/profile')) return 4;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/patient/home');
        break;
      case 1:
        context.go('/patient/appointments');
        break;
      case 2:
        context.go('/patient/chats');
        break;
      case 3:
        context.go('/patient/orders');
        break;
      case 4:
        context.go('/patient/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _getSelectedIndex(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black.withOpacity(0.2) : const Color(0x0A000000),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: (index) => _onItemTapped(index, context),
          backgroundColor: isDark ? AppColors.cardDark : AppColors.cardLight,
          indicatorColor: AppColors.primaryTeal.withOpacity(0.12),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          height: 68,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined, color: AppColors.textSecondaryLight),
              selectedIcon: Icon(Icons.home_rounded, color: AppColors.primaryTeal),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.calendar_month_outlined, color: AppColors.textSecondaryLight),
              selectedIcon: Icon(Icons.calendar_month_rounded, color: AppColors.primaryTeal),
              label: 'Appts',
            ),
            NavigationDestination(
              icon: Icon(Icons.chat_bubble_outline_rounded, color: AppColors.textSecondaryLight),
              selectedIcon: Icon(Icons.chat_bubble_rounded, color: AppColors.primaryTeal),
              label: 'Chat',
            ),
            NavigationDestination(
              icon: Icon(Icons.shopping_bag_outlined, color: AppColors.textSecondaryLight),
              selectedIcon: Icon(Icons.shopping_bag_rounded, color: AppColors.primaryTeal),
              label: 'Orders',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline_rounded, color: AppColors.textSecondaryLight),
              selectedIcon: Icon(Icons.person_rounded, color: AppColors.primaryTeal),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
