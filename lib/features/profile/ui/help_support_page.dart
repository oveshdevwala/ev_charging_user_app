/// File: lib/features/profile/ui/help_support_page.dart
/// Purpose: Help and support screen
/// Belongs To: profile feature
/// Route: /helpSupport
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/di/injection.dart';
import '../../../core/theme/app_colors.dart';
import '../../../routes/app_routes.dart';
import '../bloc/bloc.dart';
import '../repositories/repositories.dart';

/// Help and support page.
class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SupportBloc(
            repository: sl<ProfileRepository>(),
          )..add(const LoadFAQ()),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Help & Support'),
        ),
        body: BlocBuilder<SupportBloc, SupportState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(20.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildContactCard(context),
                  SizedBox(height: 24.h),
                  Text(
                    'Frequently Asked Questions',
                    style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 16.h),
                  if (state.isLoadingFAQ)
                    const Center(child: CircularProgressIndicator())
                  else if (state.faq.isEmpty)
                    Text(
                      'No FAQs available',
                      style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondaryLight),
                    )
                  else
                    ...state.faq.map((faq) => _buildFAQCard(context, faq)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildContactCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(Iconsax.message_question, size: 24.r, color: AppColors.primary),
                SizedBox(width: 12.w),
                Text(
                  'Need Help?',
                  style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Text(
              'Can\'t find what you\'re looking for? Contact our support team.',
              style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondaryLight),
            ),
            SizedBox(height: 16.h),
            ElevatedButton.icon(
              onPressed: () => context.push(AppRoutes.contactUs.path),
              icon: Icon(Iconsax.message, size: 20.r),
              label: const Text('Contact Us'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQCard(BuildContext context, Map<String, String> faq) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      child: ExpansionTile(
        title: Text(
          faq['question'] ?? '',
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
        ),
        children: [
          Padding(
            padding: EdgeInsets.all(16.r),
            child: Text(
              faq['answer'] ?? '',
              style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondaryLight),
            ),
          ),
        ],
      ),
    );
  }
}

