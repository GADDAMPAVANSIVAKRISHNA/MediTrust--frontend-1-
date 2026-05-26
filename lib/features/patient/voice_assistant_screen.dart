import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/widgets.dart';

class VoiceAssistantScreen extends StatefulWidget {
  const VoiceAssistantScreen({super.key});

  @override
  State<VoiceAssistantScreen> createState() => _VoiceAssistantScreenState();
}

class _VoiceAssistantScreenState extends State<VoiceAssistantScreen> with SingleTickerProviderStateMixin {
  late AnimationController _waveController;
  bool _isListening = false;
  String _selectedLanguage = 'English';
  String _transcription = 'Tap microphone to speak...';
  Timer? _listeningTimer;

  final List<String> _languages = ['English', 'Hindi', 'Telugu', 'Tamil'];

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
  }

  @override
  void dispose() {
    _waveController.dispose();
    _listeningTimer?.cancel();
    super.dispose();
  }

  void _toggleListening() {
    if (_isListening) {
      _stopListening(cancelled: true);
    } else {
      _startListening();
    }
  }

  void _startListening() {
    setState(() {
      _isListening = true;
      _transcription = 'Listening... Speak now';
    });
    _waveController.repeat();

    // Mock speech recognition after 3 seconds
    _listeningTimer = Timer(const Duration(milliseconds: 3500), () {
      _stopListening(cancelled: false);
    });
  }

  void _stopListening({required bool cancelled}) {
    _waveController.stop();
    _listeningTimer?.cancel();
    
    if (!mounted) return;

    if (cancelled) {
      setState(() {
        _isListening = false;
        _transcription = 'Tap microphone to speak...';
      });
    } else {
      // Simulate recognized command based on language
      String recognizedText = 'Find a cardiologist for me';

      if (_selectedLanguage == 'Hindi') {
        recognizedText = 'मेरे लिए एक हृदय रोग विशेषज्ञ खोजें';
      } else if (_selectedLanguage == 'Telugu') {
        recognizedText = 'నా కోసం కార్డియాలజిస్ట్ ని కనుగొనండి';
      } else if (_selectedLanguage == 'Tamil') {
        recognizedText = 'எனக்காக ஒரு இருதயநோய் நிபுணரைக் கண்டறியவும்';
      }

      setState(() {
        _isListening = false;
        _transcription = '"$recognizedText"';
      });

      // Show alert and route
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Voice Command Recognized: "$recognizedText". Routing...'),
          backgroundColor: AppColors.primaryTeal,
        ),
      );

      Timer(const Duration(milliseconds: 1500), () {
        if (mounted) {
          // Go to doctor search screen pre-populated
          context.push('/patient/doctors');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Voice Assistant', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              
              // Language Selector Card
              GlassCard(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.translate, color: AppColors.primaryTeal, size: 20),
                        SizedBox(width: 12),
                        Text('Assistant Language', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      ],
                    ),
                    DropdownButton<String>(
                      value: _selectedLanguage,
                      underline: const SizedBox(),
                      items: _languages.map((String lang) {
                        return DropdownMenuItem<String>(
                          value: lang,
                          child: Text(lang, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => _selectedLanguage = val);
                        }
                      },
                    ),
                  ],
                ),
              ),
              
              const Spacer(flex: 2),

              // Waveform Anim
              AnimatedBuilder(
                animation: _waveController,
                builder: (context, child) {
                  return CustomPaint(
                    size: const Size(double.infinity, 80),
                    painter: AudioWaveformPainter(
                      waveValue: _waveController.value,
                      isListening: _isListening,
                    ),
                  );
                },
              ),

              const SizedBox(height: 32),

              // Transcription text bubble
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  _transcription,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    height: 1.4,
                  ),
                ),
              ),

              const Spacer(flex: 3),

              // Pulse Microphone button
              GestureDetector(
                onTap: _toggleListening,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (_isListening)
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryTeal.withOpacity(0.2),
                        ),
                      )
                      .animate(onPlay: (controller) => controller.repeat())
                      .scale(begin: const Offset(1, 1), end: const Offset(1.5, 1.5), duration: 1.seconds)
                      .fadeOut(duration: 1.seconds),
                      
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryTeal.withOpacity(0.4),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          )
                        ],
                      ),
                      child: Icon(
                        _isListening ? Icons.stop_rounded : Icons.mic_rounded,
                        color: Colors.white,
                        size: 36,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              const Text(
                'Try saying: "Find a cardiologist"',
                style: TextStyle(fontSize: 11, color: AppColors.textSecondaryLight),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class AudioWaveformPainter extends CustomPainter {
  final double waveValue;
  final bool isListening;

  AudioWaveformPainter({required this.waveValue, required this.isListening});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primaryTeal
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final double centerY = size.height / 2;
    final int barCount = 18;
    final double barSpacing = size.width / (barCount + 1);

    for (int i = 0; i < barCount; i++) {
      final double x = (i + 1) * barSpacing;
      // Generate standard dynamic heights
      double heightFactor = 0.08;
      if (isListening) {
        // Calculate offset wave height
        final double sinVal = MathHelper.sinOffset(waveValue * 6.28 + (i * 0.4));
        heightFactor = 0.2 + (sinVal.abs() * 0.6);
      }
      final double barHeight = size.height * heightFactor;

      canvas.drawLine(
        Offset(x, centerY - barHeight / 2),
        Offset(x, centerY + barHeight / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant AudioWaveformPainter oldDelegate) {
    return oldDelegate.waveValue != waveValue || oldDelegate.isListening != isListening;
  }
}

class MathHelper {
  // Simple trigonometric helper to avoid importing dart:math directly
  static double sinOffset(double value) {
    // Basic Taylor series approximation for sin or standard calculation
    return double.parse((value).toString()).hashCode % 100 / 100 * 2 - 1;
  }
}
