import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/providers.dart';
import '../../widgets/widgets.dart';

class PharmacyOnboardingScreen extends ConsumerStatefulWidget {
  const PharmacyOnboardingScreen({super.key});

  @override
  ConsumerState<PharmacyOnboardingScreen> createState() => _PharmacyOnboardingScreenState();
}

class _PharmacyOnboardingScreenState extends ConsumerState<PharmacyOnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _pharmacyNameController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _radiusController = TextEditingController(text: '5');
  final _hoursController = TextEditingController(text: '09:00 AM - 10:00 PM');

  bool _isSubmitted = false;
  bool _isLoading = false;
  String _licenseStatus = 'Not uploaded';
  String _photoStatus = 'Not uploaded';

  @override
  void initState() {
    super.initState();
    final current = ref.read(authProvider);
    if (current != null) {
      _ownerNameController.text = current.name;
    }
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      final details = {
        'pharmacyName': _pharmacyNameController.text,
        'ownerName': _ownerNameController.text,
        'phone': _phoneController.text,
        'address': _addressController.text,
        'radius': double.tryParse(_radiusController.text) ?? 5.0,
        'hours': _hoursController.text,
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
        title: const Text('Pharmacy Enrollment', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
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
                  'Partner as a Pharmacy',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimaryLight),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Sell medicines and healthcare products on MediTrust. Verify store credentials.',
                  style: TextStyle(fontSize: 14, color: AppColors.textSecondaryLight),
                ),
                const SizedBox(height: 24),
                
                CustomTextField(
                  label: 'Pharmacy / Store Name',
                  hint: 'Enter registered shop name',
                  controller: _pharmacyNameController,
                  prefixIcon: Icons.storefront_outlined,
                  validator: (value) => value == null || value.isEmpty ? 'Pharmacy name required' : null,
                ),
                const SizedBox(height: 16),
                
                CustomTextField(
                  label: 'Owner Full Name',
                  hint: 'Enter owner name',
                  controller: _ownerNameController,
                  prefixIcon: Icons.person_outline,
                  validator: (value) => value == null || value.isEmpty ? 'Owner name required' : null,
                ),
                const SizedBox(height: 16),

                CustomTextField(
                  label: 'Pharmacy Store Address',
                  hint: 'Street, Block, City',
                  controller: _addressController,
                  prefixIcon: Icons.location_on_outlined,
                  validator: (value) => value == null || value.isEmpty ? 'Address required' : null,
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        label: 'Delivery Radius (km)',
                        hint: '5',
                        controller: _radiusController,
                        keyboardType: TextInputType.number,
                        prefixIcon: Icons.directions_run_outlined,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomTextField(
                        label: 'Opening Hours',
                        hint: '9 AM - 10 PM',
                        controller: _hoursController,
                        prefixIcon: Icons.access_time_outlined,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                CustomTextField(
                  label: 'Store Mobile Number',
                  hint: 'Enter contact phone number',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  prefixIcon: Icons.phone_outlined,
                  validator: (value) => value == null || value.isEmpty ? 'Phone number required' : null,
                ),
                const SizedBox(height: 24),

                const Text('Store Verification', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimaryLight)),
                const SizedBox(height: 12),
                
                Row(
                  children: [
                    Expanded(
                      child: _uploadCard(
                        title: 'Drug License',
                        status: _licenseStatus,
                        onTap: () => setState(() => _licenseStatus = 'Uploaded (License_2026.pdf)'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _uploadCard(
                        title: 'Store Photo',
                        status: _photoStatus,
                        onTap: () => setState(() => _photoStatus = 'Uploaded (StoreFront.jpg)'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                
                CustomButton(
                  text: 'Submit Store Profile',
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
            const Icon(Icons.pending_actions_rounded, color: AppColors.warning, size: 72),
            const SizedBox(height: 24),
            const Text(
              'Verification Pending',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'Your pharmacy details are submitted successfully!\nOur store onboarding team will verify your drug license number and shop images. Review finishes in 1-2 business days.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondaryLight, height: 1.6),
            ),
            const SizedBox(height: 48),
            CustomButton(
              text: 'Access Dashboard (Developer Sandbox)',
              onPressed: () {
                context.go('/pharmacy/home');
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
