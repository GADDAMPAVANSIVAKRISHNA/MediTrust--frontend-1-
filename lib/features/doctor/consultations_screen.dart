import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/widgets.dart';

class DoctorConsultationsScreen extends StatelessWidget {
  const DoctorConsultationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final consultations = [
      {
        'id': 'apt_1',
        'patient': 'Sarah Johnson',
        'time': '09:30 AM',
        'date': 'Today',
        'type': 'Video Call',
        'status': 'Active',
      },
      {
        'id': 'apt_2',
        'patient': 'James Smith',
        'time': '11:15 AM',
        'date': 'Today',
        'type': 'In-clinic Visit',
        'status': 'Pending',
      },
      {
        'id': 'apt_3',
        'patient': 'Emma Watson',
        'time': '02:00 PM',
        'date': 'Today',
        'type': 'Video Call',
        'status': 'Pending',
      },
      {
        'id': 'apt_4',
        'patient': 'John Davis',
        'time': '10:00 AM',
        'date': 'Tomorrow',
        'type': 'Video Call',
        'status': 'Scheduled',
      }
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Consultation Logs', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: consultations.length,
          itemBuilder: (context, index) {
            final consult = consultations[index];
            final isActive = consult['status'] == 'Active';
            final isVideo = consult['type'] == 'Video Call';

            return GlassCard(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          consult['patient']!,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(isVideo ? Icons.videocam : Icons.local_hospital, size: 14, color: AppColors.primaryTeal),
                            const SizedBox(width: 6),
                            Text(
                              '${consult['type']} • ${consult['time']}',
                              style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryLight),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Schedule Date: ${consult['date']}',
                          style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryLight),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          if (isVideo) {
                            context.push('/patient/video/${consult['id']}');
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Starting In-clinic checkout...')),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isActive ? AppColors.primaryTeal : AppColors.primaryPurple,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text(isActive ? 'Join Call' : 'Begin', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () => context.push('/doctor/create-prescription/${consult['id']}'),
                        child: const Text(
                          'Write Prescription',
                          style: TextStyle(
                            color: AppColors.primaryPurple,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
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
