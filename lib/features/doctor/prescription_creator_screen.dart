import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../models/models.dart';
import '../../services/prescription_service.dart';
import '../../widgets/widgets.dart';

class PrescriptionCreatorScreen extends StatefulWidget {
  final String appointmentId;
  const PrescriptionCreatorScreen({super.key, required this.appointmentId});

  @override
  State<PrescriptionCreatorScreen> createState() => _PrescriptionCreatorScreenState();
}

class _PrescriptionCreatorScreenState extends State<PrescriptionCreatorScreen> {
  final _prescriptionService = PrescriptionService();
  final _formKey = GlobalKey<FormState>();

  final _patientNameController = TextEditingController(text: 'Sarah Johnson');
  final _patientAgeController = TextEditingController(text: '28');
  final _adviceController = TextEditingController();
  
  String _gender = 'Female';
  bool _isSaving = false;

  final List<Map<String, dynamic>> _medicinesList = [
    {'name': 'Paracetamol 500mg', 'dosage': '1-0-1', 'instructions': 'After food', 'days': '5'},
  ];

  void _addMedicineField() {
    setState(() {
      _medicinesList.add({'name': '', 'dosage': '1-0-1', 'instructions': 'After food', 'days': '5'});
    });
  }

  void _removeMedicineField(int index) {
    if (_medicinesList.length > 1) {
      setState(() {
        _medicinesList.removeAt(index);
      });
    }
  }

  void _submitPrescription() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSaving = true);
      
      final List<PrescribedMedicine> meds = _medicinesList.map((m) {
        return PrescribedMedicine(
          name: m['name'],
          dosage: m['dosage'],
          instructions: m['instructions'],
          durationDays: int.tryParse(m['days']) ?? 5,
        );
      }).toList();

      await _prescriptionService.createPrescription(
        doctorName: 'Dr. Priya Sharma',
        doctorSpecialization: 'Cardiologist',
        doctorLicense: 'Reg No. 98765',
        patientName: _patientNameController.text,
        patientAge: int.tryParse(_patientAgeController.text) ?? 28,
        patientGender: _gender,
        medicines: meds,
        advice: _adviceController.text.isEmpty ? 'Drink plenty of water and rest.' : _adviceController.text,
      );

      setState(() => _isSaving = false);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Prescription created and shared successfully!'), backgroundColor: AppColors.success),
        );
        context.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Prescription', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Patient Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      const SizedBox(height: 12),
                      CustomTextField(
                        label: 'Patient Name',
                        hint: 'Sarah Johnson',
                        controller: _patientNameController,
                        validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              label: 'Age',
                              hint: '28',
                              controller: _patientAgeController,
                              keyboardType: TextInputType.number,
                              validator: (value) => value == null || value.isEmpty ? 'Required' : null,
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
                                    return DropdownMenuItem<String>(value: val, child: Text(val));
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
                      
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.0),
                        child: Divider(color: AppColors.borderLight),
                      ),
                      
                      // Medicines Creator List
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Medicines (Rx)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          TextButton.icon(
                            icon: const Icon(Icons.add, size: 16, color: AppColors.primaryPurple),
                            label: const Text('Add Medicine', style: TextStyle(color: AppColors.primaryPurple, fontWeight: FontWeight.bold, fontSize: 12)),
                            onPressed: _addMedicineField,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _medicinesList.length,
                        itemBuilder: (context, index) {
                          final item = _medicinesList[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 16),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          initialValue: item['name'] as String,
                                          style: const TextStyle(fontSize: 13),
                                          decoration: const InputDecoration(
                                            hintText: 'Medicine name (e.g. Paracetamol)',
                                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                          ),
                                          validator: (val) => val == null || val.isEmpty ? 'Name required' : null,
                                          onChanged: (val) => _medicinesList[index]['name'] = val,
                                        ),
                                      ),
                                      if (_medicinesList.length > 1)
                                        IconButton(
                                          icon: const Icon(Icons.delete_outline, color: AppColors.error),
                                          onPressed: () => _removeMedicineField(index),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          initialValue: item['dosage'] as String,
                                          style: const TextStyle(fontSize: 12),
                                          decoration: const InputDecoration(
                                            hintText: 'Dosage (e.g. 1-0-1)',
                                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                          ),
                                          onChanged: (val) => _medicinesList[index]['dosage'] = val,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: TextFormField(
                                          initialValue: item['instructions'] as String,
                                          style: const TextStyle(fontSize: 12),
                                          decoration: const InputDecoration(
                                            hintText: 'e.g. After food',
                                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                          ),
                                          onChanged: (val) => _medicinesList[index]['instructions'] = val,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      SizedBox(
                                        width: 68,
                                        child: TextFormField(
                                          initialValue: item['days'] as String,
                                          keyboardType: TextInputType.number,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(fontSize: 12),
                                          decoration: const InputDecoration(
                                            hintText: 'Days',
                                            contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                                          ),
                                          onChanged: (val) => _medicinesList[index]['days'] = val,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        child: Divider(color: AppColors.borderLight),
                      ),
                      
                      // Advice
                      const Text('Advice / Instructions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      const SizedBox(height: 12),
                      CustomTextField(
                        label: 'General Advice',
                        hint: 'Drink plenty of water. Rest and avoid heavy workouts.',
                        controller: _adviceController,
                        maxLines: 3,
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
            
            // Fixed bottom submit button
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : Colors.white,
                border: Border(top: BorderSide(color: isDark ? Colors.white10 : AppColors.borderLight)),
              ),
              child: CustomButton(
                text: 'Sign & Issue Prescription',
                isLoading: _isSaving,
                onPressed: _submitPrescription,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
