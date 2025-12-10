/// File: lib/admin/features/partners/partners_bindings.dart
/// Purpose: Dependency injection bindings for partners feature
/// Belongs To: admin/features/partners
library;

import 'bloc/bloc.dart';
import 'repository/partners_local_mock.dart';
import 'repository/partners_repository.dart';

/// Bindings for partners feature.
class PartnersBindings {
  PartnersBindings._();

  static final PartnersBindings instance = PartnersBindings._();

  final PartnersRepository _repository = PartnersLocalMock();

  PartnersBloc partnersBloc() => PartnersBloc(repository: _repository);

  PartnerDetailBloc partnerDetailBloc() =>
      PartnerDetailBloc(repository: _repository);
}
