import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_theme.dart';
import '../../models/models.dart';
import '../../services/pharmacy_service.dart';
import '../../widgets/widgets.dart';

class PatientOrdersScreen extends StatefulWidget {
  const PatientOrdersScreen({super.key});

  @override
  State<PatientOrdersScreen> createState() => _PatientOrdersScreenState();
}

class _PatientOrdersScreenState extends State<PatientOrdersScreen> {
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
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
                    Icon(Icons.shopping_bag_outlined, size: 64, color: AppColors.textSecondaryLight.withOpacity(0.5)),
                    const SizedBox(height: 12),
                    const Text('No orders placed yet', style: TextStyle(color: AppColors.textSecondaryLight)),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                itemCount: _orders.length,
                itemBuilder: (context, index) {
                  final order = _orders[index];
                  final itemsText = order.items.map((e) => '${e.medicine.name} (x${e.quantity})').join(', ');

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
                            _buildStatusChip(order.status),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          DateFormat('MMM dd, yyyy  •  hh:mm a').format(order.date),
                          style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryLight),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          child: Divider(height: 1, color: AppColors.borderLight),
                        ),
                        
                        // Items List Preview
                        Text(
                          'Items: $itemsText',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Amount: ₹${order.totalAmount.toInt()}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.primaryPurple),
                            ),
                            if (order.status != 'delivered')
                              ElevatedButton(
                                onPressed: () {
                                  context.push('/patient/medicines/track/${order.id}');
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: AppColors.primaryTeal,
                                  side: const BorderSide(color: AppColors.primaryTeal),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                ),
                                child: const Text('Track Shipment', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
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

  Widget _buildStatusChip(String status) {
    Color color = AppColors.warning;
    String label = 'Pending';
    
    if (status == 'accepted') {
      color = AppColors.primaryTeal;
      label = 'Accepted';
    } else if (status == 'delivered') {
      color = AppColors.success;
      label = 'Delivered';
    } else if (status == 'rejected') {
      color = AppColors.error;
      label = 'Rejected';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }
}
