/// File: lib/admin/features/partners/bloc/partner_detail_state.dart
/// Purpose: State definitions for partner detail BLoC
/// Belongs To: admin/features/partners
library;

import 'package:equatable/equatable.dart';

import '../models/models.dart';

/// Lifecycle status for partner detail.
enum PartnerDetailStatus { initial, loading, loaded, processing, error }

/// State for [PartnerDetailBloc].
class PartnerDetailState extends Equatable {
  const PartnerDetailState({
    this.status = PartnerDetailStatus.initial,
    this.partner,
    this.contracts = const [],
    this.locations = const [],
    this.auditLogs = const [],
    this.isApproving = false,
    this.isRejecting = false,
    this.isSuspending = false,
    this.isActivating = false,
    this.isAddingContract = false,
    this.isUpdatingLocation = false,
    this.error,
    this.successMessage,
  });

  final PartnerDetailStatus status;
  final PartnerModel? partner;
  final List<PartnerContractModel> contracts;
  final List<PartnerLocationModel> locations;
  final List<PartnerAuditModel> auditLogs;
  final bool isApproving;
  final bool isRejecting;
  final bool isSuspending;
  final bool isActivating;
  final bool isAddingContract;
  final bool isUpdatingLocation;
  final String? error;
  final String? successMessage;

  bool get isLoading => status == PartnerDetailStatus.loading;
  bool get isProcessing => status == PartnerDetailStatus.processing;

  PartnerDetailState copyWith({
    PartnerDetailStatus? status,
    PartnerModel? partner,
    List<PartnerContractModel>? contracts,
    List<PartnerLocationModel>? locations,
    List<PartnerAuditModel>? auditLogs,
    bool? isApproving,
    bool? isRejecting,
    bool? isSuspending,
    bool? isActivating,
    bool? isAddingContract,
    bool? isUpdatingLocation,
    String? error,
    String? successMessage,
  }) {
    return PartnerDetailState(
      status: status ?? this.status,
      partner: partner ?? this.partner,
      contracts: contracts ?? this.contracts,
      locations: locations ?? this.locations,
      auditLogs: auditLogs ?? this.auditLogs,
      isApproving: isApproving ?? this.isApproving,
      isRejecting: isRejecting ?? this.isRejecting,
      isSuspending: isSuspending ?? this.isSuspending,
      isActivating: isActivating ?? this.isActivating,
      isAddingContract: isAddingContract ?? this.isAddingContract,
      isUpdatingLocation: isUpdatingLocation ?? this.isUpdatingLocation,
      error: error,
      successMessage: successMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        partner,
        contracts,
        locations,
        auditLogs,
        isApproving,
        isRejecting,
        isSuspending,
        isActivating,
        isAddingContract,
        isUpdatingLocation,
        error,
        successMessage,
      ];
}
