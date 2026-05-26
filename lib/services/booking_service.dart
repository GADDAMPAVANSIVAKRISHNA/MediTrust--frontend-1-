import '../models/models.dart';

class BookingService {
  static final BookingService _instance = BookingService._internal();
  factory BookingService() => _instance;
  BookingService._internal();

  final List<AppointmentModel> _mockBookings = [
    AppointmentModel(
      id: 'apt_1',
      doctorId: 'doc_1',
      doctorName: 'Dr. Priya Sharma',
      doctorSpecialization: 'Cardiologist',
      doctorImage: 'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?auto=format&fit=crop&q=80&w=300',
      patientId: 'usr_mock_123',
      patientName: 'Sarah Johnson',
      dateTime: DateTime.now().add(const Duration(days: 1)),
      timeSlot: '09:30 AM - 11:00 AM',
      status: 'upcoming',
      consultationType: 'Video Call',
      fee: 600,
    )
  ];

  Future<List<AppointmentModel>> getBookings(String patientId) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return _mockBookings.where((b) => b.patientId == patientId).toList();
  }

  Future<List<AppointmentModel>> getDoctorBookings(String doctorId) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return _mockBookings.where((b) => b.doctorId == doctorId).toList();
  }

  Future<AppointmentModel> createBooking({
    required String doctorId,
    required String doctorName,
    required String doctorSpecialization,
    required String doctorImage,
    required String patientId,
    required String patientName,
    required DateTime date,
    required String slot,
    required String consultationType,
    required double fee,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    final newApt = AppointmentModel(
      id: 'apt_${DateTime.now().millisecondsSinceEpoch}',
      doctorId: doctorId,
      doctorName: doctorName,
      doctorSpecialization: doctorSpecialization,
      doctorImage: doctorImage,
      patientId: patientId,
      patientName: patientName,
      dateTime: date,
      timeSlot: slot,
      status: 'upcoming',
      consultationType: consultationType,
      fee: fee,
    );
    _mockBookings.add(newApt);
    return newApt;
  }

  Future<void> updateBookingStatus(String bookingId, String newStatus) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _mockBookings.indexWhere((b) => b.id == bookingId);
    if (index >= 0) {
      _mockBookings[index] = _mockBookings[index].copyWith(status: newStatus);
    }
  }

  Future<AppointmentModel?> getBookingById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _mockBookings.indexWhere((b) => b.id == id);
    return index >= 0 ? _mockBookings[index] : null;
  }
}
