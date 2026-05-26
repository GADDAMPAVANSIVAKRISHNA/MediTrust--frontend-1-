import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_theme.dart';
import '../../models/models.dart';
import '../../providers/providers.dart';
import '../../services/pharmacy_service.dart';
import '../../widgets/widgets.dart';

class MedicineShopScreen extends ConsumerStatefulWidget {
  const MedicineShopScreen({super.key});

  @override
  ConsumerState<MedicineShopScreen> createState() => _MedicineShopScreenState();
}

class _MedicineShopScreenState extends ConsumerState<MedicineShopScreen> {
  final _pharmacyService = PharmacyService();
  final _searchController = TextEditingController();
  
  String _selectedCategory = 'All';
  List<MedicineModel> _medicines = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMedicines();
  }

  void _loadMedicines() async {
    setState(() => _isLoading = true);
    final results = await _pharmacyService.getMedicines(
      query: _searchController.text,
      category: _selectedCategory,
    );
    setState(() {
      _medicines = results;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartList = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final mockCategories = [
      {'name': 'All', 'icon': Icons.grid_view_rounded},
      {'name': 'Pain Relief', 'icon': Icons.healing_rounded},
      {'name': 'Vitamins', 'icon': Icons.animation},
      {'name': 'Antibiotics', 'icon': Icons.grain_rounded},
      {'name': 'Skin Care', 'icon': Icons.face_retouching_natural_rounded},
      {'name': 'Diabetes', 'icon': Icons.bloodtype_rounded},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Medicines', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        actions: [
          // Cart Icon Badge
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: () => context.push('/patient/medicines/checkout'),
              ),
              if (cartList.isNotEmpty)
                Positioned(
                  right: 4,
                  top: 4,
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: AppColors.error,
                    child: Text(
                      cartList.fold(0, (sum, item) => sum + item.quantity).toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
            ],
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Input
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) => _loadMedicines(),
                  decoration: const InputDecoration(
                    hintText: 'Search medicines...',
                    prefixIcon: Icon(Icons.search, color: AppColors.textSecondaryLight),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Promo Discount Banner
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFEFF6FF), Color(0xFFDBEAFE)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFFBFDBFE)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Flat 20% OFF',
                                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: Color(0xFF1E40AF)),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'On all medicines & products',
                                    style: TextStyle(fontSize: 12, color: Color(0xFF2563EB), fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Text(
                                      'Use Code: MEDITRUST20',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Color(0xFF1E40AF)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Simple Pill Icon Graphic
                            const Icon(Icons.medication_liquid_rounded, size: 54, color: Color(0xFF3B82F6))
                                .animate(onPlay: (controller) => controller.repeat(reverse: true))
                                .slideY(begin: 0, end: 0.1, duration: 1.seconds),
                          ],
                        ),
                      ),
                    ),

                    // Horizontal Categories
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text('Categories', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 88,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: mockCategories.length,
                        itemBuilder: (context, index) {
                          final category = mockCategories[index];
                          final catName = category['name'] as String;
                          final isSelected = _selectedCategory == catName;
                          
                          return GestureDetector(
                            onTap: () {
                              setState(() => _selectedCategory = catName);
                              _loadMedicines();
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 12),
                              width: 80,
                              child: Column(
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: isSelected 
                                        ? AppColors.primaryTeal 
                                        : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF9FAFB)),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isSelected ? AppColors.primaryTeal : (isDark ? Colors.white10 : AppColors.borderLight),
                                      ),
                                    ),
                                    child: Icon(
                                      category['icon'] as IconData,
                                      color: isSelected ? Colors.white : AppColors.primaryTeal,
                                      size: 22,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    catName,
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 16),
                    
                    // Popular Medicines list
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text('Popular Medicines', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    ),
                    const SizedBox(height: 12),
                    
                    _isLoading
                      ? const Center(child: Padding(padding: EdgeInsets.all(24.0), child: CircularProgressIndicator()))
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: _medicines.length,
                          itemBuilder: (context, index) {
                            final medicine = _medicines[index];
                            final cartItemIndex = cartList.indexWhere((item) => item.medicine.id == medicine.id);
                            final isInCart = cartItemIndex >= 0;
                            final quantity = isInCart ? cartList[cartItemIndex].quantity : 0;

                            return GlassCard(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  // Medicine image placeholder
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      medicine.imageUrl,
                                      width: 64,
                                      height: 64,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  
                                  // Info
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          medicine.name,
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          medicine.category,
                                          style: const TextStyle(color: AppColors.textSecondaryLight, fontSize: 11),
                                        ),
                                        const SizedBox(height: 6),
                                        Row(
                                          children: [
                                            Text(
                                              '₹${medicine.discountPrice.toInt()}',
                                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.primaryPurple),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              '₹${medicine.price.toInt()}',
                                              style: const TextStyle(
                                                fontSize: 11,
                                                color: AppColors.textSecondaryLight,
                                                decoration: TextDecoration.lineThrough,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  
                                  // Add button / Quantity Selector
                                  if (!isInCart)
                                    ElevatedButton(
                                      onPressed: () {
                                        cartNotifier.addToCart(medicine);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        foregroundColor: AppColors.primaryTeal,
                                        side: const BorderSide(color: AppColors.primaryTeal),
                                        elevation: 0,
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      ),
                                      child: const Text('Add +', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                    )
                                  else
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: AppColors.primaryTeal),
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white,
                                      ),
                                      child: Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.remove, size: 16, color: AppColors.primaryTeal),
                                            onPressed: () => cartNotifier.updateQuantity(medicine.id, quantity - 1),
                                          ),
                                          Text(
                                            '$quantity',
                                            style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryTeal, fontSize: 13),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.add, size: 16, color: AppColors.primaryTeal),
                                            onPressed: () => cartNotifier.updateQuantity(medicine.id, quantity + 1),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                    const SizedBox(height: 80), // spacer for bottom cart bar
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      
      // Floating Checkout bar if cart is not empty
      bottomSheet: cartList.isNotEmpty
        ? Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : Colors.white,
              border: Border(top: BorderSide(color: isDark ? Colors.white10 : AppColors.borderLight)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.shopping_bag, color: AppColors.primaryTeal),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${cartList.fold(0, (sum, item) => sum + item.quantity)} Items',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        Text(
                          'Total: ₹${cartNotifier.subtotal.toInt()}',
                          style: const TextStyle(color: AppColors.textSecondaryLight, fontSize: 11),
                        ),
                      ],
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () => context.push('/patient/medicines/checkout'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryTeal,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  child: Row(
                    children: const [
                      Text('View Cart', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      SizedBox(width: 6),
                      Icon(Icons.arrow_forward, size: 14),
                    ],
                  ),
                ),
              ],
            ),
          )
        : null,
    );
  }
}
