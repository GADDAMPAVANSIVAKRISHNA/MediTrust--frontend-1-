import '../models/models.dart';

class PrescriptionService {
  static final PrescriptionService _instance = PrescriptionService._internal();
  factory PrescriptionService() => _instance;
  PrescriptionService._internal();

  final List<PrescriptionModel> _mockPrescriptions = [
    PrescriptionModel(
      id: 'pr_1',
      doctorName: 'Dr. Priya Sharma',
      doctorSpecialization: 'Cardiologist',
      doctorLicense: 'Reg No. 98765',
      patientName: 'Sarah Johnson',
      patientAge: 28,
      patientGender: 'Female',
      date: DateTime.now().subtract(const Duration(days: 2)),
      medicines: [
        PrescribedMedicine(
          name: 'Paracetamol 500mg',
          dosage: '1 - Tablet - Twice a day',
          instructions: 'After Food',
          durationDays: 5,
        ),
        PrescribedMedicine(
          name: 'Vitamin D3 60K',
          dosage: '1 - Capsule - Once a week',
          instructions: 'After Food',
          durationDays: 4,
        ),
        PrescribedMedicine(
          name: 'Calcium Tablet',
          dosage: '1 - Tablet - Once a day',
          instructions: 'After Food',
          durationDays: 30,
        ),
      ],
      advice: 'Drink plenty of water and rest. Take light walks in the morning.',
      signatureUrl: 'https://upload.wikimedia.org/wikipedia/commons/e/e3/John_Hancock_signature.svg',
    )
  ];

  Future<List<PrescriptionModel>> getPrescriptionsForPatient(String patientName) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockPrescriptions.where((p) => p.patientName == patientName).toList();
  }

  Future<PrescriptionModel?> getPrescriptionById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _mockPrescriptions.indexWhere((p) => p.id == id);
    return index >= 0 ? _mockPrescriptions[index] : null;
  }

  Future<PrescriptionModel> createPrescription({
    required String doctorName,
    required String doctorSpecialization,
    required String doctorLicense,
    required String patientName,
    required int patientAge,
    required String patientGender,
    required List<PrescribedMedicine> medicines,
    required String advice,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final newPr = PrescriptionModel(
      id: 'pr_${DateTime.now().millisecondsSinceEpoch}',
      doctorName: doctorName,
      doctorSpecialization: doctorSpecialization,
      doctorLicense: doctorLicense,
      patientName: patientName,
      patientAge: patientAge,
      patientGender: patientGender,
      date: DateTime.now(),
      medicines: medicines,
      advice: advice,
      signatureUrl: 'https://upload.wikimedia.org/wikipedia/commons/e/e3/John_Hancock_signature.svg',
    );
    _mockPrescriptions.add(newPr);
    return newPr;
  }
}
