import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/providers.dart';
import '../../widgets/widgets.dart';

class PharmacyProfileScreen extends ConsumerWidget {
  const PharmacyProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    final storeName = authState?.name ?? 'Grace Pharmacy';
    final ownerName = authState?.additionalDetails['ownerName'] ?? 'John Doe';
    final storeAddress = authState?.additionalDetails['address'] ?? '4th Block, Cityville';
    final storeHours = authState?.additionalDetails['hours'] ?? '09:00 AM - 10:00 PM';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Store Profile', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Store Avatar banner card
            GlassCard(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: AppColors.primaryTeal.withOpacity(0.1),
                    child: const Icon(Icons.storefront_rounded, color: AppColors.primaryTeal, size: 40),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          storeName,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Owner: $ownerName',
                          style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryLight),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          storeAddress,
                          style: const TextStyle(color: AppColors.textSecondaryLight, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Details list
            ListTile(
              leading: const Icon(Icons.access_time_outlined, color: AppColors.primaryTeal),
              title: const Text('Store Opening Hours', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              subtitle: Text(storeHours, style: const TextStyle(fontSize: 12)),
            ),
            const Divider(height: 1, color: AppColors.borderLight),
            
            ListTile(
              leading: const Icon(Icons.verified_user_outlined, color: AppColors.primaryTeal),
              title: const Text('Drug License Reference', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              subtitle: const Text('License No: DL-2026/87654', style: TextStyle(fontSize: 12)),
            ),
            const Divider(height: 1, color: AppColors.borderLight),
            
            const SizedBox(height: 32),
            
            // Logout option
            ListTile(
              leading: const Icon(Icons.logout, color: AppColors.error),
              title: const Text('Logout Merchant', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold, fontSize: 14)),
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
