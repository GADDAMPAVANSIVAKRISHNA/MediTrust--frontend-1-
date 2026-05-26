import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../models/models.dart';
import '../../providers/providers.dart';
import '../../widgets/widgets.dart';

class RoleSelectionScreen extends ConsumerWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimaryLight, size: 20),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.admin_panel_settings_outlined, color: AppColors.primaryPurple),
            tooltip: 'Admin Mode',
            onPressed: () async {
              // Quick login as Admin
              await ref.read(authProvider.notifier).selectRole(UserRole.admin);
              await ref.read(authProvider.notifier).completeOnboarding({'name': 'MediTrust Admin'});
              if (context.mounted) {
                context.go('/admin/home');
              }
            },
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text(
                'Who are you?',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Choose your role to continue',
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.textSecondaryLight,
                ),
              ),
              const SizedBox(height: 32),
              
              // Roles Cards
              Expanded(
                child: ListView(
                  children: [
                    _roleCard(
                      context: context,
                      ref: ref,
                      role: UserRole.patient,
                      title: 'I am a Patient',
                      description: 'Book appointments, consult doctors, order medicines',
                      icon: Icons.person_add_alt_1_rounded,
                      gradientColors: [const Color(0xFF13B8A6), const Color(0xFF2DD4BF)],
                      nextRoute: '/patient-onboarding',
                    ),
                    const SizedBox(height: 20),
                    _roleCard(
                      context: context,
                      ref: ref,
                      role: UserRole.doctor,
                      title: 'I am a Doctor',
                      description: 'Manage appointments, consult patients',
                      icon: Icons.medical_services_rounded,
                      gradientColors: [const Color(0xFF7B61FF), const Color(0xFF9F6BFF)],
                      nextRoute: '/doctor-onboarding',
                    ),
                    const SizedBox(height: 20),
                    _roleCard(
                      context: context,
                      ref: ref,
                      role: UserRole.pharmacy,
                      title: 'I am a Pharmacy',
                      description: 'Manage medicines, orders & deliveries',
                      icon: Icons.local_pharmacy_rounded,
                      gradientColors: [const Color(0xFFF59E0B), const Color(0xFFFBBF24)],
                      nextRoute: '/pharmacy-onboarding',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _roleCard({
    required BuildContext context,
    required WidgetRef ref,
    required UserRole role,
    required String title,
    required String description,
    required IconData icon,
    required List<Color> gradientColors,
    required String nextRoute,
  }) {
    return GlassCard(
      padding: EdgeInsets.zero,
      borderRadius: 20,
      onTap: () async {
        await ref.read(authProvider.notifier).selectRole(role);
        if (context.mounted) {
          context.push(nextRoute);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: gradientColors[0].withOpacity(0.3), width: 1.5),
        ),
        child: Row(
          children: [
            // Icon emblem with gradient background
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 20),
            
            // Description Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondaryLight,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textSecondaryLight,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
