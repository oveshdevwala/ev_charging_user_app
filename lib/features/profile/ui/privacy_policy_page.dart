/// File: lib/features/profile/ui/privacy_policy_page.dart
/// Purpose: Privacy policy screen
/// Belongs To: profile feature
/// Route: /privacyPolicy
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/di/injection.dart';
import '../../../core/extensions/context_ext.dart';
import '../bloc/bloc.dart';
import '../repositories/repositories.dart';

/// Privacy policy page.
class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SupportBloc(
        repository: sl<ProfileRepository>(),
      )..add(const LoadPrivacyPolicy()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Privacy Policy'),
        ),
        body: BlocBuilder<SupportBloc, SupportState>(
          builder: (context, state) {
            if (state.isLoadingPolicy) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.privacyPolicy == null) {
              final colors = context.appColors;
              return Center(
                child: Text(
                  'Privacy policy not available',
                  style: TextStyle(fontSize: 14.sp, color: colors.textSecondary),
                ),
              );
            }

            final colors = context.appColors;
            return Markdown(
              data: state.privacyPolicy!,
              padding: EdgeInsets.all(20.r),
              styleSheet: MarkdownStyleSheet(
                p: TextStyle(fontSize: 14.sp, color: colors.textPrimary),
                h1: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w700, color: colors.textPrimary),
                h2: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600, color: colors.textPrimary),
                h3: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600, color: colors.textPrimary),
              ),
            );
          },
        ),
      ),
    );
  }
}

