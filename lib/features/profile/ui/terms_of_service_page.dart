/// File: lib/features/profile/ui/terms_of_service_page.dart
/// Purpose: Terms of service screen
/// Belongs To: profile feature
/// Route: /termsOfService
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/di/injection.dart';
import '../../../core/extensions/context_ext.dart';
import '../bloc/bloc.dart';
import '../repositories/repositories.dart';

/// Terms of service page.
class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SupportBloc(
        repository: sl<ProfileRepository>(),
      )..add(const LoadTermsOfService()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Terms of Service'),
        ),
        body: BlocBuilder<SupportBloc, SupportState>(
          builder: (context, state) {
            if (state.isLoadingTerms) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.termsOfService == null) {
              final colors = context.appColors;
              return Center(
                child: Text(
                  'Terms of service not available',
                  style: TextStyle(fontSize: 14.sp, color: colors.textSecondary),
                ),
              );
            }

            final colors = context.appColors;
            return Markdown(
              data: state.termsOfService!,
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

