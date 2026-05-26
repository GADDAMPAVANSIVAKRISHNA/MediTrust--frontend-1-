import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';

// --- Theme Provider ---
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.light) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDarkMode') ?? false;
    state = isDark ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    if (state == ThemeMode.light) {
      state = ThemeMode.dark;
      await prefs.setBool('isDarkMode', true);
    } else {
      state = ThemeMode.light;
      await prefs.setBool('isDarkMode', false);
    }
  }
}

// --- Auth Provider ---
final authProvider = StateNotifierProvider<AuthNotifier, UserModel?>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<UserModel?> {
  AuthNotifier() : super(null) {
    _loadSession();
  }

  Future<void> _loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    final userName = prefs.getString('userName');
    final userEmail = prefs.getString('userEmail');
    final roleString = prefs.getString('userRole');
    final isOnboarded = prefs.getBool('isOnboarded') ?? false;

    if (userId != null && roleString != null) {
      final role = UserRole.values.firstWhere(
        (e) => e.name == roleString,
        orElse: () => UserRole.guest,
      );
      state = UserModel(
        id: userId,
        name: userName ?? 'User',
        email: userEmail ?? '',
        role: role,
        isOnboardingCompleted: isOnboarded,
      );
    }
  }

  Future<void> login(String email, String password, UserRole role) async {
    // Mock successful login
    final name = email.split('@')[0];
    final displayName = name[0].toUpperCase() + name.substring(1);
    
    state = UserModel(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      name: displayName,
      email: email,
      role: role,
      isOnboardingCompleted: role == UserRole.admin, // Admin doesn't need onboarding
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', state!.id);
    await prefs.setString('userName', state!.name);
    await prefs.setString('userEmail', state!.email);
    await prefs.setString('userRole', role.name);
    await prefs.setBool('isOnboarded', state!.isOnboardingCompleted);
  }

  Future<void> signup(String name, String email, String password) async {
    // Signup initializes session, role will be selected on the next screen
    state = UserModel(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
      role: UserRole.guest,
      isOnboardingCompleted: false,
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', state!.id);
    await prefs.setString('userName', state!.name);
    await prefs.setString('userEmail', state!.email);
    await prefs.setString('userRole', UserRole.guest.name);
    await prefs.setBool('isOnboarded', false);
  }

  Future<void> selectRole(UserRole role) async {
    if (state == null) return;
    state = state!.copyWith(role: role);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userRole', role.name);
  }

  Future<void> completeOnboarding(Map<String, dynamic> details) async {
    if (state == null) return;
    
    state = state!.copyWith(
      isOnboardingCompleted: true,
      phone: details['phone'] ?? '',
      city: details['city'] ?? '',
      name: details['name'] ?? state!.name,
      additionalDetails: details,
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', state!.name);
    await prefs.setBool('isOnboarded', true);
  }

  Future<void> logout() async {
    state = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    await prefs.remove('userName');
    await prefs.remove('userEmail');
    await prefs.remove('userRole');
    await prefs.remove('isOnboarded');
  }
}

// --- Cart Provider ---
final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier();
});

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  void addToCart(MedicineModel medicine) {
    final index = state.indexWhere((item) => item.medicine.id == medicine.id);
    if (index >= 0) {
      final updated = List<CartItem>.from(state);
      updated[index].quantity++;
      state = updated;
    } else {
      state = [...state, CartItem(medicine: medicine, quantity: 1)];
    }
  }

  void removeFromCart(String medicineId) {
    state = state.where((item) => item.medicine.id != medicineId).toList();
  }

  void updateQuantity(String medicineId, int qty) {
    if (qty <= 0) {
      removeFromCart(medicineId);
      return;
    }
    state = state.map((item) {
      if (item.medicine.id == medicineId) {
        return CartItem(medicine: item.medicine, quantity: qty);
      }
      return item;
    }).toList();
  }

  void clearCart() {
    state = [];
  }

  double get subtotal => state.fold(0, (sum, item) {
    final price = item.medicine.discountPrice > 0 ? item.medicine.discountPrice : item.medicine.price;
    return sum + (price * item.quantity);
  });

  double get deliveryFee => state.isEmpty ? 0.0 : 40.0;
  
  double get total => subtotal + deliveryFee;
}
