import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../models/models.dart';
import '../../providers/providers.dart';
import '../../widgets/widgets.dart';

class SkincareMarketplaceScreen extends ConsumerStatefulWidget {
  const SkincareMarketplaceScreen({super.key});

  @override
  ConsumerState<SkincareMarketplaceScreen> createState() => _SkincareMarketplaceScreenState();
}

class _SkincareMarketplaceScreenState extends ConsumerState<SkincareMarketplaceScreen> {
  final List<MedicineModel> _skincareProducts = [
    MedicineModel(
      id: 'med_6',
      name: 'Hyaluronic Hydrating Gel',
      category: 'Skin Care',
      price: 350.0,
      discountPrice: 280.0,
      description: 'Deep hydration formula with hyaluronic acid for soft, glowing skin.',
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
    MedicineModel(
      id: 'med_9',
      name: 'Aloe Vera Soothing Gel',
      category: 'Skin Care',
      price: 150.0,
      discountPrice: 120.0,
      description: '100% organic aloe vera extract gel for sun burn soothe and moisturizer.',
      imageUrl: 'https://images.unsplash.com/photo-1598440947619-2c35fc9aa908?auto=format&fit=crop&q=80&w=300',
      isPrescriptionRequired: false,
    ),
    MedicineModel(
      id: 'med_10',
      name: 'Vitamin C Glow Serum',
      category: 'Skin Care',
      price: 599.0,
      discountPrice: 479.0,
      description: 'Potent vitamin C antioxidant formula to brighten skin tone and fade hyperpigmentation.',
      imageUrl: 'https://images.unsplash.com/photo-1608248597481-496100c8c836?auto=format&fit=crop&q=80&w=300',
      isPrescriptionRequired: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final cartList = ref.watch(cartProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Skincare Store', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_bag_outlined),
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
            // Offers Banner
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: AppColors.accentGradient,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.discount_rounded, color: Colors.white, size: 28),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Buy 2 Get 1 FREE on skincare essentials!\nDiscount applied automatically at checkout.',
                        style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold, height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Grid List
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.72,
                ),
                itemCount: _skincareProducts.length,
                itemBuilder: (context, index) {
                  final prod = _skincareProducts[index];
                  return _productCard(context, prod);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _productCard(BuildContext context, MedicineModel prod) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cartNotifier = ref.read(cartProvider.notifier);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? Colors.white10 : AppColors.borderLight),
        boxShadow: isDark ? null : AppColors.softShadows,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          GestureDetector(
            onTap: () => context.push('/patient/skincare/${prod.id}'),
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: Image.network(
                prod.imageUrl,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          // Info details
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        prod.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      const SizedBox(height: 2),
                      const RatingStars(rating: 4.6),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '₹${prod.discountPrice.toInt()}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.primaryPurple),
                      ),
                      GestureDetector(
                        onTap: () {
                          cartNotifier.addToCart(prod);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${prod.name} added to cart!'), duration: const Duration(seconds: 1)),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.primaryTeal.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.add_shopping_cart, color: AppColors.primaryTeal, size: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
