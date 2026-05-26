import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../services/ai_chat_service.dart';

class AiHealthAssistantScreen extends StatefulWidget {
  const AiHealthAssistantScreen({super.key});

  @override
  State<AiHealthAssistantScreen> createState() => _AiHealthAssistantScreenState();
}

class _AiHealthAssistantScreenState extends State<AiHealthAssistantScreen> {
  final _aiService = AiChatService();
  final _textController = TextEditingController();
  final _scrollController = ScrollController();

  final List<Map<String, dynamic>> _messages = [
    {
      'sender': 'ai',
      'text': 'Hello! I am your AI Health Assistant. Tell me how you are feeling, and I can give you educational guidance or suggest a specialist doctor.',
      'time': 'Just now',
    }
  ];

  bool _isTyping = false;

  void _sendMessage(String query) async {
    if (query.trim().isEmpty) return;

    setState(() {
      _messages.add({
        'sender': 'user',
        'text': query,
        'time': 'Just now',
      });
      _isTyping = true;
    });
    _textController.clear();
    _scrollToBottom();

    // Get response from AI service
    final reply = await _aiService.getAiReply(query);

    if (mounted) {
      setState(() {
        _isTyping = false;
        _messages.add({
          'sender': 'ai',
          'text': reply,
          'time': 'Just now',
        });
      });
      _scrollToBottom();
    }
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
    final suggestions = _aiService.getQuickSuggestions();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Health Assistant', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Prominent Disclaimer Card at Top
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.error.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 24),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'This AI assistant provides educational guidance only and not medical diagnosis.',
                        style: TextStyle(fontSize: 11, color: AppColors.error, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Message list
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  final isAi = msg['sender'] == 'ai';
                  return _buildChatBubble(msg['text'] as String, isAi);
                },
              ),
            ),

            // Typing Indicator
            if (_isTyping)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                child: Row(
                  children: [
                    const Text('AI is thinking', style: TextStyle(fontSize: 11, color: AppColors.textSecondaryLight)),
                    const SizedBox(width: 8),
                    const SizedBox(
                      width: 12,
                      height: 12,
                      child: CircularProgressIndicator(strokeWidth: 1.5, valueColor: AlwaysStoppedAnimation(AppColors.primaryTeal)),
                    ),
                  ],
                ),
              ),

            // Suggestion chips (only visible if input is clear)
            if (_textController.text.isEmpty && !_isTyping)
              SizedBox(
                height: 48,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: suggestions.length,
                  itemBuilder: (context, index) {
                    final suggestion = suggestions[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ActionChip(
                        label: Text(suggestion, style: const TextStyle(fontSize: 12)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        onPressed: () => _sendMessage(suggestion),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),

            // Input panel
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : Colors.white,
                border: Border(top: BorderSide(color: isDark ? Colors.white10 : AppColors.borderLight)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: TextField(
                        controller: _textController,
                        style: const TextStyle(fontSize: 14),
                        decoration: const InputDecoration(
                          hintText: 'Type symptoms (e.g. fever, tooth ache)...',
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        onSubmitted: (val) => _sendMessage(val),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: AppColors.primaryTeal,
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white, size: 18),
                      onPressed: () => _sendMessage(_textController.text),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatBubble(String text, bool isAi) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Align(
      alignment: isAi ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isAi
            ? (isDark ? const Color(0xFF1E293B) : Colors.white)
            : AppColors.primaryTeal,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isAi ? 0 : 16),
            bottomRight: Radius.circular(isAi ? 16 : 0),
          ),
          border: isAi ? Border.all(color: isDark ? Colors.white10 : AppColors.borderLight) : null,
          boxShadow: const [
            BoxShadow(
              color: Color(0x02000000),
              blurRadius: 4,
              offset: Offset(0, 2),
            )
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isAi 
              ? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight) 
              : Colors.white,
            fontSize: 13.5,
            height: 1.4,
          ),
        ),
      ),
    );
  }
}
