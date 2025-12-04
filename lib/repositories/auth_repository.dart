/// File: lib/repositories/auth_repository.dart
/// Purpose: Authentication repository interface and dummy implementation
/// Belongs To: shared
/// Customization Guide:
///    - Implement the interface with actual backend API
///    - Replace DummyAuthRepository with real implementation

import '../models/user_model.dart';

/// Authentication result wrapper.
class AuthResult {
  const AuthResult({
    this.user,
    this.accessToken,
    this.refreshToken,
    this.error,
    this.success = false,
  });
  
  final UserModel? user;
  final String? accessToken;
  final String? refreshToken;
  final String? error;
  final bool success;
  
  factory AuthResult.success({
    required UserModel user,
    required String accessToken,
    String? refreshToken,
  }) => AuthResult(
    user: user,
    accessToken: accessToken,
    refreshToken: refreshToken,
    success: true,
  );
  
  factory AuthResult.failure(String error) => AuthResult(
    error: error,
    success: false,
  );
}

/// Authentication repository interface.
/// Implement this for actual backend integration.
abstract class AuthRepository {
  /// Login with email and password.
  Future<AuthResult> login({
    required String email,
    required String password,
  });
  
  /// Register new user.
  Future<AuthResult> register({
    required String email,
    required String password,
    required String fullName,
    String? phone,
  });
  
  /// Logout current user.
  Future<bool> logout();
  
  /// Send password reset email.
  Future<bool> forgotPassword(String email);
  
  /// Reset password with token.
  Future<bool> resetPassword({
    required String token,
    required String newPassword,
  });
  
  /// Verify email with OTP.
  Future<bool> verifyOtp({
    required String email,
    required String otp,
  });
  
  /// Resend OTP.
  Future<bool> resendOtp(String email);
  
  /// Get current user.
  Future<UserModel?> getCurrentUser();
  
  /// Refresh auth token.
  Future<String?> refreshToken();
  
  /// Social login (Google, Apple, etc.).
  Future<AuthResult> socialLogin({
    required String provider,
    required String token,
  });
}

/// Dummy authentication repository for development/testing.
class DummyAuthRepository implements AuthRepository {
  UserModel? _currentUser;
  
  @override
  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Dummy validation
    if (email.isEmpty || password.isEmpty) {
      return AuthResult.failure('Email and password are required');
    }
    
    if (!email.contains('@')) {
      return AuthResult.failure('Invalid email format');
    }
    
    if (password.length < 6) {
      return AuthResult.failure('Password too short');
    }
    
    // Create dummy user
    _currentUser = UserModel(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      fullName: 'John Doe',
      phone: '+1234567890',
      role: UserRole.user,
      isVerified: true,
      createdAt: DateTime.now(),
    );
    
    return AuthResult.success(
      user: _currentUser!,
      accessToken: 'dummy_access_token_${DateTime.now().millisecondsSinceEpoch}',
      refreshToken: 'dummy_refresh_token_${DateTime.now().millisecondsSinceEpoch}',
    );
  }
  
  @override
  Future<AuthResult> register({
    required String email,
    required String password,
    required String fullName,
    String? phone,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    
    if (email.isEmpty || password.isEmpty || fullName.isEmpty) {
      return AuthResult.failure('All fields are required');
    }
    
    _currentUser = UserModel(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      fullName: fullName,
      phone: phone,
      role: UserRole.user,
      isVerified: false,
      createdAt: DateTime.now(),
    );
    
    return AuthResult.success(
      user: _currentUser!,
      accessToken: 'dummy_access_token_${DateTime.now().millisecondsSinceEpoch}',
      refreshToken: 'dummy_refresh_token_${DateTime.now().millisecondsSinceEpoch}',
    );
  }
  
  @override
  Future<bool> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUser = null;
    return true;
  }
  
  @override
  Future<bool> forgotPassword(String email) async {
    await Future.delayed(const Duration(seconds: 1));
    return email.isNotEmpty && email.contains('@');
  }
  
  @override
  Future<bool> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    return token.isNotEmpty && newPassword.length >= 6;
  }
  
  @override
  Future<bool> verifyOtp({
    required String email,
    required String otp,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    // Accept any 6-digit OTP for dummy
    return otp.length == 6;
  }
  
  @override
  Future<bool> resendOtp(String email) async {
    await Future.delayed(const Duration(seconds: 1));
    return email.isNotEmpty;
  }
  
  @override
  Future<UserModel?> getCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _currentUser;
  }
  
  @override
  Future<String?> refreshToken() async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (_currentUser != null) {
      return 'dummy_access_token_${DateTime.now().millisecondsSinceEpoch}';
    }
    return null;
  }
  
  @override
  Future<AuthResult> socialLogin({
    required String provider,
    required String token,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    
    _currentUser = UserModel(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      email: 'social_${provider.toLowerCase()}@example.com',
      fullName: 'Social User',
      role: UserRole.user,
      isVerified: true,
      createdAt: DateTime.now(),
    );
    
    return AuthResult.success(
      user: _currentUser!,
      accessToken: 'dummy_social_token_${DateTime.now().millisecondsSinceEpoch}',
    );
  }
}

