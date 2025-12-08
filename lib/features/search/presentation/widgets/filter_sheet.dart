/// File: lib/features/search/presentation/widgets/filter_sheet.dart
/// Purpose: Filter sheet for advanced station filtering
/// Belongs To: search feature
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/extensions/context_ext.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../models/models.dart';
import '../../../../widgets/common_button.dart';
import '../../domain/station_usecases.dart';
import '../bloc/filter_cubit.dart';
import '../bloc/search_bloc.dart';
import '../bloc/search_event.dart';

/// Filter sheet widget for station filtering.
class FilterSheet extends StatefulWidget {
  const FilterSheet({super.key});

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  List<ChargerType> _selectedConnectors = [];
  List<Amenity> _selectedAmenities = [];
  double? _minPrice;
  double? _maxPrice;
  double? _minPower;
  double? _maxPower;
  bool _availableOnly = false;
  double? _minRating;
  double? _maxDistance;
  bool _initialized = false;

  void _initializeFilters(StationFilters filters) {
    if (!_initialized) {
      _selectedConnectors = List.from(filters.connectorTypes);
      _selectedAmenities = List.from(filters.amenities);
      _minPrice = filters.minPrice;
      _maxPrice = filters.maxPrice;
      _minPower = filters.minPower;
      _maxPower = filters.maxPower;
      _availableOnly = filters.availableOnly;
      _minRating = filters.minRating;
      _maxDistance = filters.maxDistance;
      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilterCubit, StationFilters>(
      builder: (context, filters) {
        _initializeFilters(filters);
        final colors = context.appColors;
        return DecoratedBox(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Container(
                margin: EdgeInsets.only(top: 12.h),
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: colors.outline,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              // Header
              Padding(
                padding: EdgeInsets.all(16.r),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppStrings.filter,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: colors.textPrimary,
                      ),
                    ),
                    TextButton(
                      onPressed: _clearFilters,
                      child: Text(
                        'Clear All',
                        style: TextStyle(color: colors.primary),
                      ),
                    ),
                  ],
                ),
              ),
              // Content
              Flexible(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Connector types
                      _buildSectionTitle('Connector Types'),
                      SizedBox(height: 8.h),
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: ChargerType.values.map((type) {
                          final isSelected = _selectedConnectors.contains(type);
                          return FilterChip(
                            label: Text(_getConnectorTypeName(type)),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  _selectedConnectors.add(type);
                                } else {
                                  _selectedConnectors.remove(type);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 24.h),
                      // Price range
                      _buildSectionTitle(r'Price Range ($/kWh)'),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                labelText: 'Min',
                                hintText: '0.00',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ),
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              onChanged: (value) {
                                _minPrice = double.tryParse(value);
                              },
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                labelText: 'Max',
                                hintText: '1.00',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ),
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              onChanged: (value) {
                                _maxPrice = double.tryParse(value);
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),
                      // Power range
                      _buildSectionTitle('Power Range (kW)'),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                labelText: 'Min',
                                hintText: '0',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                _minPower = double.tryParse(value);
                              },
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                labelText: 'Max',
                                hintText: '350',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                _maxPower = double.tryParse(value);
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),
                      // Available only
                      SwitchListTile(
                        title: const Text('Available Now Only'),
                        value: _availableOnly,
                        onChanged: (value) {
                          setState(() {
                            _availableOnly = value;
                          });
                        },
                      ),
                      SizedBox(height: 16.h),
                      // Amenities
                      _buildSectionTitle('Amenities'),
                      SizedBox(height: 8.h),
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: Amenity.values.map((amenity) {
                          final isSelected = _selectedAmenities.contains(
                            amenity,
                          );
                          return FilterChip(
                            label: Text(_getAmenityName(amenity)),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  _selectedAmenities.add(amenity);
                                } else {
                                  _selectedAmenities.remove(amenity);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 24.h),
                      // Rating
                      _buildSectionTitle('Minimum Rating'),
                      SizedBox(height: 8.h),
                      Slider(
                        value: _minRating ?? 0.0,
                        max: 5,
                        divisions: 10,
                        label: _minRating?.toStringAsFixed(1) ?? '0.0',
                        onChanged: (value) {
                          setState(() {
                            _minRating = value;
                          });
                        },
                      ),
                      SizedBox(height: 24.h),
                      // Max distance
                      _buildSectionTitle('Max Distance (km)'),
                      SizedBox(height: 8.h),
                      Slider(
                        value: _maxDistance ?? 50.0,
                        min: 1,
                        max: 100,
                        divisions: 99,
                        label: _maxDistance?.toStringAsFixed(0) ?? '50',
                        onChanged: (value) {
                          setState(() {
                            _maxDistance = value;
                          });
                        },
                      ),
                      SizedBox(height: 32.h),
                    ],
                  ),
                ),
              ),
              // Apply button
              Padding(
                padding: EdgeInsets.all(16.r),
                child: CommonButton(
                  label: AppStrings.apply,
                  onPressed: _applyFilters,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: context.appColors.textPrimary,
      ),
    );
  }

  String _getConnectorTypeName(ChargerType type) {
    switch (type) {
      case ChargerType.type1:
        return 'Type 1';
      case ChargerType.type2:
        return 'Type 2';
      case ChargerType.ccs:
        return 'CCS';
      case ChargerType.chademo:
        return 'CHAdeMO';
      case ChargerType.tesla:
        return 'Tesla';
      case ChargerType.gb:
        return 'GB/T';
    }
  }

  String _getAmenityName(Amenity amenity) {
    switch (amenity) {
      case Amenity.wifi:
        return 'WiFi';
      case Amenity.restroom:
        return 'Restroom';
      case Amenity.cafe:
        return 'Cafe';
      case Amenity.restaurant:
        return 'Restaurant';
      case Amenity.parking:
        return 'Parking';
      case Amenity.shopping:
        return 'Shopping';
      case Amenity.lounge:
        return 'Lounge';
      case Amenity.playground:
        return 'Playground';
    }
  }

  void _applyFilters() {
    final filters = StationFilters(
      connectorTypes: _selectedConnectors,
      minPrice: _minPrice,
      maxPrice: _maxPrice,
      minPower: _minPower,
      maxPower: _maxPower,
      availableOnly: _availableOnly,
      amenities: _selectedAmenities,
      minRating: _minRating,
      maxDistance: _maxDistance,
    );

    context.read<FilterCubit>().updateConnectorTypes(_selectedConnectors);
    context.read<FilterCubit>().updatePriceRange(_minPrice, _maxPrice);
    context.read<FilterCubit>().updatePowerRange(_minPower, _maxPower);
    if (_availableOnly != context.read<FilterCubit>().state.availableOnly) {
      context.read<FilterCubit>().toggleAvailableOnly();
    }
    context.read<FilterCubit>().updateAmenities(_selectedAmenities);
    context.read<FilterCubit>().updateMinRating(_minRating);
    context.read<FilterCubit>().updateMaxDistance(_maxDistance);
    context.read<FilterCubit>().applyFilters();

    // Apply filters to search bloc
    context.read<SearchBloc>().add(FiltersApplied(filters));

    Navigator.pop(context);
  }

  void _clearFilters() {
    setState(() {
      _selectedConnectors.clear();
      _selectedAmenities.clear();
      _minPrice = null;
      _maxPrice = null;
      _minPower = null;
      _maxPower = null;
      _availableOnly = false;
      _minRating = null;
      _maxDistance = null;
    });
    context.read<FilterCubit>().clearFilters();
  }
}
