import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/models.dart';
import '../providers/providers.dart';

// Import Screens
import '../features/auth/splash_screen.dart';
import '../features/auth/welcome_screen.dart';
import '../features/auth/login_screen.dart';
import '../features/auth/signup_screen.dart';
import '../features/auth/forgot_password_screen.dart';
import '../features/auth/otp_screen.dart';
import '../features/auth/role_selection_screen.dart';
import '../features/auth/patient_onboarding_screen.dart';
import '../features/auth/doctor_onboarding_screen.dart';
import '../features/auth/pharmacy_onboarding_screen.dart';
import '../features/auth/success_screen.dart';

// Patient Screens
import '../features/patient/patient_shell.dart';
import '../features/patient/home_screen.dart';
import '../features/patient/appointments_screen.dart';
import '../features/patient/chat_list_screen.dart';
import '../features/patient/orders_screen.dart';
import '../features/patient/profile_screen.dart';
import '../features/patient/doctor_search_screen.dart';
import '../features/patient/doctor_profile_screen.dart';
import '../features/patient/book_appointment_screen.dart';
import '../features/patient/video_call_screen.dart';
import '../features/patient/chat_screen.dart';
import '../features/patient/prescription_detail_screen.dart';
import '../features/patient/medicine_shop_screen.dart';
import '../features/patient/cart_screen.dart';
import '../features/patient/order_tracking_screen.dart';
import '../features/patient/ai_health_assistant_screen.dart';
import '../features/patient/voice_assistant_screen.dart';
import '../features/patient/skin_scan_screen.dart';
import '../features/patient/skincare_marketplace_screen.dart';
import '../features/patient/skincare_product_detail_screen.dart';

// Doctor Screens
import '../features/doctor/doctor_shell.dart';
import '../features/doctor/dashboard_screen.dart';
import '../features/doctor/patients_screen.dart';
import '../features/doctor/consultations_screen.dart';
import '../features/doctor/earnings_screen.dart';
import '../features/doctor/profile_screen.dart';
import '../features/doctor/prescription_creator_screen.dart';

// Pharmacy Screens
import '../features/pharmacy/pharmacy_shell.dart';
import '../features/pharmacy/orders_screen.dart' as pharm_orders;
import '../features/pharmacy/inventory_screen.dart';
import '../features/pharmacy/deliveries_screen.dart';
import '../features/pharmacy/earnings_screen.dart' as pharm_earnings;
import '../features/pharmacy/profile_screen.dart' as pharm_profile;

