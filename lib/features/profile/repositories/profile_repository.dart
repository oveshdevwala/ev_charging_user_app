/// File: lib/features/profile/repositories/profile_repository.dart
/// Purpose: Profile repository interface and implementation
/// Belongs To: profile feature
/// Customization Guide:
///    - Add new methods as needed
///    - Replace dummy implementation with real API calls
library;

import '../models/models.dart';

/// Profile repository interface.
/// Pure Dart - no Flutter imports.
abstract class ProfileRepository {
  /// Get user profile.
  Future<UserProfileModel> getProfile();

  /// Update user profile.
  Future<UserProfileModel> updateProfile(UserProfileModel profile);

  /// Upload avatar image.
  Future<String> uploadAvatar(String imagePath);

  /// Change password.
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  /// Re-authenticate user.
  Future<bool> reauthenticate(String password);

  /// Delete account.
  Future<void> deleteAccount(String reason);

  /// Export user data.
  Future<String> exportData(); // Returns file path or URL

  /// Get payment methods.
  Future<List<PaymentMethodModel>> getPaymentMethods();

  /// Add payment method.
  Future<PaymentMethodModel> addPaymentMethod({
    required String gatewayToken,
    required String brand,
    required String last4,
    required int expMonth,
    required int expYear,
  });

  /// Set default payment method.
  Future<void> setDefaultPaymentMethod(String id);

  /// Remove payment method.
  Future<void> removePaymentMethod(String id);

  /// Get wallet balance and transactions.
  Future<WalletModel> getWallet();

  /// Top up wallet.
  Future<WalletTransactionModel> topUpWallet({
    required double amount,
    required String paymentMethodId,
  });

  /// Get billing history.
  Future<List<Map<String, dynamic>>> getBillingHistory();

  /// Get privacy policy content.
  Future<String> getPrivacyPolicy();

  /// Get terms of service content.
  Future<String> getTermsOfService();

  /// Submit support ticket.
  Future<SupportTicketModel> submitSupportTicket({
    required String subject,
    required String message,
    List<String>? attachments,
  });

  /// Get support tickets.
  Future<List<SupportTicketModel>> getSupportTickets();

  /// Get FAQ items.
  Future<List<Map<String, String>>> getFAQ();

  /// Update preferences.
  Future<UserPreferencesModel> updatePreferences(UserPreferencesModel preferences);
}

/// Dummy implementation of ProfileRepository.
/// Returns mock data for development.
class DummyProfileRepository implements ProfileRepository {
  @override
  Future<UserProfileModel> getProfile() async {
    await Future.delayed(const Duration(seconds: 1));
    return UserProfileModel(
      id: 'user_123',
      name: 'John Doe',
      email: 'john.doe@example.com',
      phone: '+1234567890',
      avatarUrl: null,
      joinedAt: DateTime.now().subtract(const Duration(days: 365)),
      vehicleInfo: {
        'make': 'Tesla',
        'model': 'Model 3',
        'battery': '75 kWh',
      },
      preferences: const UserPreferencesModel(),
      bio: 'EV enthusiast and sustainability advocate',
      address: '123 Main St, City, State 12345',
    );
  }

  @override
  Future<UserProfileModel> updateProfile(UserProfileModel profile) async {
    await Future.delayed(const Duration(seconds: 1));
    return profile;
  }

  @override
  Future<String> uploadAvatar(String imagePath) async {
    await Future.delayed(const Duration(seconds: 2));
    return 'https://example.com/avatars/user_123.jpg';
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Future<bool> reauthenticate(String password) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return password.isNotEmpty;
  }

