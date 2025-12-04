/// File: lib/features/stations/ui/booking_page.dart
/// Purpose: Booking creation screen
/// Belongs To: stations feature
/// Route: /booking/:stationId
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../models/models.dart';
import '../../../repositories/station_repository.dart';
import '../../../widgets/common_button.dart';
import '../../../widgets/app_app_bar.dart';
import '../widgets/booking_station_info.dart';
import '../widgets/booking_charger_selection.dart';
import '../widgets/booking_date_time_selection.dart';
import '../widgets/booking_duration_selection.dart';
import '../widgets/booking_summary.dart';

/// Booking page for creating charging reservations.
class BookingPage extends StatefulWidget {
  const BookingPage({super.key, required this.stationId});

  final String stationId;

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final _stationRepository = DummyStationRepository();
  StationModel? _station;
  ChargerModel? _selectedCharger;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  int _duration = 60;

  @override
  void initState() {
    super.initState();
    _loadStation();
  }

  Future<void> _loadStation() async {
    final station = await _stationRepository.getStationById(widget.stationId);
    if (mounted) {
      setState(() {
        _station = station;
        _selectedCharger = station?.chargers.firstWhere(
          (c) => c.isAvailable,
          orElse: () => station!.chargers.first,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(title: 'Book Charger'),
      body: _station == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(20.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BookingStationInfo(station: _station!),
                  SizedBox(height: 24.h),
                  BookingChargerSelection(
                    chargers: _station!.chargers,
                    selectedCharger: _selectedCharger,
                    onSelected: (charger) => setState(() => _selectedCharger = charger),
                  ),
                  SizedBox(height: 24.h),
                  BookingDateTimeSelection(
                    selectedDate: _selectedDate,
                    selectedTime: _selectedTime,
                    onDateChanged: (date) => setState(() => _selectedDate = date),
                    onTimeChanged: (time) => setState(() => _selectedTime = time),
                  ),
                  SizedBox(height: 24.h),
                  BookingDurationSelection(
                    selectedDuration: _duration,
                    onDurationChanged: (d) => setState(() => _duration = d),
                  ),
                  SizedBox(height: 24.h),
                  BookingSummary(
                    chargerName: _selectedCharger?.name ?? '-',
                    duration: _duration,
                    pricePerKwh: _station?.pricePerKwh ?? 0,
                  ),
                  SizedBox(height: 32.h),
                  CommonButton(label: AppStrings.bookNow, onPressed: _onBookPressed),
                ],
              ),
            ),
    );
  }

  void _onBookPressed() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppStrings.bookingSuccessful),
        content: const Text('Your charging session has been booked!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

