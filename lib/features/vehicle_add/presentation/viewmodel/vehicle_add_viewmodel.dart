/// File: lib/features/vehicle_add/presentation/viewmodel/vehicle_add_viewmodel.dart
/// Purpose: ViewModel for vehicle add/edit form
/// Belongs To: vehicle_add feature
/// Customization Guide:
///    - Add computed properties as needed
///    - Add formatting helpers
library;

import '../../domain/entities/entities.dart';
import '../bloc/bloc.dart';

/// ViewModel for vehicle add/edit form.
class VehicleAddViewModel {
  VehicleAddViewModel(this.form);

  final VehicleForm form;

  /// Get display name for vehicle type.
  String getVehicleTypeLabel(VehicleType type) {
    switch (type) {
      case VehicleType.BEV:
        return 'BEV (Battery Electric)';
      case VehicleType.PHEV:
        return 'PHEV (Plug-in Hybrid)';
      case VehicleType.HEV:
        return 'HEV (Hybrid)';
    }
  }

  /// Get vehicle type options for dropdown.
  List<VehicleType> get vehicleTypeOptions => VehicleType.values;

  /// Get year options (1990 to current year + 1).
  List<int> get yearOptions {
    final currentYear = DateTime.now().year;
    return List.generate(
      currentYear + 2 - 1990,
      (index) => 1990 + index,
    ).reversed.toList();
  }

  /// Get popular vehicle makes (for autocomplete).
  List<String> get popularMakes => const [
        'Tesla',
        'Chevrolet',
        'Nissan',
        'BMW',
        'Audi',
        'Mercedes-Benz',
        'Hyundai',
        'Kia',
        'Ford',
        'Toyota',
        'Honda',
        'Volkswagen',
        'Porsche',
        'Jaguar',
        'Volvo',
      ];

  /// Get models for a make (simplified - in real app, use API).
  List<String> getModelsForMake(String make) {
    // Simplified mapping - in production, fetch from API
    final makeModels = <String, List<String>>{
      'Tesla': ['Model S', 'Model 3', 'Model X', 'Model Y', 'Cybertruck'],
      'Chevrolet': ['Bolt EV', 'Bolt EUV'],
      'Nissan': ['Leaf', 'Ariya'],
      'BMW': ['i3', 'i4', 'iX', 'iX3'],
      'Audi': ['e-tron', 'e-tron GT', 'Q4 e-tron'],
      'Mercedes-Benz': ['EQC', 'EQS', 'EQE'],
      'Hyundai': ['Ioniq 5', 'Ioniq 6', 'Kona Electric'],
      'Kia': ['EV6', 'Niro EV'],
      'Ford': ['Mustang Mach-E', 'F-150 Lightning'],
      'Toyota': ['Prius Prime', 'bZ4X', 'RAV4 Prime'],
      'Honda': ['Clarity', 'Civic Hybrid'],
      'Volkswagen': ['ID.4', 'ID.3'],
      'Porsche': ['Taycan'],
      'Jaguar': ['I-PACE'],
      'Volvo': ['XC40 Recharge', 'C40'],
    };

    return makeModels[make] ?? [];
  }

  /// Format license plate (uppercase, remove spaces).
  String formatLicensePlate(String value) {
    return value.trim().toUpperCase().replaceAll(' ', '');
  }

  /// Estimate range based on battery capacity (simplified).
  double? estimateRange() {
    if (form.batteryCapacityKWh == null) return null;
    // Rough estimate: 4-5 miles per kWh for BEV, less for hybrids
    final efficiency = form.vehicleType == VehicleType.BEV ? 4.5 : 3.0;
    return form.batteryCapacityKWh! * efficiency;
  }

  /// Check if form is valid.
  bool isFormValid() {
    return form.make.isNotEmpty &&
        form.model.isNotEmpty &&
        form.year != null &&
        form.batteryCapacityKWh != null &&
        form.batteryCapacityKWh! > 0;
  }

  /// Convert form to DTO for BLoC.
  Map<String, dynamic> toDto() {
    return {
      'nickName': form.nickName,
      'make': form.make,
      'model': form.model,
      'year': form.year,
      'batteryCapacityKWh': form.batteryCapacityKWh,
      'vehicleType': form.vehicleType,
      'licensePlate': form.licensePlate,
      'isDefault': form.isDefault,
      'imageFile': form.imageFile,
      'imageUrl': form.imageUrl,
      'vehicleId': form.vehicleId,
    };
  }
}

