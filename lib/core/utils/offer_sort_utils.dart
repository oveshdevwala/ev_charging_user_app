/// File: lib/core/utils/offer_sort_utils.dart
/// Purpose: Sorting logic for offers
/// Belongs To: shared
library;

import '../../features/nearby_offers/data/datasources/partner_remote_datasource.dart';
import '../../features/nearby_offers/data/models/partner_offer_model.dart';

class OfferSortUtils {
  /// Sort offers based on the selected sort type.
  static List<PartnerOfferModel> sortOffers(
    List<PartnerOfferModel> offers,
    OfferSortType sortType,
  ) {
    final sorted = List<PartnerOfferModel>.from(offers);

    switch (sortType) {
      case OfferSortType.distance:
        sorted.sort(
          (a, b) => (a.distance ?? double.infinity).compareTo(
            b.distance ?? double.infinity,
          ),
        );
      case OfferSortType.discount:
        sorted.sort((a, b) {
          final discountA = a.discountPercent ?? 0;
          final discountB = b.discountPercent ?? 0;
          return discountB.compareTo(discountA); // Descending
        });
      case OfferSortType.trending:
        sorted.sort((a, b) => b.viewCount.compareTo(a.viewCount));
      case OfferSortType.newest:
        sorted.sort((a, b) {
          final dateA = a.validFrom ?? DateTime(2000);
          final dateB = b.validFrom ?? DateTime(2000);
          return dateB.compareTo(dateA);
        });
      case OfferSortType.expiringSoon:
        sorted.sort((a, b) {
          final dateA = a.validUntil ?? DateTime(2100);
          final dateB = b.validUntil ?? DateTime(2100);
          return dateA.compareTo(dateB);
        });
    }

    return sorted;
  }
}
