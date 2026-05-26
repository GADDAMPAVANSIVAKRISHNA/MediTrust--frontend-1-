import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/widgets.dart';

class SkinScanScreen extends StatefulWidget {
  const SkinScanScreen({super.key});

  @override
  State<SkinScanScreen> createState() => _SkinScanScreenState();
}

class _SkinScanScreenState extends State<SkinScanScreen> {
  bool _isScanning = false;
  bool _scanCompleted = false;
  double _scanProgress = 0.0;
  Timer? _progressTimer;

  void _startScan() {
    setState(() {
      _isScanning = true;
      _scanCompleted = false;
      _scanProgress = 0.0;
    });

    _progressTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (!mounted) return;
      setState(() {
        _scanProgress += 0.02;
        if (_scanProgress >= 1.0) {
          _progressTimer?.cancel();
          _isScanning = false;
          _scanCompleted = true;
        }
      });
    });
  }

  @override
  void dispose() {
    _progressTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Skin Scan AI', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'AI Skin Analyzer',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              const Text(
                'Scan your face using AI to detect skin conditions and get dermatologist-approved recommendations.',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondaryLight, height: 1.4),
              ),
              const SizedBox(height: 24),

              // Scanning frame container
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    width: 280,
                    height: 280,
                    color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF3F4F6),
                    child: Stack(
                      children: [
                        // Background face placeholder representation
                        Image.network(
                          'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&q=80&w=300',
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        
                        // Scanner overlay line
                        if (_isScanning)
                          Positioned(
                            top: 280 * _scanProgress,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 4,
                              decoration: BoxDecoration(
                                color: AppColors.primaryTeal,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primaryTeal.withOpacity(0.8),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  )
                                ],
                              ),
                            ),
                          ),
                          
                        // Scanning progress details overlay
                        if (_isScanning)
                          Container(
                            color: Colors.black38,
                            child: Center(
                              child: Text(
                                'Analyzing... ${(_scanProgress * 100).toInt()}%',
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 24),

              // Buttons
              if (!_isScanning && !_scanCompleted)
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: 'Start Camera Scan',
                        icon: const Icon(Icons.camera_alt_outlined, color: Colors.white),
                        onPressed: _startScan,
                      ),
                    ),
                  ],
                ),

              // Scan Result Block
              if (_scanCompleted) ...[
                GlassCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Scan Diagnosis Result',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.primaryPurple),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.success.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'Low Severity',
                              style: TextStyle(color: AppColors.success, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Mild Acne & Sebum Imbalance detected',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'AI detected slightly active oil glands around your nose and cheeks. We recommend adding Niacinamide or Hyaluronic serum to your daily skincare routine.',
                        style: TextStyle(fontSize: 12, color: AppColors.textSecondaryLight, height: 1.4),
                      ),
                    ],
                  ),
                )
                .animate()
                .fade(duration: 400.ms)
                .scale(duration: 400.ms, curve: Curves.easeOutBack),
                
                const SizedBox(height: 24),
                
                // Recommended products header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Recommended Products', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    TextButton(
                      onPressed: () => context.push('/patient/skincare'),
                      child: const Text('Go to Shop', style: TextStyle(color: AppColors.primaryTeal, fontWeight: FontWeight.bold, fontSize: 12)),
                    )
                  ],
                ),
                const SizedBox(height: 12),
                
                // Horizontal scroll recommended products
                SizedBox(
                  height: 174,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _recommendationCard(
                        context,
                        'Hyaluronic Hydrating Gel',
                        '₹280',
                        'https://images.unsplash.com/photo-1601049541289-9b1b7bbbfe19?auto=format&fit=crop&q=80&w=200',
                        'med_6',
                      ),
                      const SizedBox(width: 12),
                      _recommendationCard(
                        context,
                        'Niacinamide Serum 10%',
                        '₹399',
                        'https://images.unsplash.com/photo-1620916566398-39f1143ab7be?auto=format&fit=crop&q=80&w=200',
                        'med_7',
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                CustomButton(
                  text: 'Scan Again',
                  isOutline: true,
                  onPressed: _startScan,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _recommendationCard(BuildContext context, String name, String price, String imgUrl, String id) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () => context.push('/patient/skincare/$id'),
      child: Container(
        width: 140,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isDark ? Colors.white10 : AppColors.borderLight),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(imgUrl, height: 90, width: double.infinity, fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                  const SizedBox(height: 4),
                  Text(price, style: const TextStyle(color: AppColors.primaryPurple, fontWeight: FontWeight.bold, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
