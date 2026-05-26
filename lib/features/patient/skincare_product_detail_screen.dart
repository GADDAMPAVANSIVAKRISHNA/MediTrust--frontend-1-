import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../models/models.dart';
import '../../providers/providers.dart';
import '../../widgets/widgets.dart';

class SkincareProductDetailScreen extends ConsumerStatefulWidget {
  final String productId;
  const SkincareProductDetailScreen({super.key, required this.productId});

  @override
  ConsumerState<SkincareProductDetailScreen> createState() => _SkincareProductDetailScreenState();
}

class _SkincareProductDetailScreenState extends ConsumerState<SkincareProductDetailScreen> {
  MedicineModel? _product;
  bool _isLoading = true;

  final List<MedicineModel> _skincareProducts = [
    MedicineModel(
      id: 'med_6',
      name: 'Hyaluronic Hydrating Gel',
      category: 'Skin Care',
      price: 350.0,
      discountPrice: 280.0,
      description: 'Deep hydration formula with hyaluronic acid for soft, glowing skin. Rapid absorption properties which replenish dry dermal layouts.',
      imageUrl: 'https://images.unsplash.com/photo-1601049541289-9b1b7bbbfe19?auto=format&fit=crop&q=80&w=300',
      isPrescriptionRequired: false,
    ),
    MedicineModel(
      id: 'med_7',
      name: 'Niacinamide Serum 10%',
      category: 'Skin Care',
      price: 499.0,
      discountPrice: 399.0,
      description: 'Corrects skin blemishes, minimizes pores, and balances sebum production. Promotes clear skin textures.',
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
  void initState() {
    super.initState();
    _loadProduct();
  }

  void _loadProduct() async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _skincareProducts.indexWhere((p) => p.id == widget.productId);
    setState(() {
      _product = index >= 0 ? _skincareProducts[index] : null;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_product == null) {
      return const Scaffold(body: Center(child: Text('Product not found.')));
    }

    final prod = _product!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cartNotifier = ref.read(cartProvider.notifier);

    return Scaffold(
      body: Stack(
        children: [
          // Content Layout
          Positioned.fill(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image
                  Container(
                    height: 350,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(prod.imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.3),
                            Colors.transparent,
                            isDark ? AppColors.darkBg : AppColors.lightBg,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),
                  
                  // Product details
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          prod.name,
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: const [
                            RatingStars(rating: 4.7, reviewsCount: 84),
                          ],
                        ),
                        const SizedBox(height: 16),
                        
                        // Price
                        Row(
                          children: [
                            Text(
                              '₹${prod.discountPrice.toInt()}',
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primaryPurple),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              '₹${prod.price.toInt()}',
                              style: const TextStyle(fontSize: 16, color: AppColors.textSecondaryLight, decoration: TextDecoration.lineThrough),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.success.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text('20% OFF', style: TextStyle(color: AppColors.success, fontWeight: FontWeight.bold, fontSize: 11)),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 24),
                        
                        const Text('Product Description', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text(
                          prod.description,
                          style: TextStyle(fontSize: 14, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight, height: 1.5),
                        ),
                        const SizedBox(height: 20),
                        
                        const Text('Usage Directions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text(
                          'Apply 3-4 drops to cleansed facial areas twice daily. Avoid direct contact with eye boundaries.',
                          style: TextStyle(fontSize: 14, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight, height: 1.5),
                        ),
                        const SizedBox(height: 120),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Back button
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 20,
            child: CircleAvatar(
              backgroundColor: Colors.white.withOpacity(0.8),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimaryLight, size: 18),
                onPressed: () => context.pop(),
              ),
            ),
          ),
          
          // Bottom add to cart CTA
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: CustomButton(
              text: 'Add to Cart',
              onPressed: () {
                cartNotifier.addToCart(prod);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${prod.name} added to cart!'), duration: const Duration(seconds: 1)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