// Admin Screens
import '../features/admin/admin_dashboard_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final location = state.uri.path;
      final isLoggedIn = authState != null;

      // Unauthenticated routes list
      final guestRoutes = [
        '/',
        '/welcome',
        '/login',
        '/signup',
        '/forgot-password',
        '/otp',
      ];

      // If not logged in, and trying to access a protected route, go to welcome
      if (!isLoggedIn) {
        if (!guestRoutes.contains(location)) {
          return '/welcome';
        }
        return null;
      }

      // If logged in but role is guest, must select a role
      if (authState.role == UserRole.guest && location != '/role-selection') {
        return '/role-selection';
      }

      // If role selected but onboarding not complete
      if (isLoggedIn && authState.role != UserRole.guest && !authState.isOnboardingCompleted) {
        if (authState.role == UserRole.patient && location != '/patient-onboarding') {
          return '/patient-onboarding';
        } else if (authState.role == UserRole.doctor && location != '/doctor-onboarding') {
          return '/doctor-onboarding';
        } else if (authState.role == UserRole.pharmacy && location != '/pharmacy-onboarding') {
          return '/pharmacy-onboarding';
        }
      }

      // If logged in and onboarding is completed (or Admin), prevent going to login/signup/welcome
      if (isLoggedIn && guestRoutes.contains(location) && location != '/') {
        switch (authState.role) {
          case UserRole.patient:
            return '/patient/home';
          case UserRole.doctor:
            return '/doctor/home';
          case UserRole.pharmacy:
            return '/pharmacy/home';
          case UserRole.admin:
            return '/admin/home';
          default:
            return '/role-selection';
        }
      }

      return null;
    },
    routes: [
      // Splash
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      // Welcome & Auth
      GoRoute(
        path: '/welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/otp',
        builder: (context, state) => const OtpScreen(),
      ),
      GoRoute(
        path: '/role-selection',
        builder: (context, state) => const RoleSelectionScreen(),
      ),
      GoRoute(
        path: '/success',
        builder: (context, state) {
          final message = state.uri.queryParameters['message'] ?? 'Action Successful';
          final nextRoute = state.uri.queryParameters['next'] ?? '/';
          return SuccessScreen(message: message, nextRoute: nextRoute);
        },
      ),

      // Onboarding
      GoRoute(
        path: '/patient-onboarding',
        builder: (context, state) => const PatientOnboardingScreen(),
      ),
      GoRoute(
        path: '/doctor-onboarding',
        builder: (context, state) => const DoctorOnboardingScreen(),
      ),
      GoRoute(
        path: '/pharmacy-onboarding',
        builder: (context, state) => const PharmacyOnboardingScreen(),
      ),

      // Patient Routes with Bottom Navigation Shell
      ShellRoute(
        builder: (context, state, child) {
          return PatientShell(child: child);
        },
        routes: [
          GoRoute(
            path: '/patient/home',
            builder: (context, state) => const PatientHomeScreen(),
          ),
          GoRoute(
            path: '/patient/appointments',
            builder: (context, state) => const PatientAppointmentsScreen(),
          ),
          GoRoute(
            path: '/patient/chats',
            builder: (context, state) => const PatientChatListScreen(),
          ),
          GoRoute(
            path: '/patient/orders',
            builder: (context, state) => const PatientOrdersScreen(),
          ),
          GoRoute(
            path: '/patient/profile',
            builder: (context, state) => const PatientProfileScreen(),
          ),
        ],
      ),

      // Patient Detailed Sub-routes (Full Screen)
      GoRoute(
        path: '/patient/doctors',
        builder: (context, state) => const DoctorSearchScreen(),
      ),
      GoRoute(
        path: '/patient/doctor/:id',
        builder: (context, state) => DoctorProfileScreen(doctorId: state.pathParameters['id'] ?? ''),
      ),
      GoRoute(
        path: '/patient/book/:id',
        builder: (context, state) => BookAppointmentScreen(doctorId: state.pathParameters['id'] ?? ''),
      ),
      GoRoute(
        path: '/patient/video/:id',
        builder: (context, state) => VideoCallScreen(appointmentId: state.pathParameters['id'] ?? ''),
      ),
      GoRoute(
        path: '/patient/chat/:id',
        builder: (context, state) => ChatScreen(doctorId: state.pathParameters['id'] ?? ''),
      ),
      GoRoute(
        path: '/patient/prescription/:id',
        builder: (context, state) => PrescriptionDetailScreen(prescriptionId: state.pathParameters['id'] ?? ''),
      ),
      GoRoute(
        path: '/patient/medicines',
        builder: (context, state) => const MedicineShopScreen(),
      ),
      GoRoute(
        path: '/patient/medicines/checkout',
        builder: (context, state) => const CartScreen(),
      ),
      GoRoute(
        path: '/patient/medicines/track/:orderId',
        builder: (context, state) => OrderTrackingScreen(orderId: state.pathParameters['orderId'] ?? ''),
      ),
      GoRoute(
        path: '/patient/ai-assistant',
        builder: (context, state) => const AiHealthAssistantScreen(),
      ),
      GoRoute(
        path: '/patient/voice-assistant',
        builder: (context, state) => const VoiceAssistantScreen(),
      ),
      GoRoute(
        path: '/patient/skin-scan',
        builder: (context, state) => const SkinScanScreen(),
      ),
      GoRoute(
        path: '/patient/skincare',
        builder: (context, state) => const SkincareMarketplaceScreen(),
      ),
      GoRoute(
        path: '/patient/skincare/:id',
        builder: (context, state) => SkincareProductDetailScreen(productId: state.pathParameters['id'] ?? ''),
      ),

      // Doctor Routes with Bottom Navigation Shell
      ShellRoute(
        builder: (context, state, child) {
          return DoctorShell(child: child);
        },
        routes: [
          GoRoute(
            path: '/doctor/home',
            builder: (context, state) => const DoctorDashboardScreen(),
          ),
          GoRoute(
            path: '/doctor/patients',
            builder: (context, state) => const DoctorPatientsScreen(),
          ),
          GoRoute(
            path: '/doctor/consultations',
            builder: (context, state) => const DoctorConsultationsScreen(),
          ),
          GoRoute(
            path: '/doctor/earnings',
            builder: (context, state) => const DoctorEarningsScreen(),
          ),
          GoRoute(
            path: '/doctor/profile',
            builder: (context, state) => const DoctorSettingsProfileScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/doctor/create-prescription/:id',
        builder: (context, state) => PrescriptionCreatorScreen(appointmentId: state.pathParameters['id'] ?? ''),
      ),

      // Pharmacy Routes with Bottom Navigation Shell
      ShellRoute(
        builder: (context, state, child) {
          return PharmacyShell(child: child);
        },
        routes: [
          GoRoute(
            path: '/pharmacy/home',
            builder: (context, state) => const pharm_orders.PharmacyOrdersScreen(),
          ),
          GoRoute(
            path: '/pharmacy/medicines',
            builder: (context, state) => const PharmacyInventoryScreen(),
          ),
          GoRoute(
            path: '/pharmacy/deliveries',
            builder: (context, state) => const PharmacyDeliveriesScreen(),
          ),
          GoRoute(
            path: '/pharmacy/earnings',
            builder: (context, state) => const pharm_earnings.PharmacyEarningsScreen(),
          ),
          GoRoute(
            path: '/pharmacy/profile',
            builder: (context, state) => const pharm_profile.PharmacyProfileScreen(),
          ),
        ],
      ),

      // Admin Routes (Full Screen Dashboard)
      GoRoute(
        path: '/admin/home',
        builder: (context, state) => const AdminDashboardScreen(),
      ),
    ],
  );
});
