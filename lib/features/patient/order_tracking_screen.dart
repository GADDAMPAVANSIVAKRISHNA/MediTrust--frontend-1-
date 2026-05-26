import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/widgets.dart';

class OrderTrackingScreen extends StatelessWidget {
  final String orderId;
  const OrderTrackingScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final steps = [
      {'title': 'Order Placed', 'time': '10:15 AM', 'desc': 'Your order has been received by MediTrust', 'status': 'done'},
      {'title': 'Order Accepted', 'time': '10:30 AM', 'desc': 'Grace Pharmacy has accepted and packed your items', 'status': 'done'},
      {'title': 'Out for Delivery', 'time': '11:15 AM', 'desc': 'Delivery agent John is carrying your package', 'status': 'active'},
      {'title': 'Delivered', 'time': '--:--', 'desc': 'Package delivered at your shipping address', 'status': 'pending'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Order', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Summary card
              GlassCard(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.local_shipping_rounded, color: AppColors.primaryTeal, size: 36),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Order ID: $orderId', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          const SizedBox(height: 4),
                          const Text('Estimated Delivery: Today, 12:30 PM', style: TextStyle(fontSize: 12, color: AppColors.textSecondaryLight)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              
              const Text('Delivery Timeline', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 20),
              
              // Timeline Steps
              Expanded(
                child: ListView.builder(
                  itemCount: steps.length,
                  itemBuilder: (context, index) {
                    final step = steps[index];
                    final isDone = step['status'] == 'done';
                    final isActive = step['status'] == 'active';
                    final isLast = index == steps.length - 1;

                    return IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Left side line
                          Column(
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isDone 
                                    ? AppColors.primaryTeal 
                                    : (isActive ? AppColors.primaryPurple : Colors.grey[300]),
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                                child: isDone 
                                  ? const Icon(Icons.check, color: Colors.white, size: 12) 
                                  : null,
                              ),
                              if (!isLast)
                                Expanded(
                                  child: Container(
                                    width: 2,
                                    color: isDone ? AppColors.primaryTeal : Colors.grey[300],
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(width: 20),
                          
                          // Right side text
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 24.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        step['title']!,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: isDone || isActive 
                                            ? (isDark ? Colors.white : Colors.black87) 
                                            : AppColors.textSecondaryLight,
                                        ),
                                      ),
                                      Text(
                                        step['time']!,
                                        style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryLight),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    step['desc']!,
                                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryLight, height: 1.4),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              
              CustomButton(
                text: 'Back to Dashboard',
                onPressed: () => context.go('/patient/home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
