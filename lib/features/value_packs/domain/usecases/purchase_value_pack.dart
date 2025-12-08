/// File: lib/features/value_packs/domain/usecases/purchase_value_pack.dart
/// Purpose: Use case for purchasing a value pack
/// Belongs To: value_packs feature
library;

import '../entities/purchase_receipt.dart';
import '../repositories/value_packs_repository.dart';

/// Use case for purchasing a value pack.
class PurchaseValuePack {
  PurchaseValuePack(this._repository);

  final ValuePacksRepository _repository;

  /// Execute the use case.
  Future<PurchaseReceipt> call({
    required String packId,
    required String paymentToken,
    String? coupon,
  }) async {
    return _repository.purchaseValuePack(
      packId: packId,
      paymentToken: paymentToken,
      coupon: coupon,
    );
  }
}

