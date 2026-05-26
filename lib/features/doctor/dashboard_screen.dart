import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/providers.dart';
import '../../widgets/widgets.dart';

class DoctorDashboardScreen extends ConsumerWidget {
  const DoctorDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final docName = authState?.name ?? 'Dr. Priya Sharma';

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome, $docName',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Hope you have a productive day assisting patients!',
                        style: TextStyle(fontSize: 12, color: AppColors.textSecondaryLight),
                      ),
                    ],
                  ),
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors.primaryPurple.withOpacity(0.2),
                    backgroundImage: const NetworkImage(
                      'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?auto=format&fit=crop&q=80&w=150',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Statistics Banner
              Row(
                children: [
                  Expanded(child: _metricCard('Consultations', '42', Icons.video_call_rounded, isDark)),
                  const SizedBox(width: 12),
                  Expanded(child: _metricCard('Earnings', '₹12,400', Icons.payments_rounded, isDark)),
                  const SizedBox(width: 12),
                  Expanded(child: _metricCard('Review Rating', '4.8', Icons.star_rounded, isDark)),
                ],
              )
              .animate()
              .fade(duration: 500.ms)
              .scale(duration: 500.ms, curve: Curves.easeOutBack),

              const SizedBox(height: 28),

              // Today's Appointments Section
              const Text(
                "Today's Consultation Schedule",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),
              
              ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _appointmentRow(
                    context,
                    'Sarah Johnson',
                    '09:30 AM',
                    'Video Call',
                    'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&q=80&w=100',
                    'apt_1',
                    isDark,
                  ),
                  _appointmentRow(
                    context,
                    'James Smith',
                    '11:15 AM',
                    'In-clinic Visit',
                    'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&q=80&w=100',
                    'apt_2',
                    isDark,
                  ),
                  _appointmentRow(
                    context,
                    'Emma Watson',
                    '02:00 PM',
                    'Video Call',
                    'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?auto=format&fit=crop&q=80&w=100',
                    'apt_3',
                    isDark,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _metricCard(String label, String val, IconData icon, bool isDark) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primaryPurple, size: 24),
          const SizedBox(height: 8),
          Text(
            val,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.textSecondaryLight, fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget _appointmentRow(
    BuildContext context,
    String name,
    String time,
    String type,
    String imgUrl,
    String aptId,
    bool isDark,
  ) {
    final isVideo = type == 'Video Call';
    return GlassCard(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: NetworkImage(imgUrl),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(isVideo ? Icons.videocam : Icons.business, color: isVideo ? AppColors.primaryTeal : AppColors.primaryPurple, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      '$type  •  $time',
                      style: const TextStyle(color: AppColors.textSecondaryLight, fontSize: 11),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Start Call or Action buttons
          Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  if (isVideo) {
                    context.push('/patient/video/$aptId');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Starting In-clinic visit check in...')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isVideo ? AppColors.primaryTeal : AppColors.primaryPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text(isVideo ? 'Start Call' : 'Check In', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 4),
              GestureDetector(
                onTap: () => context.push('/doctor/create-prescription/$aptId'),
                child: const Text(
                  'Write Rx',
                  style: TextStyle(color: AppColors.primaryPurple, fontWeight: FontWeight.bold, fontSize: 10, decoration: TextDecoration.underline),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
