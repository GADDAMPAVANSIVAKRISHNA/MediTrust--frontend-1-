import '../models/models.dart';

class PharmacyService {
  static final PharmacyService _instance = PharmacyService._internal();
  factory PharmacyService() => _instance;
  PharmacyService._internal();

  final List<MedicineModel> _mockMedicines = [
    // Pain Relief
    MedicineModel(
      id: 'med_1',
      name: 'Paracetamol 500mg',
      category: 'Pain Relief',
      price: 25.0,
      discountPrice: 20.0,
      description: 'Used for fast relief from headaches, body aches, and fever. Take after food.',
      imageUrl: 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?auto=format&fit=crop&q=80&w=300',
      isPrescriptionRequired: false,
    ),
    MedicineModel(
      id: 'med_2',
      name: 'Ibuprofen 400mg',
      category: 'Pain Relief',
      price: 40.0,
      discountPrice: 35.0,
      description: 'Non-steroidal anti-inflammatory drug (NSAID) to reduce fever, pain, and inflammation.',
      imageUrl: 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?auto=format&fit=crop&q=80&w=300',
      isPrescriptionRequired: false,
    ),
    // Vitamins
    MedicineModel(
      id: 'med_3',
      name: 'Calcium Tablet',
      category: 'Vitamins',
      price: 80.0,
      discountPrice: 60.0,
      description: 'Essential mineral for strong bones, teeth health, and neuromuscular support.',
      imageUrl: 'https://images.unsplash.com/photo-1584017911766-d451b3d0e843?auto=format&fit=crop&q=80&w=300',
      isPrescriptionRequired: false,
    ),
    MedicineModel(
      id: 'med_4',
      name: 'Vitamin D3 60K',
      category: 'Vitamins',
      price: 110.0,
      discountPrice: 80.0,
      description: 'High strength Vitamin D capsule for bone mineral density and immune booster.',
      imageUrl: 'https://images.unsplash.com/photo-1616671276441-2f2c277b8bf4?auto=format&fit=crop&q=80&w=300',
      isPrescriptionRequired: false,
    ),
    // Antibiotics
    MedicineModel(
      id: 'med_5',
      name: 'Amoxicillin 500mg',
      category: 'Antibiotics',
      price: 150.0,
      discountPrice: 120.0,
      description: 'Penicillin antibiotic used to treat bacterial infections. Requires prescription.',
      imageUrl: 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?auto=format&fit=crop&q=80&w=300',
      isPrescriptionRequired: true,
    ),
    // Skin Care
    MedicineModel(
      id: 'med_6',
      name: 'Hyaluronic Hydrating Gel',
      category: 'Skin Care',
      price: 350.0,
      discountPrice: 280.0,
      description: 'Deep hydration formula with hyaluronic acid for soft, glowing skin. Perfect skincare product.',
      imageUrl: 'https://images.unsplash.com/photo-1601049541289-9b1b7bbbfe19?auto=format&fit=crop&q=80&w=300',
      isPrescriptionRequired: false,
    ),
    MedicineModel(
      id: 'med_7',
      name: 'Niacinamide Serum 10%',
      category: 'Skin Care',
      price: 499.0,
      discountPrice: 399.0,
      description: 'Corrects skin blemishes, minimizes pores, and balances sebum production.',
      imageUrl: 'https://images.unsplash.com/photo-1620916566398-39f1143ab7be?auto=format&fit=crop&q=80&w=300',
      isPrescriptionRequired: false,
    ),
    // Diabetes
    MedicineModel(
      id: 'med_8',
      name: 'Metformin 500mg',
      category: 'Diabetes',
      price: 95.0,
      discountPrice: 85.0,
      description: 'Oral diabetes medicine that helps control blood sugar levels for type 2 diabetes patients.',
      imageUrl: 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?auto=format&fit=crop&q=80&w=300',
      isPrescriptionRequired: true,
    ),
  ];

  final List<OrderModel> _mockOrders = [
    OrderModel(
      id: 'ord_1',
      patientName: 'Sarah Johnson',
      items: [
        CartItem(
          medicine: MedicineModel(
            id: 'med_1',
            name: 'Paracetamol 500mg',
            category: 'Pain Relief',
            price: 25.0,
            discountPrice: 20.0,
            description: 'Pain reliever',
            imageUrl: '',
            isPrescriptionRequired: false,
          ),
          quantity: 2,
        ),
        CartItem(
          medicine: MedicineModel(
            id: 'med_3',
            name: 'Calcium Tablet',
            category: 'Vitamins',
            price: 80.0,
            discountPrice: 60.0,
            description: 'Vitamins',
            imageUrl: '',
            isPrescriptionRequired: false,
          ),
          quantity: 1,
        )
      ],
      totalAmount: 100.0,
      status: 'accepted',
      date: DateTime.now().subtract(const Duration(hours: 3)),
      deliveryAddress: 'House 42, Green Avenue, Cityville',
    )
  ];

  Future<List<MedicineModel>> getMedicines({String query = '', String category = 'All'}) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _mockMedicines.where((med) {
      final matchesQuery = med.name.toLowerCase().contains(query.toLowerCase());
      final matchesCategory = category == 'All' || med.category == category;
      return matchesQuery && matchesCategory;
    }).toList();
  }

  Future<List<String>> getCategories() async {
    return ['All', 'Pain Relief', 'Vitamins', 'Antibiotics', 'Skin Care', 'Diabetes'];
  }

  Future<List<OrderModel>> getOrders() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockOrders;
  }

  Future<OrderModel> createOrder(List<CartItem> items, double total, String address, String patientName) async {
    await Future.delayed(const Duration(seconds: 1));
    final newOrder = OrderModel(
      id: 'ord_${DateTime.now().millisecondsSinceEpoch}',
      patientName: patientName,
      items: items,
      totalAmount: total,
      status: 'pending',
      date: DateTime.now(),
      deliveryAddress: address,
    );
    _mockOrders.add(newOrder);
    return newOrder;
  }

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final index = _mockOrders.indexWhere((o) => o.id == orderId);
    if (index >= 0) {
      _mockOrders[index] = _mockOrders[index].copyWith(status: newStatus);
    }
  }

  Future<void> addMedicine(MedicineModel medicine) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _mockMedicines.add(medicine);
  }
}
