import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../models/models.dart';
import '../../services/prescription_service.dart';
import '../../widgets/widgets.dart';

class PrescriptionDetailScreen extends StatefulWidget {
  final String prescriptionId;
  const PrescriptionDetailScreen({super.key, required this.prescriptionId});

  @override
  State<PrescriptionDetailScreen> createState() => _PrescriptionDetailScreenState();
}

class _PrescriptionDetailScreenState extends State<PrescriptionDetailScreen> {
  final _prescriptionService = PrescriptionService();
  PrescriptionModel? _prescription;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPrescription();
  }

  void _loadPrescription() async {
    final result = await _prescriptionService.getPrescriptionById(widget.prescriptionId);
    setState(() {
      _prescription = result;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_prescription == null) {
      return const Scaffold(body: Center(child: Text('Prescription not found.')));
    }

    final pr = _prescription!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Prescription', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.download_rounded, color: AppColors.primaryTeal),
            tooltip: 'Download PDF',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Downloading prescription PDF file...')),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: GlassCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Doctor Header Block
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                pr.doctorName,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                pr.doctorSpecialization,
                                style: const TextStyle(color: AppColors.primaryTeal, fontWeight: FontWeight.w600, fontSize: 13),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                pr.doctorLicense,
                                style: const TextStyle(color: AppColors.textSecondaryLight, fontSize: 11),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                'Date',
                                style: TextStyle(color: AppColors.textSecondaryLight, fontSize: 11),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'May 07, 2026',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                            ],
                          ),
                        ],
                      ),
                      
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Divider(color: AppColors.borderLight),
                      ),
                      
                      // Rx Emblem & Patient Block
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Rx Icon
                          Text(
                            '℞',
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryPurple,
                              fontFamily: 'serif',
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Text('Patient Name: ', style: TextStyle(color: AppColors.textSecondaryLight, fontSize: 13)),
                                    Text(pr.patientName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Text('Age / Gender: ', style: TextStyle(color: AppColors.textSecondaryLight, fontSize: 13)),
                                    Text('${pr.patientAge} / ${pr.patientGender}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Divider(color: AppColors.borderLight),
                      ),
                      
                      // Medications List
                      const Text(
                        'Medications',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      const SizedBox(height: 12),
                      
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: pr.medicines.length,
                        itemBuilder: (context, index) {
                          final med = pr.medicines[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${index + 1}. ', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        med.name,
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${med.dosage}  •  ${med.instructions}',
                                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryLight),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryTeal.withOpacity(0.06),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    '${med.durationDays} Days',
                                    style: const TextStyle(color: AppColors.primaryTeal, fontSize: 10, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Divider(color: AppColors.borderLight),
                      ),
                      
                      // Advice Block
                      const Text(
                        'Advice',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        pr.advice,
                        style: const TextStyle(fontSize: 13, color: AppColors.textSecondaryLight, height: 1.5),
                      ),
                      
                      const SizedBox(height: 40),
                      
                      // Signature Block
                      Align(
                        alignment: Alignment.centerRight,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // Doctor Signature representation
                            Container(
                              height: 48,
                              width: 120,
                              child: Image.network(
                                pr.signatureUrl,
                                color: AppColors.primaryPurple,
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const SizedBox(
                              width: 150,
                              child: Divider(thickness: 1),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              pr.doctorName,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                            Text(
                              pr.doctorLicense,
                              style: const TextStyle(fontSize: 10, color: AppColors.textSecondaryLight),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Bottom Action buttons
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: CustomButton(
                text: 'Share Prescription',
                color: AppColors.primaryPurple,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Sharing prescription details link...')),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
