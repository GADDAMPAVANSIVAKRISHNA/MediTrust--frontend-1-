import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/widgets.dart';

class DoctorEarningsScreen extends StatelessWidget {
  const DoctorEarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final earningsList = [
      {'patient': 'Sarah Johnson', 'type': 'Video Call Consultation', 'amount': '₹600', 'date': 'Today, 09:30 AM', 'status': 'Settled'},
      {'patient': 'James Smith', 'type': 'Clinic Visit Consultation', 'amount': '₹700', 'date': 'Today, 11:15 AM', 'status': 'Settled'},
      {'patient': 'Emma Watson', 'type': 'Video Call Consultation', 'amount': '₹600', 'date': 'Yesterday', 'status': 'Settled'},
      {'patient': 'Admin Payout', 'type': 'Weekly Commission Settlement', 'amount': '-₹1,200', 'date': 'May 20, 2026', 'status': 'Debited'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Earnings Analytics', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Total earnings card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryPurple.withOpacity(0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    )
                  ],
                ),
                child: Column(
                  children: const [
                    Text('Total Earnings Balance', style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text('₹42,500', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900)),
                    SizedBox(height: 12),
                    Text('Next automatic payout: Friday, May 29', style: TextStyle(color: Colors.white60, fontSize: 11)),
                  ],
                ),
              ),
              
              const SizedBox(height: 28),

              // Weekly Graph Representation
              const Text('Weekly Performance', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 16),
              
              GlassCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('Weekly Revenue', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        Text('May 20 - May 26', style: TextStyle(color: AppColors.textSecondaryLight, fontSize: 11)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Custom Painter Bar Chart representation
                    CustomPaint(
                      size: const Size(double.infinity, 120),
                      painter: WeeklyEarningsChartPainter(isDark: isDark),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Transaction Log
              const Text('Recent Settlements', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 16),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: earningsList.length,
                itemBuilder: (context, index) {
                  final transaction = earningsList[index];
                  final isDebit = transaction['amount']!.startsWith('-');

                  return GlassCard(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              transaction['patient']!,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${transaction['type']} • ${transaction['date']}',
                              style: const TextStyle(color: AppColors.textSecondaryLight, fontSize: 11),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              transaction['amount']!,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: isDebit ? AppColors.error : AppColors.success,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              transaction['status']!,
                              style: const TextStyle(color: AppColors.textSecondaryLight, fontSize: 9),
                            ),
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

class WeeklyEarningsChartPainter extends CustomPainter {
  final bool isDark;

  WeeklyEarningsChartPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primaryPurple
      ..style = PaintingStyle.fill;

    final double barWidth = 24.0;
    final int barCount = 7;
    final double spacing = (size.width - (barCount * barWidth)) / (barCount - 1);
    
    // Mock heights for 7 days
    final List<double> heights = [40, 70, 50, 90, 60, 80, 110];
    final List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    for (int i = 0; i < barCount; i++) {
      final double x = i * (barWidth + spacing);
      final double y = size.height - heights[i];

      // Draw Bar
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, y - 10, barWidth, heights[i]),
          const Radius.circular(6),
        ),
        paint,
      );

      // Draw Day Label under Bar
      textPainter.text = TextSpan(
        text: days[i],
        style: TextStyle(
          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          fontSize: 9,
          fontWeight: FontWeight.bold,
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(x + (barWidth - textPainter.width) / 2, size.height - 4));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
