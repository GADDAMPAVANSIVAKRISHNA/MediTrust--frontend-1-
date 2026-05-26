import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        context.go('/welcome');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFE0F2FE), // Very light teal-blue sky
              Color(0xFFCCFBF1), // Very light green-teal
              Color(0xFFFFFFFF),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 3),
            // Logo Emblem
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryTeal.withOpacity(0.2),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.local_hospital_rounded,
                size: 64,
                color: AppColors.primaryTeal,
              ),
            )
            .animate()
            .fade(duration: 800.ms)
            .scale(delay: 200.ms, duration: 600.ms, curve: Curves.elasticOut),
            
            const SizedBox(height: 24),
            
            // App Name
            Text(
              'MediTrust',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimaryLight,
                letterSpacing: -0.5,
              ),
            )
            .animate()
            .fade(delay: 400.ms, duration: 600.ms)
            .slideY(begin: 0.2, end: 0, duration: 600.ms),
            
            const SizedBox(height: 8),
            
            // Tagline
            Text(
              'Your Health. Our Priority.',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondaryLight,
                fontWeight: FontWeight.w500,
              ),
            )
            .animate()
            .fade(delay: 700.ms, duration: 600.ms)
            .slideY(begin: 0.2, end: 0, duration: 600.ms),
            
            const Spacer(flex: 2),
            
            // Doctor Illustration Placeholder
            CustomPaint(
              size: const Size(200, 200),
              painter: DoctorIllustrationPainter(),
            )
            .animate()
            .fade(delay: 1000.ms, duration: 800.ms)
            .slideY(begin: 0.1, end: 0, duration: 800.ms),
            
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class DoctorIllustrationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primaryTeal.withOpacity(0.15)
      ..style = PaintingStyle.fill;

    // Draw background oval
    canvas.drawOval(
      Rect.fromLTWH(0, size.height * 0.3, size.width, size.height * 0.7),
      paint,
    );

    // Draw doctor head/shoulders simple schematic shapes for premium abstract look
    final doctorPaint = Paint()
      ..color = AppColors.primaryTeal
      ..style = PaintingStyle.fill;

    // Body/Coat
    final path = Path()
      ..moveTo(size.width * 0.2, size.height)
      ..quadraticBezierTo(size.width * 0.2, size.height * 0.6, size.width * 0.35, size.height * 0.55)
      ..lineTo(size.width * 0.65, size.height * 0.55)
      ..quadraticBezierTo(size.width * 0.8, size.height * 0.6, size.width * 0.8, size.height)
      ..close();
    canvas.drawPath(path, doctorPaint);

    // Stethoscope
    final stethPaint = Paint()
      ..color = AppColors.primaryPurple
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawArc(
      Rect.fromCircle(center: Offset(size.width * 0.5, size.height * 0.62), radius: size.width * 0.18),
      0,
      3.14,
      false,
      stethPaint,
    );

    // Head
    final headPaint = Paint()..color = const Color(0xFFFFD1A9); // Skin tone
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.38), size.width * 0.18, headPaint);

    // Hair
    final hairPaint = Paint()..color = AppColors.darkBg;
    canvas.drawArc(
      Rect.fromCircle(center: Offset(size.width * 0.5, size.height * 0.35), radius: size.width * 0.19),
      3.14,
      3.14,
      true,
      hairPaint,
    );

    // Glasses
    final glassesPaint = Paint()
      ..color = AppColors.darkBg
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(Offset(size.width * 0.43, size.height * 0.38), size.width * 0.04, glassesPaint);
    canvas.drawCircle(Offset(size.width * 0.57, size.height * 0.38), size.width * 0.04, glassesPaint);
    canvas.drawLine(Offset(size.width * 0.47, size.height * 0.38), Offset(size.width * 0.53, size.height * 0.38), glassesPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
