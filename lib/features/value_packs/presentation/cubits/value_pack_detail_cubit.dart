/// File: lib/features/value_packs/presentation/cubits/value_pack_detail_cubit.dart
/// Purpose: Cubit for managing value pack detail state
/// Belongs To: value_packs feature
library;

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_value_pack_detail.dart';
import '../../domain/usecases/get_value_packs.dart';
import 'value_pack_detail_state.dart';

/// Cubit for value pack detail screen.
class ValuePackDetailCubit extends Cubit<ValuePackDetailState> {
  ValuePackDetailCubit(
    this._getValuePackDetail,
    this._getValuePacks,
  ) : super(ValuePackDetailState.initial());

  final GetValuePackDetail _getValuePackDetail;
  final GetValuePacks _getValuePacks;

  /// Load value pack detail.
  Future<void> load(String id) async {
    emit(state.copyWith(
      status: ValuePackDetailStatus.loading,
    ));

    try {
      final pack = await _getValuePackDetail(id);

      if (pack == null) {
        emit(state.copyWith(
          status: ValuePackDetailStatus.error,
          error: 'Value pack not found',
        ));
        return;
      }

      // Load related packs
      final allPacks = await _getValuePacks();
      final relatedPacks = allPacks.where((p) => p.id != id).take(3).toList();

      emit(state.copyWith(
        status: ValuePackDetailStatus.loaded,
        pack: pack,
        relatedPacks: relatedPacks,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ValuePackDetailStatus.error,
        error: e.toString(),
      ));
    }
  }

  /// Toggle save status.
  Future<void> toggleSave() async {
    // TODO: Implement save/unsave logic
    emit(state.copyWith(isSaved: !state.isSaved));
  }

  /// Load related packs.
  Future<void> loadRelated() async {
    if (state.pack == null) {
      return;
    }

    try {
      final allPacks = await _getValuePacks();
      final relatedPacks = allPacks.where((p) => p.id != state.pack!.id).take(3).toList();

      emit(state.copyWith(relatedPacks: relatedPacks));
    } catch (e) {
      // Silently fail
    }
  }
}

