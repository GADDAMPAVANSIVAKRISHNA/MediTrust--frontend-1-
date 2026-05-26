import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/widgets.dart';

class PharmacyEarningsScreen extends StatelessWidget {
  const PharmacyEarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final transactions = [
      {'id': 'ord_1', 'buyer': 'Sarah Johnson', 'amount': '₹100', 'date': 'Today, 10:30 AM'},
      {'id': 'ord_past_1', 'buyer': 'Sarah Johnson', 'amount': '₹240', 'date': 'Yesterday'},
      {'id': 'ord_past_2', 'buyer': 'James Smith', 'amount': '₹399', 'date': 'May 20, 2026'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Store Revenue', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Summary card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: AppColors.tealGradient,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: const [
                    Text('Total Sales Value', style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text('₹18,400', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900)),
                    SizedBox(height: 12),
                    Text('Next payout release: Friday, May 29', style: TextStyle(color: Colors.white60, fontSize: 11)),
                  ],
                ),
              ),
              
              const SizedBox(height: 28),
              
              const Text('Earnings Settlement History', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 16),
              
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final trans = transactions[index];
                  return GlassCard(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Order: #${trans['id']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            const SizedBox(height: 4),
                            Text('Buyer: ${trans['buyer']}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryLight)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(trans['amount']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.primaryTeal)),
                            const SizedBox(height: 4),
                            Text(trans['date']!, style: const TextStyle(fontSize: 10, color: AppColors.textSecondaryLight)),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