  @override
  Future<void> deleteAccount(String reason) async {
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Future<String> exportData() async {
    await Future.delayed(const Duration(seconds: 2));
    return 'https://example.com/exports/user_123_data.zip';
  }

  @override
  Future<List<PaymentMethodModel>> getPaymentMethods() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      PaymentMethodModel(
        id: 'pm_1',
        brand: 'Visa',
        last4: '4242',
        expMonth: 12,
        expYear: 2025,
        isDefault: true,
        gatewayToken: 'tok_visa_123',
      ),
      PaymentMethodModel(
        id: 'pm_2',
        brand: 'Mastercard',
        last4: '5555',
        expMonth: 6,
        expYear: 2026,
        isDefault: false,
        gatewayToken: 'tok_mc_456',
      ),
    ];
  }

  @override
  Future<PaymentMethodModel> addPaymentMethod({
    required String gatewayToken,
    required String brand,
    required String last4,
    required int expMonth,
    required int expYear,
  }) async {
    await Future.delayed(const Duration(seconds: 2));
    return PaymentMethodModel(
      id: 'pm_${DateTime.now().millisecondsSinceEpoch}',
      brand: brand,
      last4: last4,
      expMonth: expMonth,
      expYear: expYear,
      isDefault: false,
      gatewayToken: gatewayToken,
    );
  }

  @override
  Future<void> setDefaultPaymentMethod(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<void> removePaymentMethod(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<WalletModel> getWallet() async {
    await Future.delayed(const Duration(seconds: 1));
    return WalletModel(
      balance: 125.50,
      currency: 'USD',
      transactions: [
        WalletTransactionModel(
          id: 'tx_1',
          type: WalletTransactionType.credit,
          amount: 50.0,
          description: 'Wallet Top-up',
          createdAt: DateTime.now().subtract(const Duration(days: 5)),
          referenceId: 'ref_123',
        ),
        WalletTransactionModel(
          id: 'tx_2',
          type: WalletTransactionType.debit,
          amount: 25.50,
          description: 'Charging Session',
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
          referenceId: 'session_456',
        ),
      ],
    );
  }

  @override
  Future<WalletTransactionModel> topUpWallet({
    required double amount,
    required String paymentMethodId,
  }) async {
    await Future.delayed(const Duration(seconds: 2));
    return WalletTransactionModel(
      id: 'tx_${DateTime.now().millisecondsSinceEpoch}',
      type: WalletTransactionType.credit,
      amount: amount,
      description: 'Wallet Top-up',
      createdAt: DateTime.now(),
      referenceId: 'ref_${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  @override
  Future<List<Map<String, dynamic>>> getBillingHistory() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      {
        'id': 'bill_1',
        'date': DateTime.now().subtract(const Duration(days: 30)).toIso8601String(),
        'amount': 45.00,
        'description': 'Monthly Subscription',
        'status': 'paid',
      },
      {
        'id': 'bill_2',
        'date': DateTime.now().subtract(const Duration(days: 60)).toIso8601String(),
        'amount': 45.00,
        'description': 'Monthly Subscription',
        'status': 'paid',
      },
    ];
  }

  @override
  Future<String> getPrivacyPolicy() async {
    await Future.delayed(const Duration(seconds: 1));
    return '''
# Privacy Policy

## Introduction
This Privacy Policy describes how we collect, use, and protect your personal information.

## Information We Collect
- Personal identification information
- Payment information (tokenized)
- Usage data

## How We Use Your Information
- To provide and improve our services
- To process payments
- To communicate with you

## Data Security
We implement appropriate security measures to protect your data.

## Contact Us
For questions about this policy, contact us at privacy@example.com.
''';
  }

  @override
  Future<String> getTermsOfService() async {
    await Future.delayed(const Duration(seconds: 1));
    return '''
# Terms of Service

## Agreement to Terms
By using our service, you agree to these terms.

## Use of Service
- You must be 18 years or older
- You are responsible for your account
- You must comply with all applicable laws

## Payment Terms
- All charges are final
- Refunds are subject to our refund policy

## Limitation of Liability
We are not liable for any indirect damages.

## Contact
For questions, contact us at support@example.com.
''';
  }

  @override
  Future<SupportTicketModel> submitSupportTicket({
    required String subject,
    required String message,
    List<String>? attachments,
  }) async {
    await Future.delayed(const Duration(seconds: 2));
    return SupportTicketModel(
      id: 'ticket_${DateTime.now().millisecondsSinceEpoch}',
      subject: subject,
      message: message,
      attachments: attachments ?? [],
      status: TicketStatus.open,
      createdAt: DateTime.now(),
      ticketNumber: 'TKT-${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  @override
  Future<List<SupportTicketModel>> getSupportTickets() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      SupportTicketModel(
        id: 'ticket_1',
        subject: 'Payment Issue',
        message: 'I was charged twice for my last session.',
        status: TicketStatus.inProgress,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        ticketNumber: 'TKT-123456',
      ),
    ];
  }

  @override
  Future<List<Map<String, String>>> getFAQ() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      {
        'question': 'How do I add a payment method?',
        'answer': 'Go to Profile > Payment Methods > Add Card and follow the instructions.',
      },
      {
        'question': 'How do I change my password?',
        'answer': 'Go to Profile > Security > Change Password and enter your current and new password.',
      },
      {
        'question': 'How do I contact support?',
        'answer': 'Go to Profile > Help & Support > Contact Us to submit a ticket.',
      },
    ];
  }

  @override
  Future<UserPreferencesModel> updatePreferences(UserPreferencesModel preferences) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return preferences;
  }
}

