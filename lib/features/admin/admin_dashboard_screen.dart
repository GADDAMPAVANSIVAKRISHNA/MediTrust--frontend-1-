import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/providers.dart';
import '../../widgets/widgets.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  double _commissionRate = 10.0;
  final _pushMessageController = TextEditingController();

  final List<Map<String, String>> _pendingDoctors = [
    {'name': 'Dr. Sarah Jenkins', 'specialty': 'Pediatrician', 'exp': '12 yrs', 'id': 'doc_pend_1'},
    {'name': 'Dr. Marcus Aurelius', 'specialty': 'Neurologist', 'exp': '15 yrs', 'id': 'doc_pend_2'},
  ];

  final List<Map<String, String>> _pendingPharmacies = [
    {'name': 'Metro Drugs', 'owner': 'Alice Smith', 'address': 'Downtown City', 'id': 'pharm_pend_1'},
  ];

  void _approveDoctor(String id, String name) {
    setState(() {
      _pendingDoctors.removeWhere((d) => d['id'] == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Doctor $name approved successfully! Credentials verified.'), backgroundColor: AppColors.success),
    );
  }

  void _approvePharmacy(String id, String name) {
    setState(() {
      _pendingPharmacies.removeWhere((p) => p['id'] == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Pharmacy $name approved successfully! Store license linked.'), backgroundColor: AppColors.success),
    );
  }

  void _sendPushBroadcast() {
    if (_pushMessageController.text.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Broadcast sent to all users: "${_pushMessageController.text}"'),
          backgroundColor: AppColors.primaryTeal,
        ),
      );
      _pushMessageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Operations Hub', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        actions: [
          Consumer(
            builder: (context, ref, child) {
              return IconButton(
                icon: const Icon(Icons.logout_rounded, color: AppColors.error),
                tooltip: 'Logout Admin',
                onPressed: () async {
                  await ref.read(authProvider.notifier).logout();
                  if (context.mounted) context.go('/welcome');
                },
              );
            },
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dashboard Metrics Grid
              const Text('System Health Metrics', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 12),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.6,
                children: [
                  _metricTile('Total Platform Users', '4,820', Icons.people, AppColors.primaryTeal),
                  _metricTile('Active Bookings Today', '128', Icons.calendar_month, AppColors.primaryPurple),
                  _metricTile('Commission Generated', '₹92,400', Icons.payments, AppColors.success),
                  _metricTile('System API Health', '99.9%', Icons.dns, AppColors.warning),
                ],
              ),
              
              const SizedBox(height: 28),

              // Pending Approvals Queue
              const Text('Pending Approvals Queue', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 12),
              
              if (_pendingDoctors.isEmpty && _pendingPharmacies.isEmpty)
                GlassCard(
                  padding: const EdgeInsets.all(16),
                  child: const Center(child: Text('All registration queues cleared.', style: TextStyle(color: AppColors.textSecondaryLight))),
                )
              else ...[
                // Doctors list
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _pendingDoctors.length,
                  itemBuilder: (context, index) {
                    final d = _pendingDoctors[index];
                    return GlassCard(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(d['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                const SizedBox(height: 4),
                                Text('Doctor Onboarding  •  ${d['specialty']}  •  ${d['exp']}', style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryLight)),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () => _approveDoctor(d['id']!, d['name']!),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryTeal,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: const Text('Approve', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                // Pharmacies list
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _pendingPharmacies.length,
                  itemBuilder: (context, index) {
                    final p = _pendingPharmacies[index];
                    return GlassCard(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(p['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                const SizedBox(height: 4),
                                Text('Pharmacy Onboarding  •  Owner: ${p['owner']}  •  ${p['address']}', style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryLight)),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () => _approvePharmacy(p['id']!, p['name']!),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryTeal,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: const Text('Approve', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],

              const SizedBox(height: 28),

              // Commission Settings
              const Text('Commission rate controls', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 12),
              GlassCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Standard Commission Rate', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        Text('${_commissionRate.toInt()}%', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryPurple, fontSize: 15)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text('Deducted from all completed doctor consultations and pharmacy orders.', style: TextStyle(fontSize: 11, color: AppColors.textSecondaryLight, height: 1.4)),
                    Slider(
                      value: _commissionRate,
                      min: 0.0,
                      max: 40.0,
                      divisions: 8,
                      activeColor: AppColors.primaryPurple,
                      inactiveColor: AppColors.borderLight,
                      onChanged: (val) {
                        setState(() => _commissionRate = val);
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Push Notification Broadcast Panel
              const Text('System Notifications Broadcast', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 12),
              GlassCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    CustomTextField(
                      label: 'Broadcast Message',
                      hint: 'e.g. Platform update: scheduled system maintenance tonight...',
                      controller: _pushMessageController,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 16),
                    CustomButton(
                      text: 'Send Push Broadcast',
                      onPressed: _sendPushBroadcast,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _metricTile(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey[50]?.withOpacity(0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: color, size: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 2),
              Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.textSecondaryLight, fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }
}
