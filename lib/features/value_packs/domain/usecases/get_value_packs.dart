/// File: lib/features/value_packs/domain/usecases/get_value_packs.dart
/// Purpose: Use case for fetching value packs list
/// Belongs To: value_packs feature
/// Customization Guide:
///    - Add filtering/sorting logic as needed
library;

import '../entities/value_pack.dart';
import '../repositories/value_packs_repository.dart';

/// Use case for getting value packs list.
class GetValuePacks {
  GetValuePacks(this._repository);

  final ValuePacksRepository _repository;

  /// Execute the use case.
  Future<List<ValuePack>> call({
    String? filter,
    String? sort,
    int page = 1,
    int limit = 20,
  }) async {
    return await _repository.getValuePacks(
      filter: filter,
      sort: sort,
      page: page,
      limit: limit,
    );
  }
}

