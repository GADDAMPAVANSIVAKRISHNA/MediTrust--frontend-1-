import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';

class DoctorShell extends StatelessWidget {
  final Widget child;

  const DoctorShell({super.key, required this.child});

  int _getSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/doctor/home')) return 0;
    if (location.startsWith('/doctor/patients')) return 1;
    if (location.startsWith('/doctor/consultations')) return 2;
    if (location.startsWith('/doctor/earnings')) return 3;
    if (location.startsWith('/doctor/profile')) return 4;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/doctor/home');
        break;
      case 1:
        context.go('/doctor/patients');
        break;
      case 2:
        context.go('/doctor/consultations');
        break;
      case 3:
        context.go('/doctor/earnings');
        break;
      case 4:
        context.go('/doctor/profile');
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
          indicatorColor: AppColors.primaryPurple.withOpacity(0.12),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          height: 68,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.dashboard_outlined, color: AppColors.textSecondaryLight),
              selectedIcon: Icon(Icons.dashboard_rounded, color: AppColors.primaryPurple),
              label: 'Dashboard',
            ),
            NavigationDestination(
              icon: Icon(Icons.people_alt_outlined, color: AppColors.textSecondaryLight),
              selectedIcon: Icon(Icons.people_alt_rounded, color: AppColors.primaryPurple),
              label: 'Patients',
            ),
            NavigationDestination(
              icon: Icon(Icons.video_chat_outlined, color: AppColors.textSecondaryLight),
              selectedIcon: Icon(Icons.video_chat_rounded, color: AppColors.primaryPurple),
              label: 'Consults',
            ),
            NavigationDestination(
              icon: Icon(Icons.payments_outlined, color: AppColors.textSecondaryLight),
              selectedIcon: Icon(Icons.payments_rounded, color: AppColors.primaryPurple),
              label: 'Earnings',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline_rounded, color: AppColors.textSecondaryLight),
              selectedIcon: Icon(Icons.person_rounded, color: AppColors.primaryPurple),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
