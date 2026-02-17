import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/app/theme/theme_extensions.dart';
import 'package:hamro_deal/core/utils/snakbar_utils.dart';
import 'package:hamro_deal/features/category/presentation/state/category_state.dart';
import 'package:hamro_deal/features/category/presentation/view_model/category_viewmodel.dart';
import 'package:hamro_deal/features/product/presentation/state/product_state.dart';
import 'package:hamro_deal/features/product/presentation/view_model/product_view_model.dart';
import 'package:hamro_deal/features/product/presentation/widgets/product_category_chip_selector.dart';
import 'package:hamro_deal/features/product/presentation/widgets/product_form_section_header.dart';
import 'package:hamro_deal/features/product/presentation/widgets/product_gradien_submit_button.dart';
import 'package:hamro_deal/features/product/presentation/widgets/product_styled_text_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class AddProductScreen extends ConsumerStatefulWidget {
  const AddProductScreen({super.key});

  @override
  ConsumerState<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends ConsumerState<AddProductScreen> {
  // Form controllers
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();

  // Media handling
  final List<XFile> _selectedMedia = [];
  final ImagePicker _imagePicker = ImagePicker();
  String? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(categoryViewModelProvider.notifier).getAllCategories();
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  Future<bool> _askUserPermission(Permission permission) async {
    final status = await permission.status;
    if (status.isGranted) return true;

    if (status.isDenied) {
      final result = await permission.request();
      return result.isGranted;
    }

    if (status.isPermanentlyDenied) {
      _showPermissionDeniedDialog();
      return false;
    }
    return false;
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Allow the Permission"),
        content: const Text("Go to Permission Settings to use this feature"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => openAppSettings(),
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickFromCamera() async {
    final hasPermission = await _askUserPermission(Permission.camera);
    if (!hasPermission) return;

    try {
      final XFile? photo = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (photo != null) {
        setState(() {
          _selectedMedia
            ..clear()
            ..add(photo);
        });
      }
    } catch (e) {
      debugPrint('Camera error: $e');
      if (mounted) {
        SnackbarUtils.showError(context, "Failed to capture photo");
      }
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _selectedMedia
            ..clear()
            ..add(image);
        });
      }
    } catch (e) {
      debugPrint('Gallery error: $e');
      if (mounted) {
        SnackbarUtils.showError(
          context,
          "Cannot access gallery. Please try camera instead.",
        );
      }
    }
  }

  Future<void> _pickVideo() async {
    try {
      final hasPermission = await _askUserPermission(Permission.camera);
      if (!hasPermission) return;

      final hasMicPermission = await _askUserPermission(Permission.microphone);
      if (!hasMicPermission) return;

      final XFile? video = await _imagePicker.pickVideo(
        source: ImageSource.camera,
        maxDuration: const Duration(minutes: 1),
      );

      if (video != null) {
        setState(() {
          _selectedMedia
            ..clear()
            ..add(video);
        });
      }
    } catch (e) {
      debugPrint('Video error: $e');
      _showPermissionDeniedDialog();
    }
  }

  Future<void> _pickMedia() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: context.surfaceColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: const Text('Open camera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickFromCamera();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Open gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickFromGallery();
                },
              ),
              ListTile(
                leading: const Icon(Icons.videocam_outlined),
                title: const Text('Record video'),
                onTap: () {
                  Navigator.pop(context);
                  _pickVideo();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _removeMedia() {
    setState(() {
      _selectedMedia.clear();
    });
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedCategoryId == null) {
      SnackbarUtils.showError(context, 'Please select a category');
      return;
    }

    // Check if media was selected
    if (_selectedMedia.isEmpty) {
      SnackbarUtils.showError(context, 'Please select a product image');
      return;
    }

    // Use the local file path directly
    final imagePath = _selectedMedia.first.path;

    await ref
        .read(productViewModelProvider.notifier)
        .createProduct(
          title: _titleController.text.trim(),
          description: _descController.text.trim(),
          price: double.parse(_priceController.text.trim()),
          stock: int.parse(_stockController.text.trim()),
          categoryId: _selectedCategoryId!,
          images: imagePath, // Local file path
        );
  }

  @override
  Widget build(BuildContext context) {
    final itemState = ref.watch(productViewModelProvider);
    final categoryState = ref.watch(categoryViewModelProvider);

    // Listen for product creation success/error
    ref.listen<ProductState>(productViewModelProvider, (previous, next) {
      if (next.status == ProductStatus.created) {
        SnackbarUtils.showSuccess(context, 'Product created successfully');
        Navigator.pop(context);
      } else if (next.status == ProductStatus.error &&
          next.errorMessage != null) {
        SnackbarUtils.showError(context, next.errorMessage!);
      }
    });

    // Auto-select first category when loaded
    if (_selectedCategoryId == null &&
        categoryState.status == CategoryStatus.loaded &&
        categoryState.categories.isNotEmpty &&
        categoryState.categories.first.categoryId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _selectedCategoryId = categoryState.categories.first.categoryId;
        });
      });
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Add Product"), centerTitle: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Media Upload Section
                const ProductFormSectionHeader(title: 'Add Photos / Videos'),
                const SizedBox(height: 12),
                Row(
                  children: [
                    GestureDetector(
                      onTap: _pickMedia,
                      child: Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          color: context.surfaceColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: context.borderColor,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.add_a_photo_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Add Photo / Video',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 11,
                                color: context.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (_selectedMedia.isNotEmpty) ...[
                      const SizedBox(width: 12),
                      Stack(
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                image: FileImage(File(_selectedMedia[0].path)),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: _removeMedia,
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                padding: const EdgeInsets.all(4),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 24),

                // Form Fields
                ProductStyledTextField(
                  controller: _titleController,
                  hintText: 'Product name',
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? "Enter product name"
                      : null,
                ),
                const SizedBox(height: 12),
                ProductStyledTextField(
                  controller: _descController,
                  hintText: 'Description',
                  maxLines: 3,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? "Enter description"
                      : null,
                ),
                const SizedBox(height: 12),
                ProductStyledTextField(
                  controller: _priceController,
                  hintText: 'Price',
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  validator: (v) {
                    final x = double.tryParse((v ?? '').trim());
                    if (x == null || x <= 0) return "Enter valid price";
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                ProductStyledTextField(
                  controller: _stockController,
                  hintText: 'Quantity',
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    final x = int.tryParse((v ?? '').trim());
                    if (x == null || x <= 0) return "Enter valid quantity";
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Category Selection
                const ProductFormSectionHeader(title: 'Category'),
                const SizedBox(height: 12),
                ProductCategoryChipSelector(
                  categories: categoryState.categories,
                  selectedCategoryId: _selectedCategoryId,
                  onCategorySelected: (id) {
                    setState(() => _selectedCategoryId = id);
                  },
                ),
                const SizedBox(height: 32),

                // Submit Button
                ProductGradientSubmitButton(
                  isLoading: itemState.status == ProductStatus.loading,
                  text: "Add Product",
                  onTap: _handleSubmit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
