import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/widgets.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFF0FDFA), // Teal-50
              Color(0xFFFAF5FF), // Purple-50
              Colors.white,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),
                // App Branding Icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.local_hospital_rounded, color: AppColors.primaryTeal, size: 28),
                    const SizedBox(width: 8),
                    Text(
                      'MediTrust',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                )
                .animate()
                .fade(duration: 500.ms),
                
                const Spacer(),
                
                // Welcome Illustration
                CustomPaint(
                  size: const Size(220, 220),
                  painter: WelcomeBannerPainter(),
                )
                .animate()
                .fade(delay: 200.ms, duration: 600.ms)
                .scale(delay: 200.ms, duration: 600.ms, curve: Curves.easeOutBack),
                
                const Spacer(),
                
                // Text Headers
                Text(
                  'Your Health. Our Priority.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimaryLight,
                    letterSpacing: -0.5,
                  ),
                )
                .animate()
                .fade(delay: 400.ms, duration: 500.ms)
                .slideY(begin: 0.1, end: 0, duration: 500.ms),
                
                const SizedBox(height: 12),
                
                Text(
                  'Consult with certified doctors, order medicines from verified pharmacies, and manage appointments with ease.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: AppColors.textSecondaryLight,
                    height: 1.5,
                  ),
                )
                .animate()
                .fade(delay: 500.ms, duration: 500.ms)
                .slideY(begin: 0.1, end: 0, duration: 500.ms),
                
                const Spacer(flex: 2),
                
                // Buttons
                CustomButton(
                  text: 'Get Started',
                  onPressed: () => context.push('/login'),
                )
                .animate()
                .fade(delay: 600.ms, duration: 500.ms)
                .slideY(begin: 0.2, end: 0, duration: 500.ms),
                
                const SizedBox(height: 16),
                
                // Social Options
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _socialIcon(Icons.g_mobiledata, () {}),
                    const SizedBox(width: 16),
                    _socialIcon(Icons.apple, () {}),
                    const SizedBox(width: 16),
                    _socialIcon(Icons.facebook, () {}),
                  ],
                )
                .animate()
                .fade(delay: 700.ms, duration: 500.ms),
                
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _socialIcon(IconData icon, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.borderLight),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 8,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: AppColors.textPrimaryLight, size: 28),
        onPressed: onTap,
      ),
    );
  }
}

class WelcomeBannerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primaryTeal.withOpacity(0.12)
      ..style = PaintingStyle.fill;
      
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.5), size.width * 0.45, paint);
    
    paint.color = AppColors.primaryPurple.withOpacity(0.08);
    canvas.drawCircle(Offset(size.width * 0.7, size.height * 0.3), size.width * 0.3, paint);

    // Dynamic medical emblem
    final logoPaint = Paint()
      ..shader = AppColors.primaryGradient.createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      );
    
    // Draw heart shape
    final path = Path()
      ..moveTo(size.width * 0.5, size.height * 0.7)
      ..cubicTo(size.width * 0.2, size.height * 0.45, size.width * 0.3, size.height * 0.25, size.width * 0.5, size.height * 0.4)
      ..cubicTo(size.width * 0.7, size.height * 0.25, size.width * 0.8, size.height * 0.45, size.width * 0.5, size.height * 0.7);
    canvas.drawPath(path, logoPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
