import '../models/models.dart';

class DoctorService {
  static final DoctorService _instance = DoctorService._internal();
  factory DoctorService() => _instance;
  DoctorService._internal();

  final List<DoctorModel> _mockDoctors = [
    DoctorModel(
      id: 'doc_1',
      name: 'Dr. Priya Sharma',
      clinicName: 'Grace Cardiology Center',
      specialization: 'Cardiologist',
      experienceYears: 10,
      feeChat: 200,
      feeAudio: 400,
      feeVideo: 600,
      feeVisit: 800,
      rating: 4.8,
      reviewsCount: 120,
      isAvailableToday: true,
      imageUrl: 'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?auto=format&fit=crop&q=80&w=300',
      about: 'Dr. Priya Sharma is a leading Cardiologist with over 10 years of experience in treating heart-related diseases. She has published numerous papers on coronary health and offers personalized therapy plans.',
      availableSlots: ['09:00 AM', '10:00 AM', '11:00 AM', '02:00 PM', '04:00 PM', '06:00 PM', '07:00 PM'],
    ),
    DoctorModel(
      id: 'doc_2',
      name: 'Dr. Arjun Verma',
      clinicName: 'Metro Heart Hospital',
      specialization: 'Cardiologist',
      experienceYears: 8,
      feeChat: 150,
      feeAudio: 300,
      feeVideo: 500,
      feeVisit: 700,
      rating: 4.7,
      reviewsCount: 95,
      isAvailableToday: false,
      imageUrl: 'https://images.unsplash.com/photo-1622253692010-333f2da6031d?auto=format&fit=crop&q=80&w=300',
      about: 'Dr. Arjun Verma specialized in interventional cardiology and pediatric heart surgeries. He has been serving the metro area for the past 8 years with outstanding records.',
      availableSlots: ['10:00 AM', '11:00 AM', '02:00 PM', '03:00 PM', '04:00 PM'],
    ),
    DoctorModel(
      id: 'doc_3',
      name: 'Dr. Neha Gupta',
      clinicName: 'Care Dental & Cardio clinic',
      specialization: 'Dentist',
      experienceYears: 12,
      feeChat: 250,
      feeAudio: 450,
      feeVideo: 700,
      feeVisit: 900,
      rating: 4.9,
      reviewsCount: 142,
      isAvailableToday: true,
      imageUrl: 'https://images.unsplash.com/photo-1594824813573-246434e33963?auto=format&fit=crop&q=80&w=300',
      about: 'Dr. Neha Gupta is a pediatric dentist who focuses on stress-free cosmetic dental designs. Her warm approach is loved by young children and elders alike.',
      availableSlots: ['09:00 AM', '11:00 AM', '12:00 PM', '04:00 PM', '05:00 PM'],
    ),
    DoctorModel(
      id: 'doc_4',
      name: 'Dr. Rohan Mehta',
      clinicName: 'Neurology Solutions Clinic',
      specialization: 'Neurologist',
      experienceYears: 7,
      feeChat: 150,
      feeAudio: 300,
      feeVideo: 400,
      feeVisit: 600,
      rating: 4.6,
      reviewsCount: 78,
      isAvailableToday: true,
      imageUrl: 'https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?auto=format&fit=crop&q=80&w=300',
      about: 'Dr. Rohan Mehta conducts research on neurodegenerative diseases and chronic migraine treatments. He supports holistic therapeutic treatments for anxiety and insomnia.',
      availableSlots: ['02:00 PM', '03:00 PM', '06:00 PM', '07:00 PM'],
    ),
    DoctorModel(
      id: 'doc_5',
      name: 'Dr. Sarah Smith',
      clinicName: 'St. Jude Pediatrics',
      specialization: 'Pediatrician',
      experienceYears: 15,
      feeChat: 200,
      feeAudio: 400,
      feeVideo: 600,
      feeVisit: 800,
      rating: 4.9,
      reviewsCount: 210,
      isAvailableToday: true,
      imageUrl: 'https://images.unsplash.com/photo-1527613426441-4da17471b66d?auto=format&fit=crop&q=80&w=300',
      about: 'Dr. Sarah Smith offers complete neonatal care, vaccinations, and growth monitoring diagnostics. She holds degrees from prestigious child health institutes.',
      availableSlots: ['09:00 AM', '10:00 AM', '11:00 AM', '01:00 PM', '02:00 PM', '03:00 PM'],
    ),
  ];

  Future<List<DoctorModel>> getDoctors({String query = '', String specialization = 'All'}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockDoctors.where((doc) {
      final matchesQuery = doc.name.toLowerCase().contains(query.toLowerCase()) ||
          doc.specialization.toLowerCase().contains(query.toLowerCase());
      final matchesSpec = specialization == 'All' || doc.specialization == specialization;
      return matchesQuery && matchesSpec;
    }).toList();
  }

  Future<DoctorModel?> getDoctorById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _mockDoctors.indexWhere((doc) => doc.id == id);
    return index >= 0 ? _mockDoctors[index] : null;
  }

  List<String> getSpecializations() {
    return ['All', 'Cardiologist', 'Dentist', 'Neurologist', 'Pediatrician'];
  }
}
