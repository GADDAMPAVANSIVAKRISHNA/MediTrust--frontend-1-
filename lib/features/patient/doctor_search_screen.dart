import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../models/models.dart';
import '../../services/doctor_service.dart';
import '../../widgets/widgets.dart';

class DoctorSearchScreen extends StatefulWidget {
  const DoctorSearchScreen({super.key});

  @override
  State<DoctorSearchScreen> createState() => _DoctorSearchScreenState();
}

class _DoctorSearchScreenState extends State<DoctorSearchScreen> {
  final _doctorService = DoctorService();
  final _searchController = TextEditingController();
  
  String _selectedSpecialty = 'All';
  List<DoctorModel> _doctors = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDoctors();
  }

  void _loadDoctors() async {
    setState(() => _isLoading = true);
    final results = await _doctorService.getDoctors(
      query: _searchController.text,
      specialization: _selectedSpecialty,
    );
    setState(() {
      _doctors = results;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final specialties = _doctorService.getSpecializations();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Your Doctor', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            onPressed: () {},
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Input & Filter Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (val) => _loadDoctors(),
                        decoration: const InputDecoration(
                          hintText: 'Search by name, specialty...',
                          prefixIcon: Icon(Icons.search, color: AppColors.textSecondaryLight),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Filter trigger
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.tune, color: AppColors.primaryTeal),
                      onPressed: () {
                        // Quick Reset Filter Shortcut
                        _searchController.clear();
                        setState(() => _selectedSpecialty = 'All');
                        _loadDoctors();
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Specialty Category Chips
            SizedBox(
              height: 56,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: specialties.length,
                itemBuilder: (context, index) {
                  final specialty = specialties[index];
                  final isSelected = _selectedSpecialty == specialty;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(
                        specialty,
                        style: TextStyle(
                          color: isSelected 
                            ? Colors.white 
                            : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 12,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: AppColors.primaryTeal,
                      backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF3F4F6),
                      checkmarkColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      side: BorderSide.none,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() => _selectedSpecialty = specialty);
                          _loadDoctors();
                        }
                      },
                    ),
                  );
                },
              ),
            ),

            // Doctor List Grid / View
            Expanded(
              child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _doctors.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.person_search_outlined, size: 64, color: AppColors.textSecondaryLight.withOpacity(0.5)),
                          const SizedBox(height: 12),
                          const Text('No doctors match your filters', style: TextStyle(color: AppColors.textSecondaryLight)),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      itemCount: _doctors.length,
                      itemBuilder: (context, index) {
                        final doctor = _doctors[index];
                        return _buildDoctorCard(context, doctor);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorCard(BuildContext context, DoctorModel doc) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return GlassCard(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      onTap: () {
        context.push('/patient/doctor/${doc.id}');
      },
      child: Row(
        children: [
          // Doctor Profile Pic
          Hero(
            tag: 'doc-img-${doc.id}',
            child: CircleAvatar(
              radius: 36,
              backgroundImage: NetworkImage(doc.imageUrl),
              backgroundColor: AppColors.primaryTeal.withOpacity(0.1),
            ),
          ),
          const SizedBox(width: 16),
          
          // Info Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      doc.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Rating
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, color: AppColors.warning, size: 16),
                        const SizedBox(width: 2),
                        Text(
                          doc.rating.toStringAsFixed(1),
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  doc.specialization,
                  style: const TextStyle(
                    color: AppColors.primaryTeal,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${doc.experienceYears} yrs exp  •  MBBS, MD',
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Availability Status
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: doc.isAvailableToday
                          ? AppColors.success.withOpacity(0.1)
                          : AppColors.warning.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        doc.isAvailableToday ? 'Available Today' : 'Available Tomorrow',
                        style: TextStyle(
                          color: doc.isAvailableToday ? AppColors.success : AppColors.warning,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // Fee
                    Text(
                      '₹${doc.feeVideo.toInt()}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryPurple,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
