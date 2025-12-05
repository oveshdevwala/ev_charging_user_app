/// File: lib/features/profile/ui/add_card_page.dart
/// Purpose: Add payment card screen
/// Belongs To: profile feature
/// Route: /addCard
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/di/injection.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/validators.dart';
import '../../../widgets/common_button.dart';
import '../../../widgets/common_text_field.dart';
import '../bloc/bloc.dart';
import '../repositories/repositories.dart';

/// Add card page for adding new payment methods.
class AddCardPage extends StatefulWidget {
  const AddCardPage({super.key});

  @override
  State<AddCardPage> createState() => _AddCardPageState();
}

class _AddCardPageState extends State<AddCardPage> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _cardholderNameController = TextEditingController();
  final _expiryMonthController = TextEditingController();
  final _expiryYearController = TextEditingController();
  final _cvvController = TextEditingController();
  final _billingZipController = TextEditingController();

  String _selectedBrand = 'Visa';
  bool _setAsDefault = false;

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardholderNameController.dispose();
    _expiryMonthController.dispose();
    _expiryYearController.dispose();
    _cvvController.dispose();
    _billingZipController.dispose();
    super.dispose();
  }

  String _detectCardBrand(String cardNumber) {
    final cleaned = cardNumber.replaceAll(RegExp(r'\D'), '');
    if (cleaned.isEmpty) return 'Visa';

    if (cleaned.startsWith('4')) return 'Visa';
    if (cleaned.startsWith('5') || cleaned.startsWith('2')) return 'Mastercard';
    if (cleaned.startsWith('3')) return 'American Express';
    if (cleaned.startsWith('6')) return 'Discover';

    return 'Visa';
  }

  String _formatCardNumber(String value) {
    final cleaned = value.replaceAll(RegExp(r'\D'), '');
    final buffer = StringBuffer();
    for (int i = 0; i < cleaned.length; i++) {
      if (i > 0 && i % 4 == 0) {
        buffer.write(' ');
      }
      buffer.write(cleaned[i]);
    }
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PaymentBloc(
        repository: sl<ProfileRepository>(),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Payment Method'),
        ),
        body: BlocConsumer<PaymentBloc, PaymentState>(
          listener: (context, state) {
            if (state.error != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error!)),
              );
            }
            // Card added successfully
            if (!state.isAdding && state.paymentMethods.isNotEmpty) {
              // Set as default if requested
              if (_setAsDefault) {
                final newCard = state.paymentMethods.last;
                context.read<PaymentBloc>().add(SetDefaultPaymentMethod(newCard.id));
              }
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Card added successfully')),
              );
              context.pop();
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
            padding: EdgeInsets.all(20.r),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Card Preview
                  _buildCardPreview(),
                  SizedBox(height: 32.h),

                  // Card Number
                  CommonTextField(
                    controller: _cardNumberController,
                    label: 'Card Number',
                    hint: '1234 5678 9012 3456',
                    keyboardType: TextInputType.number,
                    maxLength: 19,
                    prefixIcon: Iconsax.card,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Card number is required';
                      }
                      final cleaned = value.replaceAll(RegExp(r'\D'), '');
                      if (cleaned.length < 13 || cleaned.length > 19) {
                        return 'Invalid card number';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      final formatted = _formatCardNumber(value);
                      if (formatted != value) {
                        _cardNumberController.value = TextEditingValue(
                          text: formatted,
                          selection: TextSelection.collapsed(
                            offset: formatted.length,
                          ),
                        );
                      }
                      setState(() {
                        _selectedBrand = _detectCardBrand(value);
                      });
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                  SizedBox(height: 16.h),

                  // Cardholder Name
                  CommonTextField(
                    controller: _cardholderNameController,
                    label: 'Cardholder Name',
                    hint: 'John Doe',
                    textCapitalization: TextCapitalization.words,
                    validator: Validators.required,
                  ),
                  SizedBox(height: 16.h),

                  // Expiry Date Row
                  Row(
                    children: [
                      Expanded(
                        child: CommonTextField(
                          controller: _expiryMonthController,
                          label: 'Month',
                          hint: 'MM',
                          keyboardType: TextInputType.number,
                          maxLength: 2,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            final month = int.tryParse(value);
                            if (month == null || month < 1 || month > 12) {
                              return 'Invalid';
                            }
                            return null;
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: CommonTextField(
                          controller: _expiryYearController,
                          label: 'Year',
                          hint: 'YYYY',
                          keyboardType: TextInputType.number,
                          maxLength: 4,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            final year = int.tryParse(value);
                            if (year == null || year < DateTime.now().year) {
                              return 'Invalid';
                            }
                            return null;
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),

                  // CVV
                  CommonTextField(
                    controller: _cvvController,
                    label: 'CVV',
                    hint: '123',
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    maxLength: 4,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'CVV is required';
                      }
                      if (value.length < 3) {
                        return 'Invalid CVV';
                      }
                      return null;
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                  SizedBox(height: 16.h),

                  // Billing ZIP (Optional)
                  CommonTextField(
                    controller: _billingZipController,
                    label: 'Billing ZIP Code (Optional)',
                    hint: '12345',
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                  SizedBox(height: 24.h),

                  // Set as Default
                  Row(
                    children: [
                      Checkbox(
                        value: _setAsDefault,
                        onChanged: (value) {
                          setState(() {
                            _setAsDefault = value ?? false;
                          });
                        },
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          'Set as default payment method',
                          style: TextStyle(fontSize: 14.sp),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 32.h),

                  // Add Card Button
                  CommonButton(
                    label: 'Add Card',
                    onPressed: state.isAdding
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              _addCard(context);
                            }
                          },
                    isLoading: state.isAdding,
                    icon: Iconsax.add,
                  ),
                ],
              ),
            ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCardPreview() {
    return Container(
      height: 200.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.primary.withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      padding: EdgeInsets.all(20.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Iconsax.card, size: 32.r, color: Colors.white),
              Text(
                _selectedBrand,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _cardNumberController.text.isEmpty
                    ? '•••• •••• •••• ••••'
                    : _cardNumberController.text.padRight(19, '•'),
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CARDHOLDER',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.white70,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        _cardholderNameController.text.isEmpty
                            ? 'CARDHOLDER NAME'
                            : _cardholderNameController.text.toUpperCase(),
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'EXPIRES',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.white70,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        _expiryMonthController.text.isEmpty ||
                                _expiryYearController.text.isEmpty
                            ? 'MM/YY'
                            : '${_expiryMonthController.text.padLeft(2, '0')}/${_expiryYearController.text.length >= 2 ? _expiryYearController.text.substring(_expiryYearController.text.length - 2) : _expiryYearController.text}',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _addCard(BuildContext context) {
    final cardNumber = _cardNumberController.text.replaceAll(RegExp(r'\D'), '');
    final last4 = cardNumber.length >= 4
        ? cardNumber.substring(cardNumber.length - 4)
        : '0000';
    final expMonth = int.tryParse(_expiryMonthController.text) ?? 12;
    final expYear = int.tryParse(_expiryYearController.text) ?? 2025;

    // Generate mock gateway token (in real app, this would come from payment gateway)
    final gatewayToken = 'tok_${_selectedBrand.toLowerCase()}_${DateTime.now().millisecondsSinceEpoch}';

    context.read<PaymentBloc>().add(
      AddPaymentMethod(
        gatewayToken: gatewayToken,
        brand: _selectedBrand,
        last4: last4,
        expMonth: expMonth,
        expYear: expYear,
      ),
    );
  }
}

