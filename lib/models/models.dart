enum UserRole { guest, patient, doctor, pharmacy, admin }

class UserModel {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String phone;
  final String profilePhoto;
  final String city;
  final bool isOnboardingCompleted;
  final Map<String, dynamic> additionalDetails;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.phone = '',
    this.profilePhoto = '',
    this.city = '',
    this.isOnboardingCompleted = false,
    this.additionalDetails = const {},
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    UserRole? role,
    String? phone,
    String? profilePhoto,
    String? city,
    bool? isOnboardingCompleted,
    Map<String, dynamic>? additionalDetails,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      city: city ?? this.city,
      isOnboardingCompleted: isOnboardingCompleted ?? this.isOnboardingCompleted,
      additionalDetails: additionalDetails ?? this.additionalDetails,
    );
  }
}

class DoctorModel {
  final String id;
  final String name;
  final String clinicName;
  final String specialization;
  final int experienceYears;
  final double feeChat;
  final double feeAudio;
  final double feeVideo;
  final double feeVisit;
  final double rating;
  final int reviewsCount;
  final bool isAvailableToday;
  final String imageUrl;
  final String about;
  final List<String> availableSlots;

  DoctorModel({
    required this.id,
    required this.name,
    required this.clinicName,
    required this.specialization,
    required this.experienceYears,
    required this.feeChat,
    required this.feeAudio,
    required this.feeVideo,
    required this.feeVisit,
    required this.rating,
    required this.reviewsCount,
    required this.isAvailableToday,
    required this.imageUrl,
    required this.about,
    required this.availableSlots,
  });
}

class MedicineModel {
  final String id;
  final String name;
  final String category;
  final double price;
  final double discountPrice;
  final String description;
  final String imageUrl;
  final bool isPrescriptionRequired;
  final String manufacturer;

  MedicineModel({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.discountPrice,
    required this.description,
    required this.imageUrl,
    required this.isPrescriptionRequired,
    this.manufacturer = 'MediTrust Pharmaceuticals',
  });
}

class AppointmentModel {
  final String id;
  final String doctorId;
  final String doctorName;
  final String doctorSpecialization;
  final String doctorImage;
  final String patientId;
  final String patientName;
  final DateTime dateTime;
  final String timeSlot;
  final String status; // 'upcoming', 'completed', 'cancelled'
  final String consultationType; // 'video', 'in_clinic'
  final double fee;

  AppointmentModel({
    required this.id,
    required this.doctorId,
    required this.doctorName,
    required this.doctorSpecialization,
    required this.doctorImage,
    required this.patientId,
    required this.patientName,
    required this.dateTime,
    required this.timeSlot,
    required this.status,
    required this.consultationType,
    required this.fee,
  });

  AppointmentModel copyWith({
    String? id,
    String? doctorId,
    String? doctorName,
    String? doctorSpecialization,
    String? doctorImage,
    String? patientId,
    String? patientName,
    DateTime? dateTime,
    String? timeSlot,
    String? status,
    String? consultationType,
    double? fee,
  }) {
    return AppointmentModel(
      id: id ?? this.id,
      doctorId: doctorId ?? this.doctorId,
      doctorName: doctorName ?? this.doctorName,
      doctorSpecialization: doctorSpecialization ?? this.doctorSpecialization,
      doctorImage: doctorImage ?? this.doctorImage,
      patientId: patientId ?? this.patientId,
      patientName: patientName ?? this.patientName,
      dateTime: dateTime ?? this.dateTime,
      timeSlot: timeSlot ?? this.timeSlot,
      status: status ?? this.status,
      consultationType: consultationType ?? this.consultationType,
      fee: fee ?? this.fee,
    );
  }
}

class MessageModel {
  final String id;
  final String senderId;
  final String receiverId;
  final String content;
  final DateTime timestamp;
  final bool isAudio;
  final bool isImage;
  final bool isPrescription;
  final String audioDuration;
  final String mediaUrl;

  MessageModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.timestamp,
    this.isAudio = false,
    this.isImage = false,
    this.isPrescription = false,
    this.audioDuration = '',
    this.mediaUrl = '',
  });
}

class CartItem {
  final MedicineModel medicine;
  int quantity;

  CartItem({
    required this.medicine,
    this.quantity = 1,
  });
}

class OrderModel {
  final String id;
  final String patientName;
  final List<CartItem> items;
  final double totalAmount;
  final String status; // 'pending', 'accepted', 'rejected', 'delivered'
  final DateTime date;
  final String deliveryAddress;

  OrderModel({
    required this.id,
    required this.patientName,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.date,
    required this.deliveryAddress,
  });

  OrderModel copyWith({
    String? id,
    String? patientName,
    List<CartItem>? items,
    double? totalAmount,
    String? status,
    DateTime? date,
    String? deliveryAddress,
  }) {
    return OrderModel(
      id: id ?? this.id,
      patientName: patientName ?? this.patientName,
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      date: date ?? this.date,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
    );
  }
}

class PrescriptionModel {
  final String id;
  final String doctorName;
  final String doctorSpecialization;
  final String doctorLicense;
  final String patientName;
  final int patientAge;
  final String patientGender;
  final DateTime date;
  final List<PrescribedMedicine> medicines;
  final String advice;
  final String signatureUrl;

  PrescriptionModel({
    required this.id,
    required this.doctorName,
    required this.doctorSpecialization,
    required this.doctorLicense,
    required this.patientName,
    required this.patientAge,
    required this.patientGender,
    required this.date,
    required this.medicines,
    required this.advice,
    required this.signatureUrl,
  });
}

class PrescribedMedicine {
  final String name;
  final String dosage; // e.g. "1-0-1"
  final String instructions; // e.g. "After food"
  final int durationDays;

  PrescribedMedicine({
    required this.name,
    required this.dosage,
    required this.instructions,
    required this.durationDays,
  });
}
