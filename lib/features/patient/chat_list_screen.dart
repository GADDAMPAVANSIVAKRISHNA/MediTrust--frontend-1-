import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';

class PatientChatListScreen extends StatelessWidget {
  const PatientChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final mockChats = [
      {
        'id': 'doc_1',
        'name': 'Dr. Priya Sharma',
        'specialty': 'Cardiologist',
        'avatar': 'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?auto=format&fit=crop&q=80&w=150',
        'lastMsg': 'Voice note detailing prescription schedule',
        'time': '10:30 AM',
        'unread': 0,
        'online': true,
      },
      {
        'id': 'doc_3',
        'name': 'Dr. Neha Gupta',
        'specialty': 'Dentist',
        'avatar': 'https://images.unsplash.com/photo-1594824813573-246434e33963?auto=format&fit=crop&q=80&w=150',
        'lastMsg': 'Please bring your previous dental x-rays.',
        'time': 'Yesterday',
        'unread': 2,
        'online': false,
      },
      {
        'id': 'doc_4',
        'name': 'Dr. Rohan Mehta',
        'specialty': 'Neurologist',
        'avatar': 'https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?auto=format&fit=crop&q=80&w=150',
        'lastMsg': 'The prescription has been generated.',
        'time': 'May 20',
        'unread': 0,
        'online': true,
      }
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Consultations Chat', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Chat Info Alert Header
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.primaryTeal.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: AppColors.primaryTeal, size: 20),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Chats are available for 30 days after your consultation booking.',
                        style: TextStyle(fontSize: 12, color: AppColors.primaryTeal, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Active list
            Expanded(
              child: ListView.builder(
                itemCount: mockChats.length,
                itemBuilder: (context, index) {
                  final chat = mockChats[index];
                  return Column(
                    children: [
                      ListTile(
                        leading: Stack(
                          children: [
                            CircleAvatar(
                              radius: 26,
                              backgroundImage: NetworkImage(chat['avatar'] as String),
                              backgroundColor: AppColors.primaryTeal.withOpacity(0.1),
                            ),
                            if (chat['online'] as bool)
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  width: 14,
                                  height: 14,
                                  decoration: BoxDecoration(
                                    color: AppColors.success,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: isDark ? AppColors.cardDark : Colors.white, width: 2.5),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              chat['name'] as String,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            Text(
                              chat['time'] as String,
                              style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryLight),
                            ),
                          ],
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  chat['lastMsg'] as String,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: (chat['unread'] as int) > 0 
                                      ? (isDark ? Colors.white : Colors.black87) 
                                      : AppColors.textSecondaryLight,
                                    fontWeight: (chat['unread'] as int) > 0 ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                              ),
                              if ((chat['unread'] as int) > 0)
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(
                                    color: AppColors.primaryTeal,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    chat['unread'].toString(),
                                    style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        onTap: () {
                          context.push('/patient/chat/${chat['id']}');
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Divider(height: 1),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
