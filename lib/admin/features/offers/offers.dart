/// File: lib/admin/features/offers/offers.dart
/// Purpose: Barrel exports for offers management feature
/// Belongs To: admin/features/offers
/// Customization Guide:
/// - Extend exports as the offers module grows
/// - Keep public API surface minimal for consumers
library;

export 'bloc/offer_detail_bloc.dart';
export 'bloc/offers_bloc.dart';
export 'models/offer_model.dart';
export 'offers_bindings.dart';
export 'repository/offers_local_mock.dart';
export 'repository/offers_remote_data_source.dart';
export 'repository/offers_repository.dart';
export 'views/offer_detail_page.dart';
export 'views/offers_list_page.dart';
export 'views/widgets/offer_actions_bar.dart';
// export 'views/widgets/offer_filters.dart';
export 'views/widgets/offers_table.dart';
