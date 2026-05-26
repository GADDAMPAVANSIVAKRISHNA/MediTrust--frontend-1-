import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_theme.dart';
import '../../models/models.dart';
import '../../providers/providers.dart';
import '../../services/booking_service.dart';
import '../../services/doctor_service.dart';
import '../../widgets/widgets.dart';

class BookAppointmentScreen extends ConsumerStatefulWidget {
  final String doctorId;
  const BookAppointmentScreen({super.key, required this.doctorId});

  @override
  ConsumerState<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends ConsumerState<BookAppointmentScreen> {
  final _doctorService = DoctorService();
  final _bookingService = BookingService();

  DoctorModel? _doctor;
  bool _isLoadingProfile = true;
  bool _isBooking = false;

  DateTime _selectedDate = DateTime.now().add(const Duration(days: 2)); // Default to Wed 07
  String _selectedSlot = '';
  String _consultationType = 'Video Call'; // 'Video Call' or 'In-clinic Visit'

  final List<DateTime> _datesList = List.generate(
    14, 
    (index) => DateTime.now().add(Duration(days: index)),
  );

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void _loadProfile() async {
    final result = await _doctorService.getDoctorById(widget.doctorId);
    setState(() {
      _doctor = result;
      _isLoadingProfile = false;
      if (result != null && result.availableSlots.isNotEmpty) {
        _selectedSlot = result.availableSlots[2]; // Default to index 2 (11:00 AM)
      }
    });
  }

  void _confirmBooking() async {
    if (_doctor == null) return;
    if (_selectedSlot.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a time slot')));
      return;
    }

    setState(() => _isBooking = true);
    
    final authState = ref.read(authProvider);
    final fee = _consultationType == 'Video Call' ? _doctor!.feeVideo : _doctor!.feeVisit;

    await _bookingService.createBooking(
      doctorId: _doctor!.id,
      doctorName: _doctor!.name,
      doctorSpecialization: _doctor!.specialization,
      doctorImage: _doctor!.imageUrl,
      patientId: authState?.id ?? 'usr_mock_123',
      patientName: authState?.name ?? 'Sarah Johnson',
      date: _selectedDate,
      slot: _selectedSlot,
      consultationType: _consultationType,
      fee: fee,
    );

    setState(() => _isBooking = false);

    if (mounted) {
      context.go(
        '/success?message=Your appointment with ${_doctor!.name} has been successfully booked on ${DateFormat('MMMM dd, yyyy').format(_selectedDate)} at $_selectedSlot!&next=/patient/home',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingProfile) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_doctor == null) {
      return const Scaffold(body: Center(child: Text('Doctor profile error.')));
    }

    final doc = _doctor!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Appointment', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    // Selected doctor card snippet
                    GlassCard(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundImage: NetworkImage(doc.imageUrl),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                doc.name,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                doc.specialization,
                                style: const TextStyle(color: AppColors.primaryTeal, fontSize: 13, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Date Selector
                    const Text('Select Date', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 74,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _datesList.length,
                        itemBuilder: (context, index) {
                          final date = _datesList[index];
                          final isSelected = DateFormat('yyyyMMdd').format(_selectedDate) == DateFormat('yyyyMMdd').format(date);
                          final dayName = DateFormat('E').format(date);
                          final dayNum = DateFormat('dd').format(date);

                          return GestureDetector(
                            onTap: () {
                              setState(() => _selectedDate = date);
                            },
                            child: Container(
                              width: 54,
                              margin: const EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                color: isSelected 
                                  ? AppColors.primaryTeal 
                                  : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF9FAFB)),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected ? AppColors.primaryTeal : (isDark ? Colors.white10 : AppColors.borderLight),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    dayName,
                                    style: TextStyle(
                                      color: isSelected ? Colors.white70 : AppColors.textSecondaryLight,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    dayNum,
                                    style: TextStyle(
                                      color: isSelected ? Colors.white : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 24),
                    
                    // Time slot selector
                    const Text('Select Time', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 2.3,
                      ),
                      itemCount: doc.availableSlots.length,
                      itemBuilder: (context, index) {
                        final slot = doc.availableSlots[index];
                        final isSelected = _selectedSlot == slot;
                        return GestureDetector(
                          onTap: () {
                            setState(() => _selectedSlot = slot);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSelected 
                                ? AppColors.primaryTeal 
                                : (isDark ? const Color(0xFF1E293B) : Colors.white),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isSelected ? AppColors.primaryTeal : (isDark ? Colors.white10 : AppColors.borderLight),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                slot,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected ? Colors.white : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 24),
                    
                    // Consultation Type Selector
                    const Text('Consultation Type', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _typeCard(
                            label: 'Video Call',
                            icon: Icons.videocam_rounded,
                            isSelected: _consultationType == 'Video Call',
                            onTap: () => setState(() => _consultationType = 'Video Call'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _typeCard(
                            label: 'In-clinic Visit',
                            icon: Icons.local_hospital_rounded,
                            isSelected: _consultationType == 'In-clinic Visit',
                            onTap: () => setState(() => _consultationType = 'In-clinic Visit'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            
            // Booking Summary & Button
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : Colors.white,
                border: Border(top: BorderSide(color: isDark ? Colors.white10 : AppColors.borderLight)),
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Total Price',
                        style: TextStyle(color: AppColors.textSecondaryLight, fontSize: 12),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '₹${(_consultationType == 'Video Call' ? doc.feeVideo : doc.feeVisit).toInt()}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: AppColors.primaryPurple),
                      ),
                    ],
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: CustomButton(
                      text: 'Confirm Booking',
                      isLoading: _isBooking,
                      onPressed: _confirmBooking,
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

  Widget _typeCard({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected 
            ? AppColors.primaryTeal.withOpacity(0.1) 
            : (isDark ? const Color(0xFF1E293B) : Colors.white),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primaryTeal : (isDark ? Colors.white10 : AppColors.borderLight),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isSelected ? AppColors.primaryTeal : AppColors.textSecondaryLight, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: isSelected ? AppColors.primaryTeal : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
