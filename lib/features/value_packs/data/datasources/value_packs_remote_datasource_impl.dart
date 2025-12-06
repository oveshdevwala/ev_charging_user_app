/// File: lib/features/value_packs/data/datasources/value_packs_remote_datasource_impl.dart
/// Purpose: Dummy implementation of remote data source with mock data
/// Belongs To: value_packs feature
/// Customization Guide:
///    - Replace with actual API calls when backend is ready
library;

import 'package:ev_charging_user_app/features/value_packs/domain/entities/purchase_receipt.dart';

import '../../domain/entities/value_pack.dart';
import '../models/models.dart';
import 'value_packs_remote_datasource.dart';

/// Dummy implementation of remote data source.
/// Returns mock data for development.
class ValuePacksRemoteDataSourceImpl implements ValuePacksRemoteDataSource {
  @override
  Future<List<ValuePackModel>> getValuePacks({
    String? filter,
    String? sort,
    int page = 1,
    int limit = 20,
  }) async {
    // Simulate network delay
    await Future<void>.delayed(const Duration(milliseconds: 500));

    // Mock data
    return _mockPacks;
  }

  @override
  Future<ValuePackModel> getValuePackDetail(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));

    return _mockPacks.firstWhere(
      (pack) => pack.id == id,
      orElse: () => _mockPacks.first,
    );
  }

  @override
  Future<List<ReviewModel>> getReviews(
    String packId, {
    int page = 1,
    int limit = 20,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));

    return _mockReviews;
  }

  @override
  Future<ReviewModel> submitReview({
    required String packId,
    required double rating,
    required String title,
    required String message,
    List<String>? images,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));

    return ReviewModel(
      id: 'review_${DateTime.now().millisecondsSinceEpoch}',
      userId: 'user_001',
      userName: 'You',
      rating: rating,
      title: title,
      message: message,
      images: images ?? [],
      createdAt: DateTime.now(),
    );
  }

  @override
  Future<PurchaseReceiptModel> purchaseValuePack({
    required String packId,
    required String paymentToken,
    String? coupon,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 1000));

    return PurchaseReceiptModel(
      id: 'receipt_${DateTime.now().millisecondsSinceEpoch}',
      packId: packId,
      userId: 'user_001',
      amount: _mockPacks
          .firstWhere((p) => p.id == packId, orElse: () => _mockPacks.first)
          .price,
      currency: 'USD',
      status: PurchaseStatus.completed,
      createdAt: DateTime.now(),
      invoiceUrl:
          'https://example.com/invoice/receipt_${DateTime.now().millisecondsSinceEpoch}',
      transactionId: 'txn_${DateTime.now().millisecondsSinceEpoch}',
      paymentMethod: 'card',
    );
  }

  @override
  Future<List<PurchaseReceiptModel>> getUserPurchases({String? packId}) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));

    return [];
  }

  @override
  Future<Map<String, dynamic>> comparePacks(List<String> packIds) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));

    return {
      'packs': packIds
          .map(
            (id) => _mockPacks
                .firstWhere((p) => p.id == id, orElse: () => _mockPacks.first)
                .toJson(),
          )
          .toList(),
      'summary': 'Comparison summary',
    };
  }

  @override
  Future<void> toggleSave(String packId) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
  }

  @override
  Future<List<ValuePackModel>> getSavedPacks() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));

    return [];
  }

  @override
  Future<List<Map<String, String>>> getFAQ() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));

    return [
      {
        'question': 'What is a value pack?',
        'answer':
            'Value packs are subscription bundles that offer discounted charging rates and additional benefits.',
      },
      {
        'question': 'How do I purchase a pack?',
        'answer':
            'Select a pack, choose your payment method, and complete the purchase.',
      },
      {
        'question': 'Can I cancel my subscription?',
        'answer':
            'Yes, you can cancel your subscription at any time from your account settings.',
      },
    ];
  }

  @override
  Future<String> getInvoiceUrl(String receiptId) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));

    return 'https://example.com/invoice/$receiptId';
  }

  // Mock data
  static final List<ValuePackModel> _mockPacks = [
    ValuePackModel(
      id: 'pack_001',
      title: 'Unlimited Charging',
      subtitle: 'Charge anywhere, anytime',
      description:
          'Get unlimited access to all charging stations in our network. No per-session fees, no hidden costs. Perfect for frequent drivers.',
      price: 99.99,
      priceCurrency: 'USD',
      oldPrice: 149.99,
      billingCycle: BillingCycle.monthly,
      features: const [
        'Unlimited charging sessions',
        'Priority access to stations',
        '24/7 customer support',
        'No per-session fees',
        'Access to premium stations',
      ],
      tags: const ['Popular', 'Best Value'],
      badge: 'Most Popular',
      iconUrl: 'https://images.unsplash.com/photo-1593941707882-a5bac6861d75?w=200&h=200&fit=crop',
      heroImageUrl: 'https://images.unsplash.com/photo-1593941707882-a5bac6861d75?w=800&h=400&fit=crop',
      savingsPercent: 33,
      rating: 4.8,
      reviewsCount: 245,
      benefits: const {
        'Priority Support': 'Get help faster',
        'Premium Stations': 'Access to exclusive locations',
      },
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      updatedAt: DateTime.now(),
    ),
    ValuePackModel(
      id: 'pack_002',
      title: 'Saver Pack',
      subtitle: '200 kWh included',
      description:
          'Perfect for occasional drivers. Includes 200 kWh of charging credit plus discounted rates on additional usage.',
      price: 49.99,
      priceCurrency: 'USD',
      oldPrice: 59.99,
      billingCycle: BillingCycle.monthly,
      features: const [
        '200 kWh included',
        '20% discount on additional kWh',
        'App benefits and rewards',
        'Flexible cancellation',
      ],
      tags: const ['Budget Friendly'],
      iconUrl: 'https://images.unsplash.com/photo-1605559424843-9e4c228bf1c2?w=200&h=200&fit=crop',
      heroImageUrl: 'https://images.unsplash.com/photo-1605559424843-9e4c228bf1c2?w=800&h=400&fit=crop',
      savingsPercent: 17,
      rating: 4.5,
      reviewsCount: 128,
      includedKwh: 200,
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
      updatedAt: DateTime.now(),
    ),
    ValuePackModel(
      id: 'pack_003',
      title: 'Home Charging Bundle',
      subtitle: 'Complete home setup',
      description:
          'Everything you need for home charging: installation, smart scheduling, and energy tracking. One-time purchase.',
      price: 299,
      priceCurrency: 'USD',
      features: const [
        'Home charger installation',
        'Smart scheduling features',
        'Energy usage tracking',
        'Lifetime warranty',
        'Professional installation',
      ],
      tags: const ['Best Value', 'One-Time'],
      badge: 'Best Value',
      iconUrl: 'https://images.unsplash.com/photo-1607472586893-edb57bdc0e39?w=200&h=200&fit=crop',
      heroImageUrl: 'https://images.unsplash.com/photo-1607472586893-edb57bdc0e39?w=800&h=400&fit=crop',
      rating: 4.9,
      reviewsCount: 89,
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
      updatedAt: DateTime.now(),
    ),
    ValuePackModel(
      id: 'pack_004',
      title: 'Business Fleet',
      subtitle: 'Fleet management solution',
      description:
          'Designed for businesses with multiple vehicles. Includes fleet management dashboard, bulk discounts, and analytics.',
      price: 199.99,
      priceCurrency: 'USD',
      billingCycle: BillingCycle.monthly,
      features: const [
        'Fleet management dashboard',
        'Bulk charging discounts',
        'Analytics and reporting',
        'Dedicated account manager',
        'Custom billing options',
      ],
      tags: const ['Business'],
      iconUrl: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=200&h=200&fit=crop',
      heroImageUrl: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800&h=400&fit=crop',
      rating: 4.7,
      reviewsCount: 56,
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      updatedAt: DateTime.now(),
    ),
    ValuePackModel(
      id: 'pack_005',
      title: 'Starter Pack',
      subtitle: 'Perfect for beginners',
      description:
          'Great for new EV owners. Includes 50 kWh credit and access to all basic features.',
      price: 24.99,
      priceCurrency: 'USD',
      features: const [
        '50 kWh included',
        'Access to all stations',
        'Mobile app access',
        'Basic support',
      ],
      tags: const ['Starter'],
      iconUrl: 'https://images.unsplash.com/photo-1601581875036-9e7e0e8aee7b?w=200&h=200&fit=crop',
      heroImageUrl: 'https://images.unsplash.com/photo-1601581875036-9e7e0e8aee7b?w=800&h=400&fit=crop',
      rating: 4.3,
      reviewsCount: 312,
      includedKwh: 50,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      updatedAt: DateTime.now(),
    ),
  ];

  static final List<ReviewModel> _mockReviews = [
    ReviewModel(
      id: 'review_001',
      userId: 'user_001',
      userName: 'John Doe',
      rating: 5,
      title: 'Excellent value!',
      message: 'This pack has saved me so much money. Highly recommended!',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    ReviewModel(
      id: 'review_002',
      userId: 'user_002',
      userName: 'Jane Smith',
      rating: 4.5,
      title: 'Great service',
      message:
          'The unlimited pack is perfect for my daily commute. No issues so far.',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    ReviewModel(
      id: 'review_003',
      userId: 'user_003',
      userName: 'Mike Johnson',
      rating: 4,
      title: 'Good but could be better',
      message:
          'Works well, but I wish there were more premium stations included.',
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
    ),
  ];
}
