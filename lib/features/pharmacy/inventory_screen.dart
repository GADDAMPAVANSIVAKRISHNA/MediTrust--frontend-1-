import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../models/models.dart';
import '../../services/pharmacy_service.dart';
import '../../widgets/widgets.dart';

class PharmacyInventoryScreen extends StatefulWidget {
  const PharmacyInventoryScreen({super.key});

  @override
  State<PharmacyInventoryScreen> createState() => _PharmacyInventoryScreenState();
}

class _PharmacyInventoryScreenState extends State<PharmacyInventoryScreen> {
  final _pharmacyService = PharmacyService();
  List<MedicineModel> _inventory = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInventory();
  }

  void _loadInventory() async {
    final results = await _pharmacyService.getMedicines();
    setState(() {
      _inventory = results;
      _isLoading = false;
    });
  }

  void _showAddDialog() {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final categoryController = TextEditingController(text: 'Pain Relief');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Medicine'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Medicine Name'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Price (INR)'),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: categoryController.text,
                decoration: const InputDecoration(labelText: 'Category'),
                items: ['Pain Relief', 'Vitamins', 'Antibiotics', 'Skin Care', 'Diabetes'].map((val) {
                  return DropdownMenuItem(value: val, child: Text(val));
                }).toList(),
                onChanged: (val) {
                  if (val != null) categoryController.text = val;
                },
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isNotEmpty && priceController.text.isNotEmpty) {
                  final price = double.tryParse(priceController.text) ?? 10.0;
                  final newMed = MedicineModel(
                    id: 'med_custom_${DateTime.now().millisecondsSinceEpoch}',
                    name: nameController.text,
                    category: categoryController.text,
                    price: price,
                    discountPrice: price * 0.8, // default 20% discount
                    description: 'Custom added pharmacy item',
                    imageUrl: 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?auto=format&fit=crop&q=80&w=150',
                    isPrescriptionRequired: false,
                  );
                  await _pharmacyService.addMedicine(newMed);
                  _loadInventory();
                  if (mounted) Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Store Inventory', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              itemCount: _inventory.length,
              itemBuilder: (context, index) {
                final med = _inventory[index];
                final isPresc = med.isPrescriptionRequired;

                return GlassCard(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(med.imageUrl, width: 56, height: 56, fit: BoxFit.cover),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(med.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            const SizedBox(height: 4),
                            Text(
                              '${med.category} • ₹${med.discountPrice.toInt()}',
                              style: const TextStyle(color: AppColors.textSecondaryLight, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      if (isPresc)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.error.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text('Rx Required', style: TextStyle(color: AppColors.error, fontSize: 9, fontWeight: FontWeight.bold)),
                        ),
                    ],
                  ),
                );
              },
            ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryTeal,
        foregroundColor: Colors.white,
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
