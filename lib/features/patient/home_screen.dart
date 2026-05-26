import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/providers.dart';
import '../../widgets/widgets.dart';

class PatientHomeScreen extends ConsumerWidget {
  const PatientHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final userName = authState?.name ?? 'Sarah';

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Greeting & Dark Mode Toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isDark ? 'Good Evening, $userName' : 'Good Morning, $userName',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Take care of your health today!',
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      // Theme Toggle Button
                      IconButton(
                        icon: Icon(
                          isDark ? Icons.light_mode_rounded : Icons.dark_mode_outlined,
                          color: isDark ? AppColors.warning : AppColors.textPrimaryLight,
                        ),
                        onPressed: () {
                          ref.read(themeProvider.notifier).toggleTheme();
                        },
                      ),
                      const SizedBox(width: 8),
                      // Avatar
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: AppColors.primaryTeal.withOpacity(0.2),
                        backgroundImage: const NetworkImage(
                          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&q=80&w=150',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Upcoming Appointment Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark 
                      ? [const Color(0xFF0F766E), const Color(0xFF115E59)]
                      : [AppColors.primaryTeal, const Color(0xFF0D9488)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryTeal.withOpacity(0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Upcoming Appointment',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Video Call',
                            style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 26,
                          backgroundColor: Colors.white24,
                          backgroundImage: const NetworkImage(
                            'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?auto=format&fit=crop&q=80&w=150',
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Dr. Priya Sharma',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Cardiologist',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.access_time, color: Colors.white70, size: 16),
                            const SizedBox(width: 6),
                            const Text(
                              'May 07, 2026  •  09:30 AM',
                              style: TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {
                            context.push('/patient/video/apt_1');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.primaryTeal,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          ),
                          child: const Text(
                            'View Details',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
              .animate()
              .fade(duration: 600.ms)
              .scale(delay: 100.ms, duration: 500.ms, curve: Curves.easeOutBack),
              
              const SizedBox(height: 28),

              // Quick Actions Grid Header
              Text(
                'What would you like to do?',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Actions 2x4 Grid
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 4,
                crossAxisSpacing: 12,
                mainAxisSpacing: 16,
                childAspectRatio: 0.8,
                children: [
                  _actionItem(context, 'Book Appt', Icons.calendar_month_rounded, const Color(0xFFE0F2FE), const Color(0xFF0284C7), '/patient/doctors'),
                  _actionItem(context, 'Chat Doc', Icons.chat_bubble_rounded, const Color(0xFFF3E8FF), const Color(0xFF7B61FF), '/patient/chats'),
                  _actionItem(context, 'Medicines', Icons.medication_rounded, const Color(0xFFD1FAE5), const Color(0xFF10B981), '/patient/medicines'),
                  _actionItem(context, 'Prescriptions', Icons.description_rounded, const Color(0xFFFEF3C7), const Color(0xFFF59E0B), '/patient/profile'),
                  _actionItem(context, 'AI Assistant', Icons.psychology_rounded, const Color(0xFFFCE7F3), const Color(0xFFEC4899), '/patient/ai-assistant'),
                  _actionItem(context, 'Voice Help', Icons.mic_rounded, const Color(0xFFCCFBF1), const Color(0xFF0D9488), '/patient/voice-assistant'),
                  _actionItem(context, 'Skin Scan', Icons.camera_alt_rounded, const Color(0xFFFFEDD5), const Color(0xFFEA580C), '/patient/skin-scan'),
                  _actionItem(context, 'Skincare', Icons.shopping_bag_rounded, const Color(0xFFEDE9FE), const Color(0xFF8B5CF6), '/patient/skincare'),
                ],
              )
              .animate()
              .fade(delay: 200.ms, duration: 600.ms),

              const SizedBox(height: 28),

              // Health Tips Card
              GlassCard(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.primaryPurple.withOpacity(0.2) : const Color(0xFFFAF5FF),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Health Tips',
                              style: TextStyle(
                                color: AppColors.primaryPurple,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            isDark 
                              ? 'A good sleep keeps your heart healthy. Target 7-8 hours daily.' 
                              : 'Drink plenty of water and stay hydrated throughout the day.',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'General health tips provided by certified doctors.',
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Graphical Custom illustration
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.primaryTeal.withOpacity(0.08),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          isDark ? Icons.nightlight_round : Icons.water_drop_rounded,
                          color: isDark ? AppColors.primaryPurple : AppColors.primaryTeal,
                          size: 36,
                        ),
                      ),
                    ),
                  ],
                ),
              )
              .animate()
              .fade(delay: 400.ms, duration: 600.ms)
              .slideY(begin: 0.1, end: 0, duration: 600.ms),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionItem(
    BuildContext context,
    String label,
    IconData icon,
    Color bg,
    Color iconColor,
    String route,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return GestureDetector(
      onTap: () => context.push(route),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : bg,
              borderRadius: BorderRadius.circular(16),
              border: isDark ? Border.all(color: Colors.white12) : null,
              boxShadow: isDark ? null : const [
                BoxShadow(
                  color: Color(0x06000000),
                  blurRadius: 6,
                  offset: Offset(0, 3),
                )
              ],
            ),
            child: Icon(icon, color: isDark ? iconColor.withOpacity(0.9) : iconColor, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
