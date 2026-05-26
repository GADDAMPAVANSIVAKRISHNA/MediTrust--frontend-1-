import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';

class PharmacyShell extends StatelessWidget {
  final Widget child;

  const PharmacyShell({super.key, required this.child});

  int _getSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/pharmacy/home')) return 0;
    if (location.startsWith('/pharmacy/medicines')) return 1;
    if (location.startsWith('/pharmacy/deliveries')) return 2;
    if (location.startsWith('/pharmacy/earnings')) return 3;
    if (location.startsWith('/pharmacy/profile')) return 4;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/pharmacy/home');
        break;
      case 1:
        context.go('/pharmacy/medicines');
        break;
      case 2:
        context.go('/pharmacy/deliveries');
        break;
      case 3:
        context.go('/pharmacy/earnings');
        break;
      case 4:
        context.go('/pharmacy/profile');
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
              icon: Icon(Icons.receipt_long_outlined, color: AppColors.textSecondaryLight),
              selectedIcon: Icon(Icons.receipt_long_rounded, color: AppColors.primaryTeal),
              label: 'Orders',
            ),
            NavigationDestination(
              icon: Icon(Icons.medication_outlined, color: AppColors.textSecondaryLight),
              selectedIcon: Icon(Icons.medication_rounded, color: AppColors.primaryTeal),
              label: 'Inventory',
            ),
            NavigationDestination(
              icon: Icon(Icons.delivery_dining_outlined, color: AppColors.textSecondaryLight),
              selectedIcon: Icon(Icons.delivery_dining_rounded, color: AppColors.primaryTeal),
              label: 'Deliveries',
            ),
            NavigationDestination(
              icon: Icon(Icons.analytics_outlined, color: AppColors.textSecondaryLight),
              selectedIcon: Icon(Icons.analytics_rounded, color: AppColors.primaryTeal),
              label: 'Earnings',
            ),
            NavigationDestination(
              icon: Icon(Icons.store_outlined, color: AppColors.textSecondaryLight),
              selectedIcon: Icon(Icons.store_rounded, color: AppColors.primaryTeal),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
