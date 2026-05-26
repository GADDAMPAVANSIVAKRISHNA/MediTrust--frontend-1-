import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_theme.dart';
import '../../models/models.dart';
import '../../providers/providers.dart';
import '../../services/booking_service.dart';
import '../../widgets/widgets.dart';

class PatientAppointmentsScreen extends ConsumerStatefulWidget {
  const PatientAppointmentsScreen({super.key});

  @override
  ConsumerState<PatientAppointmentsScreen> createState() => _PatientAppointmentsScreenState();
}

class _PatientAppointmentsScreenState extends ConsumerState<PatientAppointmentsScreen> with SingleTickerProviderStateMixin {
  final _bookingService = BookingService();
  late TabController _tabController;
  List<AppointmentModel> _appointments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadAppointments();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadAppointments() async {
    final authState = ref.read(authProvider);
    final results = await _bookingService.getBookings(authState?.id ?? 'usr_mock_123');
    setState(() {
      _appointments = results;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final upcoming = _appointments.where((a) => a.status == 'upcoming').toList();
    // Pre-load a mock past appointment for rich presentation
    final past = [
      AppointmentModel(
        id: 'apt_past_1',
        doctorId: 'doc_1',
        doctorName: 'Dr. Priya Sharma',
        doctorSpecialization: 'Cardiologist',
        doctorImage: 'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?auto=format&fit=crop&q=80&w=150',
        patientId: 'usr_mock_123',
        patientName: 'Sarah Johnson',
        dateTime: DateTime.now().subtract(const Duration(days: 3)),
        timeSlot: '11:00 AM - 11:30 AM',
        status: 'completed',
        consultationType: 'Video Call',
        fee: 600,
      )
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Appointments', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primaryTeal,
          unselectedLabelColor: AppColors.textSecondaryLight,
          indicatorColor: AppColors.primaryTeal,
          tabs: const [
            Tab(text: 'Upcoming'),
            Tab(text: 'Past History'),
          ],
        ),
      ),
      body: SafeArea(
        child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildList(context, upcoming, isUpcoming: true),
                _buildList(context, past, isUpcoming: false),
              ],
            ),
      ),
    );
  }

  Widget _buildList(BuildContext context, List<AppointmentModel> list, {required bool isUpcoming}) {
    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_today_outlined, size: 64, color: AppColors.textSecondaryLight.withOpacity(0.5)),
            const SizedBox(height: 12),
            Text('No appointments found', style: const TextStyle(color: AppColors.textSecondaryLight)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final apt = list[index];
        return GlassCard(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundImage: NetworkImage(apt.doctorImage),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          apt.doctorName,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          apt.doctorSpecialization,
                          style: const TextStyle(color: AppColors.primaryTeal, fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isUpcoming ? AppColors.primaryTeal.withOpacity(0.08) : AppColors.success.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      apt.consultationType,
                      style: TextStyle(
                        color: isUpcoming ? AppColors.primaryTeal : AppColors.success,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: Divider(height: 1, color: AppColors.borderLight),
              ),
              Row(
                children: [
                  const Icon(Icons.access_time, color: AppColors.textSecondaryLight, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    '${DateFormat('MMM dd, yyyy').format(apt.dateTime)}  •  ${apt.timeSlot}',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Action Buttons
              if (isUpcoming)
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: apt.consultationType == 'Video Call' ? 'Join Video Consultation' : 'Get Location Address',
                        height: 40,
                        borderRadius: 10,
                        onPressed: () {
                          if (apt.consultationType == 'Video Call') {
                            context.push('/patient/video/${apt.id}');
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Address: Grace Cardiology Clinic, 4th Block, Cityville')),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                )
              else
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: 'View Prescription',
                        height: 40,
                        borderRadius: 10,
                        isOutline: true,
                        onPressed: () => context.push('/patient/prescription/pr_1'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomButton(
                        text: 'Book Again',
                        height: 40,
                        borderRadius: 10,
                        onPressed: () => context.push('/patient/book/${apt.doctorId}'),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}
