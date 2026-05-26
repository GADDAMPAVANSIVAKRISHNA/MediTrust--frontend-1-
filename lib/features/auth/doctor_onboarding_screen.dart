import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/providers.dart';
import '../../widgets/widgets.dart';

class DoctorOnboardingScreen extends ConsumerStatefulWidget {
  const DoctorOnboardingScreen({super.key});

  @override
  ConsumerState<DoctorOnboardingScreen> createState() => _DoctorOnboardingScreenState();
}

class _DoctorOnboardingScreenState extends ConsumerState<DoctorOnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _clinicController = TextEditingController();
  final _specializationController = TextEditingController();
  final _expController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  
  final _feeChat = TextEditingController(text: '150');
  final _feeAudio = TextEditingController(text: '300');
  final _feeVideo = TextEditingController(text: '500');
  final _feeVisit = TextEditingController(text: '700');

  bool _isSubmitted = false;
  bool _isLoading = false;
  String _profilePhotoStatus = 'Not uploaded';
  String _licenseStatus = 'Not uploaded';

  @override
  void initState() {
    super.initState();
    final current = ref.read(authProvider);
    if (current != null) {
      _nameController.text = current.name;
    }
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      final details = {
        'name': _nameController.text,
        'clinicName': _clinicController.text,
        'specialization': _specializationController.text.isEmpty ? 'General Physician' : _specializationController.text,
        'experienceYears': int.tryParse(_expController.text) ?? 5,
        'phone': _phoneController.text,
        'address': _addressController.text,
        'feeChat': double.tryParse(_feeChat.text) ?? 100.0,
        'feeAudio': double.tryParse(_feeAudio.text) ?? 200.0,
        'feeVideo': double.tryParse(_feeVideo.text) ?? 300.0,
        'feeVisit': double.tryParse(_feeVisit.text) ?? 400.0,
      };

      await ref.read(authProvider.notifier).completeOnboarding(details);
      
      setState(() {
        _isLoading = false;
        _isSubmitted = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isSubmitted) {
      return _buildVerificationPendingView();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor Registration', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Join MediTrust Network',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimaryLight),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Register your profile. Our medical board will verify your details.',
                  style: TextStyle(fontSize: 14, color: AppColors.textSecondaryLight),
                ),
                const SizedBox(height: 24),
                
                CustomTextField(
                  label: 'Full Name',
                  hint: 'Dr. John Doe',
                  controller: _nameController,
                  prefixIcon: Icons.person_outline,
                  validator: (value) => value == null || value.isEmpty ? 'Name required' : null,
                ),
                const SizedBox(height: 16),
                
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        label: 'Specialization',
                        hint: 'e.g. Cardiologist',
                        controller: _specializationController,
                        prefixIcon: Icons.star_border,
                        validator: (value) => value == null || value.isEmpty ? 'Specialization required' : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomTextField(
                        label: 'Experience (Years)',
                        hint: 'e.g. 10',
                        controller: _expController,
                        keyboardType: TextInputType.number,
                        prefixIcon: Icons.timeline,
                        validator: (value) => value == null || value.isEmpty ? 'Exp required' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                CustomTextField(
                  label: 'Clinic / Hospital Name',
                  hint: 'Grace Cardiology Center',
                  controller: _clinicController,
                  prefixIcon: Icons.business,
                  validator: (value) => value == null || value.isEmpty ? 'Clinic required' : null,
                ),
                const SizedBox(height: 16),

                CustomTextField(
                  label: 'Clinic Address',
                  hint: 'Street address, City',
                  controller: _addressController,
                  prefixIcon: Icons.location_on_outlined,
                  validator: (value) => value == null || value.isEmpty ? 'Address required' : null,
                ),
                const SizedBox(height: 16),

                CustomTextField(
                  label: 'Contact Number',
                  hint: 'Enter clinic phone number',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  prefixIcon: Icons.phone,
                  validator: (value) => value == null || value.isEmpty ? 'Phone required' : null,
                ),
                const SizedBox(height: 24),

                const Text('Consultation Fees (INR)', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimaryLight)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        label: 'Chat Fee',
                        hint: '150',
                        controller: _feeChat,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomTextField(
                        label: 'Audio Call Fee',
                        hint: '300',
                        controller: _feeAudio,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        label: 'Video Call Fee',
                        hint: '500',
                        controller: _feeVideo,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomTextField(
                        label: 'Clinic Visit Fee',
                        hint: '700',
                        controller: _feeVisit,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                const Text('Documents Upload', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimaryLight)),
                const SizedBox(height: 12),
                
                // Document Picker Mock Card
                Row(
                  children: [
                    Expanded(
                      child: _uploadCard(
                        title: 'Profile Photo',
                        status: _profilePhotoStatus,
                        onTap: () => setState(() => _profilePhotoStatus = 'Uploaded (ProfilePhoto.jpg)'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _uploadCard(
                        title: 'Medical License',
                        status: _licenseStatus,
                        onTap: () => setState(() => _licenseStatus = 'Uploaded (MedicalLicense.pdf)'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                
                CustomButton(
                  text: 'Submit Application',
                  isLoading: _isLoading,
                  onPressed: _submit,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _uploadCard({required String title, required String status, required VoidCallback onTap}) {
    final hasUploaded = status.startsWith('Uploaded');
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          border: Border.all(color: hasUploaded ? AppColors.success : AppColors.borderLight, style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(16),
          color: hasUploaded ? AppColors.success.withOpacity(0.05) : Colors.grey[50],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(hasUploaded ? Icons.check_circle_outline_rounded : Icons.cloud_upload_outlined, 
              color: hasUploaded ? AppColors.success : AppColors.primaryTeal, 
              size: 28),
            const SizedBox(height: 6),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 4),
            Text(status, style: TextStyle(fontSize: 10, color: hasUploaded ? AppColors.success : AppColors.textSecondaryLight)),
          ],
        ),
      ),
    );
  }

  Widget _buildVerificationPendingView() {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.verified_user_outlined, color: AppColors.primaryPurple, size: 72),
            const SizedBox(height: 24),
            const Text(
              'Under Verification',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'Thank you for submitting your application!\nOur medical licensing team is currently reviewing your certificates. This process typically takes 24-48 hours.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondaryLight, height: 1.6),
            ),
            const SizedBox(height: 48),
            CustomButton(
              text: 'Access Dashboard (Developer Sandbox)',
              onPressed: () {
                context.go('/doctor/home');
              },
            ),
            const SizedBox(height: 16),
            CustomButton(
              text: 'Logout',
              isOutline: true,
              onPressed: () async {
                await ref.read(authProvider.notifier).logout();
                if (mounted) context.go('/welcome');
              },
            ),
          ],
        ),
      ),
    );
  }
}
