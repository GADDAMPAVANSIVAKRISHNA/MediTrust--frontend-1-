import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';

class VideoCallScreen extends StatefulWidget {
  final String appointmentId;
  const VideoCallScreen({super.key, required this.appointmentId});

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  bool _isMuted = false;
  bool _isCamOff = false;
  bool _showChatOverlay = false;
  
  final List<String> _chatMessages = [
    'Hello Sarah, I am reviewing your blood pressure records.',
    'Do you feel any chest heaviness or palpitations recently?',
  ];
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  int _timerSeconds = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() => _timerSeconds++);
      }
    });
  }

  String _formatDuration(int totalSecs) {
    final mins = totalSecs ~/ 60;
    final secs = totalSecs % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      setState(() {
        _chatMessages.add(_messageController.text);
      });
      _messageController.clear();
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
      
      // Auto reply mock from doctor after 2 seconds
      Timer(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _chatMessages.add("I understand, let me write down a prescription for you.");
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Full Screen Doctor Camera Feed (Placeholder Image)
          Positioned.fill(
            child: _isCamOff 
              ? Container(
                  color: AppColors.darkBg,
                  child: const Center(
                    child: Icon(Icons.videocam_off_rounded, color: Colors.white38, size: 64),
                  ),
                )
              : Image.network(
                  'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?auto=format&fit=crop&q=80&w=600',
                  fit: BoxFit.cover,
                ),
          ),
          
          // Doctor Info Overlay (Top Left)
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Dr. Priya Sharma',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    shadows: [Shadow(blurRadius: 8, color: Colors.black54)],
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(radius: 3, backgroundColor: AppColors.success),
                      const SizedBox(width: 6),
                      Text(
                        _formatDuration(_timerSeconds),
                        style: const TextStyle(color: Colors.white70, fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Floating Patient PIP View (Top Right)
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            right: 20,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: 100,
                height: 140,
                color: Colors.grey[900],
                child: Stack(
                  children: [
                    Image.network(
                      'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&q=80&w=150',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.mic, color: Colors.white, size: 10),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Sliding Chat Overlay Panel
          if (_showChatOverlay)
            Positioned(
              left: 20,
              right: 20,
              bottom: 110,
              child: Container(
                height: 240,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white24),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Chat Overlay', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                        GestureDetector(
                          onTap: () => setState(() => _showChatOverlay = false),
                          child: const Icon(Icons.close, color: Colors.white70, size: 18),
                        ),
                      ],
                    ),
                    const Divider(color: Colors.white10),
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: _chatMessages.length,
                        itemBuilder: (context, index) {
                          final isDoctor = index % 2 == 0;
                          return Align(
                            alignment: isDoctor ? Alignment.centerLeft : Alignment.centerRight,
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: isDoctor ? Colors.white24 : AppColors.primaryTeal.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                _chatMessages[index],
                                style: const TextStyle(color: Colors.white, fontSize: 12),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                            decoration: const InputDecoration(
                              hintText: 'Type messages...',
                              hintStyle: TextStyle(color: Colors.white30),
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                            onSubmitted: (_) => _sendMessage(),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.send_rounded, color: AppColors.primaryTeal, size: 20),
                          onPressed: _sendMessage,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

          // Control Bar Buttons (Bottom Center)
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Mic Button
                _controlBtn(
                  icon: _isMuted ? Icons.mic_off_rounded : Icons.mic_rounded,
                  color: _isMuted ? AppColors.error : Colors.white24,
                  onTap: () => setState(() => _isMuted = !_isMuted),
                ),
                const SizedBox(width: 16),
                
                // End Call (Red Button)
                GestureDetector(
                  onTap: () {
                    // Navigate back or to success screen.
                    // Let's go to digital prescription after the call is ended!
                    context.go('/patient/prescription/pr_1');
                  },
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: const BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.call_end, color: Colors.white, size: 30),
                  ),
                ),
                const SizedBox(width: 16),

                // Cam Switch
                _controlBtn(
                  icon: _isCamOff ? Icons.videocam_off_rounded : Icons.videocam_rounded,
                  color: _isCamOff ? AppColors.error : Colors.white24,
                  onTap: () => setState(() => _isCamOff = !_isCamOff),
                ),
                const SizedBox(width: 16),

                // Chat Toggle Overlay
                _controlBtn(
                  icon: Icons.chat_bubble_outline_rounded,
                  color: _showChatOverlay ? AppColors.primaryTeal : Colors.white24,
                  onTap: () => setState(() => _showChatOverlay = !_showChatOverlay),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _controlBtn({required IconData icon, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white24),
        ),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }
}
