import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/providers.dart';

class PatientProfileScreen extends ConsumerWidget {
  const PatientProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final userName = authState?.name ?? 'Sarah Johnson';
    final userEmail = authState?.email ?? 'sarah.johnson@email.com';

    final menuItems = [
      {'title': 'Personal Information', 'icon': Icons.person_outline, 'route': '/patient-onboarding'},
      {'title': 'Medical History', 'icon': Icons.medical_information_outlined, 'route': ''},
      {'title': 'My Prescriptions', 'icon': Icons.description_outlined, 'route': '/patient/prescription/pr_1'},
      {'title': 'My Appointments', 'icon': Icons.calendar_month_outlined, 'route': '/patient/appointments'},
      {'title': 'My Orders', 'icon': Icons.shopping_bag_outlined, 'route': '/patient/orders'},
      {'title': 'Address Book', 'icon': Icons.location_on_outlined, 'route': ''},
      {'title': 'Payment Methods', 'icon': Icons.credit_card_outlined, 'route': ''},
      {'title': 'Settings', 'icon': Icons.settings_outlined, 'route': ''},
      {'title': 'Help & Support', 'icon': Icons.help_outline_outlined, 'route': ''},
    ];

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Purple Header matching Mockup
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 24,
                bottom: 24,
                left: 24,
                right: 24,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primaryPurple, Color(0xFF9F6BFF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: Colors.white24,
                    backgroundImage: const NetworkImage(
                      'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&q=80&w=150',
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          userEmail,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white54),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Edit', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Menu list items
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                final item = menuItems[index];
                return Column(
                  children: [
                    ListTile(
                      leading: Icon(
                        item['icon'] as IconData,
                        color: isDark ? AppColors.primaryTeal : AppColors.textPrimaryLight.withOpacity(0.7),
                        size: 22,
                      ),
                      title: Text(
                        item['title'] as String,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      trailing: const Icon(Icons.chevron_right, size: 20, color: AppColors.textSecondaryLight),
                      onTap: () {
                        final r = item['route'] as String;
                        if (r.isNotEmpty) {
                          context.push(r);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('"${item['title']}" screen is ready for Firebase integration later.')),
                          );
                        }
                      },
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Divider(height: 1, color: AppColors.borderLight),
                    ),
                  ],
                );
              },
            ),
            
            // Logout Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                leading: const Icon(Icons.logout_rounded, color: AppColors.error, size: 22),
                title: const Text(
                  'Logout',
                  style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold, fontSize: 14),
                ),
                onTap: () async {
                  await ref.read(authProvider.notifier).logout();
                  if (context.mounted) {
                    context.go('/welcome');
                  }
                },
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
