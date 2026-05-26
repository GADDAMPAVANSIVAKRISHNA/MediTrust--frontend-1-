import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/providers.dart';
import '../../widgets/widgets.dart';

class PatientOnboardingScreen extends ConsumerStatefulWidget {
  const PatientOnboardingScreen({super.key});

  @override
  ConsumerState<PatientOnboardingScreen> createState() => _PatientOnboardingScreenState();
}

class _PatientOnboardingScreenState extends ConsumerState<PatientOnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _cityController = TextEditingController();
  final _conditionsController = TextEditingController();
  final _emergencyController = TextEditingController();
  String _gender = 'Female';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Pre-populate with current session details
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
        'age': int.tryParse(_ageController.text) ?? 25,
        'gender': _gender,
        'city': _cityController.text,
        'conditions': _conditionsController.text,
        'emergency': _emergencyController.text,
      };

      await ref.read(authProvider.notifier).completeOnboarding(details);
      
      setState(() => _isLoading = false);
      if (mounted) {
        context.go('/success?message=Patient profile created successfully! Welcome to MediTrust.&next=/patient/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Profile', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
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
                  'Tell us about yourself',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimaryLight),
                ),
                const SizedBox(height: 6),
                const Text(
                  'This helps our doctors provide accurate medical advice.',
                  style: TextStyle(fontSize: 14, color: AppColors.textSecondaryLight),
                ),
                const SizedBox(height: 24),
                
                CustomTextField(
                  label: 'Full Name',
                  hint: 'Enter your full name',
                  controller: _nameController,
                  prefixIcon: Icons.person_outline,
                  validator: (value) => value == null || value.isEmpty ? 'Please enter name' : null,
                ),
                const SizedBox(height: 16),
                
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        label: 'Age',
                        hint: 'e.g. 28',
                        controller: _ageController,
                        keyboardType: TextInputType.number,
                        prefixIcon: Icons.calendar_today_outlined,
                        validator: (value) => value == null || value.isEmpty ? 'Age required' : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Gender', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            value: _gender,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                            items: ['Male', 'Female', 'Other'].map((String val) {
                              return DropdownMenuItem<String>(
                                value: val,
                                child: Text(val),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) setState(() => _gender = val);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                CustomTextField(
                  label: 'City',
                  hint: 'Enter your city',
                  controller: _cityController,
                  prefixIcon: Icons.location_on_outlined,
                  validator: (value) => value == null || value.isEmpty ? 'City required' : null,
                ),
                const SizedBox(height: 16),
                
                CustomTextField(
                  label: 'Existing Medical Conditions',
                  hint: 'e.g. Asthma, Hypertension (Optional)',
                  controller: _conditionsController,
                  prefixIcon: Icons.medical_information_outlined,
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                
                CustomTextField(
                  label: 'Emergency Contact (Phone)',
                  hint: 'Enter emergency mobile number',
                  controller: _emergencyController,
                  keyboardType: TextInputType.phone,
                  prefixIcon: Icons.phone_android_outlined,
                  validator: (value) => value == null || value.length < 10 ? 'Enter valid phone' : null,
                ),
                const SizedBox(height: 32),
                
                CustomButton(
                  text: 'Submit Onboarding',
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
}
