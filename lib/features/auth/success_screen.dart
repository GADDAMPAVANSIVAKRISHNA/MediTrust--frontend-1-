import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/widgets.dart';

class SuccessScreen extends StatelessWidget {
  final String message;
  final String nextRoute;

  const SuccessScreen({
    super.key,
    required this.message,
    required this.nextRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Circle Check Emblem
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.success,
                  size: 64,
                ),
              )
              .animate()
              .scale(duration: 500.ms, curve: Curves.easeOutBack)
              .fade(duration: 500.ms),
              
              const SizedBox(height: 32),
              
              const Text(
                'Success!',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimaryLight,
                ),
              )
              .animate()
              .fade(delay: 200.ms, duration: 400.ms),
              
              const SizedBox(height: 12),
              
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  color: AppColors.textSecondaryLight,
                  height: 1.5,
                ),
              )
              .animate()
              .fade(delay: 300.ms, duration: 400.ms),
              
              const SizedBox(height: 48),
              
              CustomButton(
                text: 'Continue',
                onPressed: () {
                  context.go(nextRoute);
                },
              )
              .animate()
              .fade(delay: 400.ms, duration: 400.ms)
              .slideY(begin: 0.1, end: 0, duration: 400.ms),
            ],
          ),
        ),
      ),
    );
  }
}
