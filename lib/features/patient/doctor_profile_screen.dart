import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_theme.dart';
import '../../models/models.dart';
import '../../services/doctor_service.dart';
import '../../widgets/widgets.dart';

class DoctorProfileScreen extends StatefulWidget {
  final String doctorId;
  const DoctorProfileScreen({super.key, required this.doctorId});

  @override
  State<DoctorProfileScreen> createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  final _doctorService = DoctorService();
  DoctorModel? _doctor;
  bool _isLoading = true;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void _loadProfile() async {
    final result = await _doctorService.getDoctorById(widget.doctorId);
    setState(() {
      _doctor = result;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_doctor == null) {
      return const Scaffold(body: Center(child: Text('Doctor profile not found.')));
    }

    final doc = _doctor!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          // Content Layout
          Positioned.fill(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Large Header Image
                  Hero(
                    tag: 'doc-img-${doc.id}',
                    child: Container(
                      height: 380,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(doc.imageUrl),
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter,
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.4),
                              Colors.transparent,
                              isDark ? AppColors.darkBg : AppColors.lightBg,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  // Detail Card Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Doctor Title & Specialization
                        Text(
                          doc.name,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Text(
                              '${doc.specialization}  •  ${doc.experienceYears} yrs exp',
                              style: const TextStyle(
                                color: AppColors.primaryTeal,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'MBBS, MD - Cardiology',
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          ),
                        ),
                        const SizedBox(height: 8),
                        
                        // Rating stars summary
                        Row(
                          children: [
                            const Icon(Icons.star_rounded, color: AppColors.warning, size: 18),
                            const SizedBox(width: 4),
                            Text(
                              '${doc.rating} (${doc.reviewsCount} reviews)',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        
                        // Statistics Cards Row (Patients, Experience, Rating)
                        Row(
                          children: [
                            Expanded(child: _statCard('Patients', '1200+', isDark)),
                            const SizedBox(width: 12),
                            Expanded(child: _statCard('Experience', '${doc.experienceYears} yrs', isDark)),
                            const SizedBox(width: 12),
                            Expanded(child: _statCard('Rating', '${doc.rating}', isDark)),
                          ],
                        )
                        .animate()
                        .fade(duration: 500.ms)
                        .slideY(begin: 0.1, end: 0, duration: 500.ms),
                        
                        const SizedBox(height: 24),
                        
                        // About Doctor
                        const Text(
                          'About Doctor',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          doc.about,
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        // Consultation Fee and Availability
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Consultation Fee',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textSecondaryLight,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '₹${doc.feeVideo.toInt()}',
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryPurple,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: doc.isAvailableToday 
                                  ? AppColors.success.withOpacity(0.1) 
                                  : AppColors.warning.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 4,
                                    backgroundColor: doc.isAvailableToday ? AppColors.success : AppColors.warning,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    doc.isAvailableToday ? 'Available Today' : 'Available Tomorrow',
                                    style: TextStyle(
                                      color: doc.isAvailableToday ? AppColors.success : AppColors.warning,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 100), // Spacing for floating button
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Back & Favorite floating top app bar
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white.withOpacity(0.8),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimaryLight, size: 18),
                    onPressed: () => context.pop(),
                  ),
                ),
                CircleAvatar(
                  backgroundColor: Colors.white.withOpacity(0.8),
                  child: IconButton(
                    icon: Icon(
                      _isFavorite ? Icons.favorite : Icons.favorite_border_rounded,
                      color: _isFavorite ? AppColors.error : AppColors.textPrimaryLight,
                      size: 20,
                    ),
                    onPressed: () => setState(() => _isFavorite = !_isFavorite),
                  ),
                ),
              ],
            ),
          ),
          
          // Fixed Bottom Booking Trigger
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: CustomButton(
              text: 'Book Appointment',
              onPressed: () {
                context.push('/patient/book/${doc.id}');
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard(String label, String value, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.white10 : AppColors.borderLight),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryTeal,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }
}
