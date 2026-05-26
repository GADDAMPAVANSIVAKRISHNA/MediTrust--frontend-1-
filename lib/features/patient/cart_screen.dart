import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/providers.dart';
import '../../services/pharmacy_service.dart';
import '../../widgets/widgets.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  final _addressController = TextEditingController(text: 'House 42, Green Avenue, Cityville');
  final _promoController = TextEditingController();
  final _pharmacyService = PharmacyService();

  bool _isPromoApplied = false;
  double _promoDiscount = 0.0;
  bool _isPlacingOrder = false;

  void _applyPromo() {
    if (_promoController.text.toUpperCase() == 'MEDITRUST20') {
      final cartNotifier = ref.read(cartProvider.notifier);
      setState(() {
        _isPromoApplied = true;
        _promoDiscount = cartNotifier.subtotal * 0.20;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Promo Code MEDITRUST20 applied! 20% Discount saved.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid Promo Code')),
      );
    }
  }

  void _placeOrder() async {
    final cartList = ref.read(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);
    final authState = ref.read(authProvider);

    if (cartList.isEmpty) return;
    if (_addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a delivery address')));
      return;
    }

    setState(() => _isPlacingOrder = true);
    
    final grandTotal = cartNotifier.total - _promoDiscount;
    
    final newOrder = await _pharmacyService.createOrder(
      cartList,
      grandTotal,
      _addressController.text,
      authState?.name ?? 'Sarah Johnson',
    );

    cartNotifier.clearCart();
    setState(() => _isPlacingOrder = false);

    if (mounted) {
      context.go('/success?message=Your medicine order has been placed successfully!\nTracking ID: ${newOrder.id}&next=/patient/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartList = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final double discount = _isPromoApplied ? _promoDiscount : 0.0;
    final double finalTotal = cartNotifier.total - discount;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout Cart', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: cartList.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 64, color: AppColors.textSecondaryLight.withOpacity(0.5)),
                  const SizedBox(height: 12),
                  const Text('Your cart is empty', style: TextStyle(color: AppColors.textSecondaryLight)),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => context.pop(),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryTeal, foregroundColor: Colors.white),
                    child: const Text('Shop Medicines'),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Cart Items List
                        const Text('Review Items', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        const SizedBox(height: 12),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: cartList.length,
                          itemBuilder: (context, index) {
                            final item = cartList[index];
                            return GlassCard(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(item.medicine.imageUrl, width: 48, height: 48, fit: BoxFit.cover),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(item.medicine.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                        const SizedBox(height: 4),
                                        Text(
                                          '₹${(item.medicine.discountPrice > 0 ? item.medicine.discountPrice : item.medicine.price).toInt()} x ${item.quantity}',
                                          style: const TextStyle(color: AppColors.textSecondaryLight, fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: AppColors.primaryTeal),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.remove, size: 14, color: AppColors.primaryTeal),
                                          onPressed: () => cartNotifier.updateQuantity(item.medicine.id, item.quantity - 1),
                                          constraints: const BoxConstraints(maxWidth: 32),
                                        ),
                                        Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryTeal, fontSize: 12)),
                                        IconButton(
                                          icon: const Icon(Icons.add, size: 14, color: AppColors.primaryTeal),
                                          onPressed: () => cartNotifier.updateQuantity(item.medicine.id, item.quantity + 1),
                                          constraints: const BoxConstraints(maxWidth: 32),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // Delivery Address
                        const Text('Delivery Address', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        const SizedBox(height: 12),
                        CustomTextField(
                          label: 'Shipping Address',
                          hint: 'Enter your address',
                          controller: _addressController,
                          prefixIcon: Icons.local_shipping_outlined,
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Promo Code Input
                        const Text('Promo Code', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF3F4F6),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: TextField(
                                  controller: _promoController,
                                  decoration: const InputDecoration(
                                    hintText: 'Enter promo code',
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton(
                              onPressed: _applyPromo,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryTeal,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: const Text('Apply', style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Summary Block
                        const Text('Payment Summary', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        const SizedBox(height: 12),
                        GlassCard(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              _summaryRow('Subtotal', '₹${cartNotifier.subtotal.toInt()}'),
                              const SizedBox(height: 8),
                              _summaryRow('Delivery Fee', '₹${cartNotifier.deliveryFee.toInt()}'),
                              if (_isPromoApplied) ...[
                                const SizedBox(height: 8),
                                _summaryRow('Promo Discount', '-₹${discount.toInt()}', color: AppColors.success),
                              ],
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                child: Divider(height: 1, color: AppColors.borderLight),
                              ),
                              _summaryRow(
                                'Grand Total', 
                                '₹${finalTotal.toInt()}',
                                isBold: true,
                                color: AppColors.primaryPurple,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
                
                // Confirm Checkout bottom row
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardDark : Colors.white,
                    border: Border(top: BorderSide(color: isDark ? Colors.white10 : AppColors.borderLight)),
                  ),
                  child: CustomButton(
                    text: 'Place Order  •  ₹${finalTotal.toInt()}',
                    isLoading: _isPlacingOrder,
                    onPressed: _placeOrder,
                  ),
                ),
              ],
            ),
      ),
    );
  }

  Widget _summaryRow(String label, String val, {bool isBold = false, Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isBold ? AppColors.textPrimaryLight : AppColors.textSecondaryLight,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            fontSize: isBold ? 14 : 13,
          ),
        ),
        Text(
          val,
          style: TextStyle(
            color: color ?? AppColors.textPrimaryLight,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            fontSize: isBold ? 16 : 13,
          ),
        ),
      ],
    );
  }
}
