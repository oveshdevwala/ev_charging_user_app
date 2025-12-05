/// File: lib/features/profile/ui/contact_us_page.dart
/// Purpose: Contact us screen
/// Belongs To: profile feature
/// Route: /contactUs
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/di/injection.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/validators.dart';
import '../../../widgets/common_button.dart';
import '../../../widgets/common_text_field.dart';
import '../bloc/bloc.dart';
import '../repositories/repositories.dart';

/// Contact us page.
class ContactUsPage extends StatefulWidget {
  const ContactUsPage({super.key});

  @override
  State<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SupportBloc(
        repository: sl<ProfileRepository>(),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Contact Us'),
        ),
        body: BlocListener<SupportBloc, SupportState>(
          listener: (context, state) {
            if (state.submittedTicket != null) {
              showDialog<void>(
                context: context,
                builder: (dialogContext) => BlocProvider.value(
                  value: context.read<SupportBloc>(),
                  child: AlertDialog(
                    title: const Text('Ticket Submitted'),
                    content: Text(
                      'Your ticket has been submitted successfully.\n\nTicket ID: ${state.submittedTicket!.ticketNumber ?? state.submittedTicket!.id}',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(dialogContext);
                          context.pop();
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                ),
              );
            }
            if (state.error != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error!)),
              );
            }
          },
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20.r),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'We\'re here to help! Send us a message and we\'ll get back to you as soon as possible.',
                    style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondaryLight),
                  ),
                  SizedBox(height: 24.h),
                  CommonTextField(
                    controller: _subjectController,
                    label: 'Subject',
                    hint: 'Enter subject',
                    validator: Validators.required,
                  ),
                  SizedBox(height: 16.h),
                  CommonTextField(
                    controller: _messageController,
                    label: 'Message',
                    hint: 'Describe your issue or question...',
                    maxLines: 6,
                    validator: Validators.required,
                  ),
                  SizedBox(height: 32.h),
                  BlocBuilder<SupportBloc, SupportState>(
                    builder: (context, state) {
                      return CommonButton(
                        label: 'Submit',
                        onPressed: state.isSubmitting
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<SupportBloc>().add(
                                        SubmitTicket(
                                          subject: _subjectController.text,
                                          message: _messageController.text,
                                        ),
                                      );
                                }
                              },
                        isLoading: state.isSubmitting,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

