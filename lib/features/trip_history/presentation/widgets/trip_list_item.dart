import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../core/extensions/context_ext.dart';
import '../../domain/entities/trip_record.dart';

class TripListItem extends StatelessWidget {

  const TripListItem({required this.trip, super.key});
  final TripRecord trip;

  @override
  Widget build(BuildContext context) {
    final duration = trip.endTime.difference(trip.startTime);
    final durationString = '${duration.inHours}h ${duration.inMinutes % 60}m';
    final dateString = DateFormat('MMM dd, yyyy').format(trip.startTime);

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: context.appColors.textPrimary.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              Icons.electric_car,
              color: Theme.of(context).primaryColor,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  trip.stationName,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 12.sp,
                      color: context.appColors.textTertiary,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      dateString,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(
                            color: context.appColors.textTertiary,
                          ),
                    ),
                    SizedBox(width: 8.w),
                    Icon(
                      Icons.access_time,
                      size: 12.sp,
                      color: context.appColors.textTertiary,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      durationString,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(
                            color: context.appColors.textTertiary,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹${trip.cost.toStringAsFixed(2)}',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4.h),
              Text(
                '${trip.energyConsumedKWh} kWh',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(
                      color: context.appColors.textTertiary,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
