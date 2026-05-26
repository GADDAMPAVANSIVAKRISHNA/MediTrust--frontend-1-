import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/widgets.dart';

class DoctorPatientsScreen extends StatelessWidget {
  const DoctorPatientsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mockPatients = [
      {'name': 'Sarah Johnson', 'age': '28', 'gender': 'Female', 'city': 'Cityville', 'lastVisit': 'May 24, 2026', 'avatar': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&q=80&w=100'},
      {'name': 'James Smith', 'age': '42', 'gender': 'Male', 'city': 'Cityville', 'lastVisit': 'May 20, 2026', 'avatar': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&q=80&w=100'},
      {'name': 'Emma Watson', 'age': '31', 'gender': 'Female', 'city': 'Townsville', 'lastVisit': 'May 18, 2026', 'avatar': 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?auto=format&fit=crop&q=80&w=100'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Patients', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          itemCount: mockPatients.length,
          itemBuilder: (context, index) {
            final pat = mockPatients[index];
            return GlassCard(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: NetworkImage(pat['avatar']!),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pat['name']!,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${pat['age']} yrs • ${pat['gender']} • ${pat['city']}',
                          style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryLight),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Last Visit: ${pat['lastVisit']}',
                          style: const TextStyle(fontSize: 10, color: AppColors.primaryTeal, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.info_outline, color: AppColors.primaryPurple),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Opening medical history for ${pat['name']}...')),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
