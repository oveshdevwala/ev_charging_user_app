/// File: lib/features/value_packs/domain/usecases/get_value_pack_detail.dart
/// Purpose: Use case for fetching value pack details
/// Belongs To: value_packs feature
library;

import '../entities/value_pack.dart';
import '../repositories/value_packs_repository.dart';

/// Use case for getting value pack detail.
class GetValuePackDetail {
  GetValuePackDetail(this._repository);

  final ValuePacksRepository _repository;

  /// Execute the use case.
  Future<ValuePack?> call(String id) async {
    return _repository.getValuePackDetail(id);
  }
}

