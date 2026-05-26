import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../models/models.dart';
import '../../services/pharmacy_service.dart';
import '../../widgets/widgets.dart';

class PharmacyOrdersScreen extends StatefulWidget {
  const PharmacyOrdersScreen({super.key});

  @override
  State<PharmacyOrdersScreen> createState() => _PharmacyOrdersScreenState();
}

class _PharmacyOrdersScreenState extends State<PharmacyOrdersScreen> {
  final _pharmacyService = PharmacyService();
  List<OrderModel> _orders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  void _loadOrders() async {
    final results = await _pharmacyService.getOrders();
    setState(() {
      _orders = results;
      _isLoading = false;
    });
  }

  void _updateStatus(String id, String status) async {
    await _pharmacyService.updateOrderStatus(id, status);
    _loadOrders();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Order status updated to $status!'),
          backgroundColor: status == 'accepted' ? AppColors.success : AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Incoming Pharmacy Orders', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _orders.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.receipt_long_outlined, size: 64, color: AppColors.textSecondaryLight.withOpacity(0.5)),
                    const SizedBox(height: 12),
                    const Text('No incoming orders', style: TextStyle(color: AppColors.textSecondaryLight)),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: _orders.length,
                itemBuilder: (context, index) {
                  final order = _orders[index];
                  final itemsText = order.items.map((e) => '${e.medicine.name} (x${e.quantity})').join('\n');
                  final isPending = order.status == 'pending';

                  return GlassCard(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Order ID: ${order.id}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: order.status == 'accepted' 
                                  ? AppColors.primaryTeal.withOpacity(0.1) 
                                  : (order.status == 'rejected' ? AppColors.error.withOpacity(0.1) : AppColors.warning.withOpacity(0.1)),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                order.status.toUpperCase(),
                                style: TextStyle(
                                  color: order.status == 'accepted' 
                                    ? AppColors.primaryTeal 
                                    : (order.status == 'rejected' ? AppColors.error : AppColors.warning),
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(Icons.person_outline, size: 16, color: AppColors.textSecondaryLight),
                            const SizedBox(width: 8),
                            Text('Patient: ${order.patientName}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.location_on_outlined, size: 16, color: AppColors.textSecondaryLight),
                            const SizedBox(width: 8),
                            Expanded(child: Text('Deliver to: ${order.deliveryAddress}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryLight))),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.0),
                          child: Divider(height: 1, color: AppColors.borderLight),
                        ),
                        const Text('Ordered Items:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        const SizedBox(height: 6),
                        Text(itemsText, style: TextStyle(fontSize: 13, height: 1.4, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.0),
                          child: Divider(height: 1, color: AppColors.borderLight),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Amount: ₹${order.totalAmount.toInt()}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.primaryPurple),
                            ),
                            if (isPending)
                              Row(
                                children: [
                                  TextButton(
                                    onPressed: () => _updateStatus(order.id, 'rejected'),
                                    child: const Text('Reject', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
                                  ),
                                  const SizedBox(width: 8),
                                  ElevatedButton(
                                    onPressed: () => _updateStatus(order.id, 'accepted'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primaryTeal,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                    child: const Text('Accept', style: TextStyle(fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
