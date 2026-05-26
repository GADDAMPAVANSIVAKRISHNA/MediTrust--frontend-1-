import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../models/models.dart';
import '../../widgets/widgets.dart';

class ChatScreen extends StatefulWidget {
  final String doctorId;
  const ChatScreen({super.key, required this.doctorId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<MessageModel> _messages = [
    MessageModel(
      id: 'm1',
      senderId: 'doc_1',
      receiverId: 'usr_mock_123',
      content: 'Hello Sarah, I have reviewed your blood pressure logs.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
    ),
    MessageModel(
      id: 'm2',
      senderId: 'usr_mock_123',
      receiverId: 'doc_1',
      content: 'Hello Doctor, is it normal? I feel a little heavy sometimes.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 8)),
    ),
    MessageModel(
      id: 'm3',
      senderId: 'doc_1',
      receiverId: 'usr_mock_123',
      content: 'Your systolic is slightly elevated. Drink plenty of water and rest. I am sharing your prescription.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    MessageModel(
      id: 'm4',
      senderId: 'doc_1',
      receiverId: 'usr_mock_123',
      content: '',
      timestamp: DateTime.now().subtract(const Duration(minutes: 4)),
      isPrescription: true,
      mediaUrl: 'pr_1',
    ),
    MessageModel(
      id: 'm5',
      senderId: 'doc_1',
      receiverId: 'usr_mock_123',
      content: 'Voice note detailing prescription schedule',
      timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
      isAudio: true,
      audioDuration: '0:24',
    ),
  ];

  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isTyping = false;
  String _status = 'Online';

  void _sendMessage({
    String? content,
    bool isAudio = false,
    bool isImage = false,
    bool isPrescription = false,
    String mediaUrl = '',
    String audioDuration = '',
  }) {
    final text = content ?? _textController.text;
    if (text.isEmpty && !isAudio && !isImage && !isPrescription) return;

    final newMsg = MessageModel(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      senderId: 'usr_mock_123',
      receiverId: widget.doctorId,
      content: text,
      timestamp: DateTime.now(),
      isAudio: isAudio,
      isImage: isImage,
      isPrescription: isPrescription,
      mediaUrl: mediaUrl,
      audioDuration: audioDuration,
    );

    setState(() {
      _messages.add(newMsg);
      if (content == null) _textController.clear();
    });

    _scrollToBottom();

    // Trigger Doctor typing reply mock
    setState(() {
      _isTyping = true;
      _status = 'Typing...';
    });

    Timer(const Duration(milliseconds: 2500), () {
      if (mounted) {
        setState(() {
          _isTyping = false;
          _status = 'Online';
          _messages.add(MessageModel(
            id: 'msg_reply_${DateTime.now().millisecondsSinceEpoch}',
            senderId: widget.doctorId,
            receiverId: 'usr_mock_123',
            content: 'Please start the medications today and let me know if you experience any side effects.',
            timestamp: DateTime.now(),
          ));
        });
        _scrollToBottom();
      }
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            const CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage(
                'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?auto=format&fit=crop&q=80&w=100',
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Dr. Priya Sharma',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Text(
                  _status,
                  style: TextStyle(
                    fontSize: 11,
                    color: _isTyping ? AppColors.primaryTeal : AppColors.textSecondaryLight,
                    fontWeight: _isTyping ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.videocam_rounded), onPressed: () => context.push('/patient/video/apt_1')),
          IconButton(icon: const Icon(Icons.call_rounded), onPressed: () {}),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkBg : const Color(0xFFF3F4F6),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Message Logs
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final message = _messages[index];
                    final isMe = message.senderId == 'usr_mock_123';
                    return _buildMessageBubble(context, message, isMe);
                  },
                ),
              ),

              // Bottom Input Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardDark : Colors.white,
                  border: Border(top: BorderSide(color: isDark ? Colors.white10 : AppColors.borderLight)),
                ),
                child: Row(
                  children: [
                    // Attachment Plus Menu
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline, color: AppColors.primaryTeal, size: 26),
                      onPressed: () {
                        // Mock sharing an image
                        _sendMessage(
                          content: 'Attached scan report image',
                          isImage: true,
                          mediaUrl: 'https://images.unsplash.com/photo-1530026405186-ed1ea0ac7a63?auto=format&fit=crop&q=80&w=200',
                        );
                      },
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: TextField(
                          controller: _textController,
                          style: const TextStyle(fontSize: 14),
                          decoration: const InputDecoration(
                            hintText: 'Type a message...',
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                          onSubmitted: (_) => _sendMessage(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    // Voice Mic Shortcut
                    IconButton(
                      icon: const Icon(Icons.mic_none_outlined, color: AppColors.primaryTeal),
                      onPressed: () {
                        _sendMessage(isAudio: true, audioDuration: '0:12');
                      },
                    ),
                    // Send Button
                    IconButton(
                      icon: const Icon(Icons.send_rounded, color: AppColors.primaryTeal),
                      onPressed: () => _sendMessage(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageBubble(BuildContext context, MessageModel msg, bool isMe) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isMe 
            ? AppColors.primaryTeal 
            : (isDark ? const Color(0xFF1E293B) : Colors.white),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMe ? 16 : 0),
            bottomRight: Radius.circular(isMe ? 0 : 16),
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x04000000),
              blurRadius: 4,
              offset: Offset(0, 2),
            )
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle Prescription Share
            if (msg.isPrescription) ...[
              Row(
                children: [
                  const Icon(Icons.description_rounded, color: AppColors.primaryPurple, size: 24),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Prescription Shared', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        Text('Dr. Priya Sharma', style: TextStyle(fontSize: 10, color: AppColors.textSecondaryLight)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              CustomButton(
                text: 'View Prescription',
                height: 36,
                borderRadius: 8,
                isGradient: false,
                color: AppColors.primaryPurple,
                onPressed: () => context.push('/patient/prescription/${msg.mediaUrl}'),
              ),
            ]
            // Handle Image Share
            else if (msg.isImage) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(msg.mediaUrl, width: 200, height: 130, fit: BoxFit.cover),
              ),
              if (msg.content.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(msg.content, style: TextStyle(color: isMe ? Colors.white : (isDark ? Colors.white : Colors.black87), fontSize: 13)),
              ],
            ]
            // Handle Voice Notes
            else if (msg.isAudio) ...[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.play_circle_fill, color: isMe ? Colors.white : AppColors.primaryTeal, size: 28),
                  const SizedBox(width: 8),
                  // Simple waveform animation representation
                  Container(
                    width: 80,
                    height: 16,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(8, (i) => Container(
                        width: 3, 
                        height: (i % 2 == 0 ? 12.0 : 6.0), 
                        color: isMe ? Colors.white60 : AppColors.textSecondaryLight,
                      )),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    msg.audioDuration,
                    style: TextStyle(color: isMe ? Colors.white70 : AppColors.textSecondaryLight, fontSize: 11),
                  ),
                ],
              ),
            ]
            // Normal Text Message
            else ...[
              Text(
                msg.content,
                style: TextStyle(
                  color: isMe ? Colors.white : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                  fontSize: 14,
                ),
              ),
            ],
            const SizedBox(height: 4),
            // Timestamp
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '10:30 AM',
                  style: TextStyle(
                    fontSize: 9,
                    color: isMe ? Colors.white70 : AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
