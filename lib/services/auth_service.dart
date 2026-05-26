import '../models/models.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  Future<UserModel> login(String email, String password, UserRole role) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return UserModel(
      id: 'usr_mock_123',
      name: email.split('@')[0],
      email: email,
      role: role,
      isOnboardingCompleted: role == UserRole.admin,
    );
  }

  Future<UserModel> signup(String name, String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return UserModel(
      id: 'usr_mock_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
      role: UserRole.guest,
      isOnboardingCompleted: false,
    );
  }

  Future<void> sendOtp(String contactInfo) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<bool> verifyOtp(String otpCode) async {
    await Future.delayed(const Duration(milliseconds: 600));
    // Accept '123456' as valid OTP code
    return otpCode == '123456' || otpCode.length == 6;
  }
}
