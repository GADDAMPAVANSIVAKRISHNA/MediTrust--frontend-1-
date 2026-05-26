import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/providers.dart';
import '../../widgets/widgets.dart';

class DoctorSettingsProfileScreen extends ConsumerStatefulWidget {
  const DoctorSettingsProfileScreen({super.key});

  @override
  ConsumerState<DoctorSettingsProfileScreen> createState() => _DoctorSettingsProfileScreenState();
}

class _DoctorSettingsProfileScreenState extends ConsumerState<DoctorSettingsProfileScreen> {
  double _boostBudget = 100.0;
  bool _isBoosterActive = false;

  void _showAvailabilityDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Manage Availability'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('Weekly Schedule: Mon - Sat', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('Available Slots:'),
              Text('• 09:00 AM - 11:00 AM'),
              Text('• 02:00 PM - 04:00 PM'),
              Text('• 06:00 PM - 08:00 PM'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            )
          ],
        );
      },
    );
  }

  void _showSubscriptionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Partner Subscription'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text('MediTrust Gold Partner', style: TextStyle(color: AppColors.success, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 12),
              const Text('Active Plan Benefits:'),
              const Text('• 0% Commission on first 50 bookings'),
              const Text('• Gold Badge icon on search results'),
              const Text('• Live Chat Priority support access'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Done'),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    final docName = authState?.name ?? 'Dr. Priya Sharma';
    final docEmail = authState?.email ?? 'priya.sharma@meditrust.com';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Settings', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Avatar profile card
            GlassCard(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundImage: const NetworkImage(
                      'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?auto=format&fit=crop&q=80&w=150',
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          docName,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Cardiologist  •  MBBS, MD',
                          style: TextStyle(color: AppColors.primaryPurple, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          docEmail,
                          style: const TextStyle(color: AppColors.textSecondaryLight, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Availability card
            ListTile(
              leading: const Icon(Icons.calendar_month, color: AppColors.primaryPurple),
              title: const Text('Manage Availability Schedule', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondaryLight),
              onTap: _showAvailabilityDialog,
            ),
            const Divider(height: 1, color: AppColors.borderLight),
            
            // Subscription Card
            ListTile(
              leading: const Icon(Icons.workspace_premium, color: AppColors.primaryPurple),
              title: const Text('Subscription Plans', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondaryLight),
              onTap: _showSubscriptionDialog,
            ),
            const Divider(height: 1, color: AppColors.borderLight),
            
            const SizedBox(height: 24),

            // Ad Booster Card Page layout
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Clinical Visibility Booster',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
            const SizedBox(height: 12),
            GlassCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Ad Search Booster', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      Switch(
                        value: _isBoosterActive,
                        activeColor: AppColors.primaryPurple,
                        onChanged: (val) {
                          setState(() => _isBoosterActive = val);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(_isBoosterActive ? 'Clinical Ad Booster started!' : 'Ad Booster paused.')),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Allocate budget to push your clinical profile to the top of cardiologist search rankings in Cityville.',
                    style: TextStyle(fontSize: 11, color: AppColors.textSecondaryLight, height: 1.4),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Daily Budget: ₹${_boostBudget.toInt()}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      const Text('Est. Views: +240 / day', style: TextStyle(fontSize: 10, color: AppColors.success, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Slider(
                    value: _boostBudget,
                    min: 50.0,
                    max: 1000.0,
                    divisions: 19,
                    activeColor: AppColors.primaryPurple,
                    inactiveColor: AppColors.borderLight,
                    onChanged: (val) {
                      setState(() => _boostBudget = val);
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),

            // Logout Option
            ListTile(
              leading: const Icon(Icons.logout, color: AppColors.error),
              title: const Text('Logout', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold, fontSize: 14)),
              onTap: () async {
                await ref.read(authProvider.notifier).logout();
                if (context.mounted) {
                  context.go('/welcome');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
