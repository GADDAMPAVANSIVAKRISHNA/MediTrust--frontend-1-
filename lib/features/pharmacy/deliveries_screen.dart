import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/widgets.dart';

class PharmacyDeliveriesScreen extends StatelessWidget {
  const PharmacyDeliveriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final activeRiders = [
      {'name': 'Rider John', 'status': 'Delivering Order #ord_1', 'phone': '+91 9988776655'},
      {'name': 'Rider Mike', 'status': 'Idle at store', 'phone': '+91 8877665544'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Deliveries Dispatch', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Delivery radius settings card
              GlassCard(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.delivery_dining_rounded, color: AppColors.primaryTeal, size: 36),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Active Dispatch Radius: 5 km', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          SizedBox(height: 4),
                          Text('Deliveries fulfilled within 3 hours.', style: TextStyle(color: AppColors.textSecondaryLight, fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 28),
              
              const Text('Delivery Riders Status', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 16),
              
              Expanded(
                child: ListView.builder(
                  itemCount: activeRiders.length,
                  itemBuilder: (context, index) {
                    final rider = activeRiders[index];
                    final isIdle = rider['status'] == 'Idle at store';

                    return GlassCard(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: isIdle ? AppColors.success.withOpacity(0.1) : AppColors.primaryTeal.withOpacity(0.1),
                            child: Icon(Icons.person, color: isIdle ? AppColors.success : AppColors.primaryTeal),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(rider['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                const SizedBox(height: 4),
                                Text(rider['status']!, style: TextStyle(fontSize: 11, color: isIdle ? AppColors.success : AppColors.textSecondaryLight)),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.phone, color: AppColors.primaryTeal),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Calling ${rider['name']} (${rider['phone']})...')),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
