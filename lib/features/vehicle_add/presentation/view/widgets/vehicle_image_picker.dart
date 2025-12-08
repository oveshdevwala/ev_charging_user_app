/// File: lib/features/vehicle_add/presentation/view/widgets/vehicle_image_picker.dart
/// Purpose: Vehicle image picker widget
/// Belongs To: vehicle_add feature
library;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/extensions/context_ext.dart';

/// Vehicle image picker widget.
class VehicleImagePicker extends StatelessWidget {
  const VehicleImagePicker({
    required this.onImagePicked, required this.onImageRemoved, this.imageFile,
    this.imageUrl,
    super.key,
  });

  final File? imageFile;
  final String? imageUrl;
  final ValueChanged<File> onImagePicked;
  final VoidCallback onImageRemoved;

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      onImagePicked(File(pickedFile.path));
    }
  }

  void _showImageSourceDialog(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt, size: 24.r),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(context, ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library, size: 24.r),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(context, ImageSource.gallery);
              },
            ),
            if (imageFile != null || imageUrl != null)
              ListTile(
                leading: Icon(Icons.delete, size: 24.r, color: context.appColors.danger),
                title: Text('Remove Photo', style: TextStyle(color: context.appColors.danger)),
                onTap: () {
                  Navigator.pop(context);
                  onImageRemoved();
                },
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasImage = imageFile != null || imageUrl != null;

    return GestureDetector(
      onTap: () => _showImageSourceDialog(context),
      child: Container(
        width: double.infinity,
        height: 200.h,
        decoration: BoxDecoration(
          color: context.appColors.surfaceVariant,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: context.appColors.outline,
          ),
        ),
        child: hasImage
            ? Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16.r),
                    child: imageFile != null
                        ? Image.file(
                            imageFile!,
                            fit: BoxFit.cover,
                          )
                        : imageUrl != null
                            ? Image.network(
                                imageUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    _buildPlaceholder(context),
                              )
                            : _buildPlaceholder(context),
                  ),
                  Positioned(
                    top: 8.h,
                    right: 8.w,
                    child: IconButton(
                      icon: Icon(Icons.edit, size: 20.r),
                      onPressed: () => _showImageSourceDialog(context),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.black54,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              )
            : _buildPlaceholder(context),
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.add_photo_alternate_outlined,
          size: 48.r,
          color: context.appColors.textSecondary,
        ),
        SizedBox(height: 8.h),
        Text(
          'Add Vehicle Photo',
          style: TextStyle(
            fontSize: 14.sp,
            color: context.appColors.textSecondary,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          'Tap to add',
          style: TextStyle(
            fontSize: 12.sp,
            color: context.appColors.textTertiary,
          ),
        ),
      ],
    );
  }
}

