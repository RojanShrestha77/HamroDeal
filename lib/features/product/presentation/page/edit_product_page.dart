import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/app/theme/theme_extensions.dart';
import 'package:hamro_deal/core/api/api_endpoints.dart';
import 'package:hamro_deal/core/utils/snakbar_utils.dart';
import 'package:hamro_deal/features/category/presentation/view_model/category_viewmodel.dart';
import 'package:hamro_deal/features/product/domain/entities/product_entity.dart';
import 'package:hamro_deal/features/product/presentation/state/product_state.dart';
import 'package:hamro_deal/features/product/presentation/view_model/product_view_model.dart';
import 'package:hamro_deal/features/product/presentation/widgets/product_category_chip_selector.dart';
import 'package:hamro_deal/features/product/presentation/widgets/product_form_section_header.dart';
import 'package:hamro_deal/features/product/presentation/widgets/product_gradien_submit_button.dart';
import 'package:hamro_deal/features/product/presentation/widgets/product_styled_text_field.dart';
import 'package:image_picker/image_picker.dart';

class EditProductPage extends ConsumerStatefulWidget {
  final ProductEntity product;

  const EditProductPage({super.key, required this.product});

  @override
  ConsumerState<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends ConsumerState<EditProductPage> {
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
          _hasNewMedia = true;
          _selectedMediaType = 'photo';
        });

        // uploade image
        await ref
            .read(productViewModelProvider.notifier)
            .uploadPhoto(File(image.path));
      }
    } catch (e) {
      debugPrint('Gallery error: $e');
      if (mounted) {
        SnackbarUtils.showError(
          context,
          "CAnnot access the gallery. Please try the Camera",
        );
      }
    }
  }

  Future<void> _handleUpdate() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedCategoryId == null) {
      SnackbarUtils.showError(context, 'Please select a category');
      return;
    }

    String? finalMediaUrl;

    if (_hasNewMedia && _selectedMedia.isNotEmpty) {
      finalMediaUrl = ref.read(productViewModelProvider).uploadedMediaUrl;

      if (finalMediaUrl == null) {
        SnackbarUtils.showError(context, "PLease wait for image upload ");
        return;
      }
    } else {
      finalMediaUrl = _existingMediaUrl;
    }

    print('🟢 Final media URL: $finalMediaUrl');

    // calling the api to update
    await ref
        .read(productViewModelProvider.notifier)
        .updateProduct(
          productId: widget.product.productId!,
          productName: _productNameController.text.trim(),
          description: _descController.text.trim(),
          price: double.parse(_priceController.text.trim()),
          quantity: int.parse(_qtyController.text.trim()),
          category: _selectedCategoryId!,
          media: finalMediaUrl,
          mediaType: _selectedMediaType,
        );
  }

  final _formKey = GlobalKey<FormState>();
  final _productNameController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  final _qtyController = TextEditingController();

  final List<XFile> _selectedMedia = [];
  final ImagePicker _imagePicker = ImagePicker();
  String? _selectedCategoryId;
  String? _selectedMediaType;

  // track if user upload new media
  bool _hasNewMedia = false;
  String? _existingMediaUrl;

  @override
  void initState() {
    super.initState();

    // pre-fill controllers with existing data
    _productNameController.text = widget.product.productName ?? '';
    _descController.text = widget.product.description ?? '';
    _priceController.text = widget.product.price?.toString() ?? '';
    _qtyController.text = widget.product.quantity?.toString() ?? '';
    _selectedCategoryId = widget.product.category;

    // store existing media url
    _existingMediaUrl = widget.product.media;
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _descController.dispose();
    _priceController.dispose();
    _qtyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoryState = ref.watch(categoryViewModelProvider);
    final productState = ref.watch(productViewModelProvider);

    // listen for the success for the failure
    ref.listen<ProductState>(productViewModelProvider, (previous, next) {
      if (next.status == ProductStatus.updated) {
        SnackbarUtils.showSuccess(context, 'Product updated successfully');
        Navigator.pop(context);
      } else if (next.status == ProductStatus.error &&
          next.errorMessage != null) {
        SnackbarUtils.showError(context, next.errorMessage!);
      }
    });
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Product"), centerTitle: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: _pickFromGallery,
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
                                color: _existingMediaUrl != null
                                    ? Colors.orange
                                    : Colors.blue,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                (_existingMediaUrl != null || _hasNewMedia)
                                    ? Icons.edit
                                    : Icons.add_a_photo_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              (_existingMediaUrl != null || _hasNewMedia)
                                  ? 'Change Media'
                                  : 'Add Photo',
                              style: TextStyle(
                                fontSize: 11,
                                color: context.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    if (_hasNewMedia && _selectedMedia.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.file(
                          File(_selectedMedia.first.path),
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                      )
                    else if (_existingMediaUrl != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          ApiEndpoints.itemPicture(_existingMediaUrl!),
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return SizedBox(
                              width: 120,
                              height: 120,
                              child: Center(
                                child: CircularProgressIndicator(
                                  value:
                                      loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 120,
                              height: 120,
                              color: context.borderColor,
                              child: Icon(
                                Icons.image_not_supported_outlined,
                                color: context.textTertiary,
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                ProductStyledTextField(
                  controller: _productNameController,
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
                  controller: _qtyController,
                  hintText: 'Quantity',
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    final x = int.tryParse((v ?? '').trim());
                    if (x == null || x <= 0) return "Enter valid quantity";
                    return null;
                  },
                ),
                // category selection
                const ProductFormSectionHeader(title: 'Category'),
                const SizedBox(height: 12),
                ProductCategoryChipSelector(
                  categories: categoryState.categories,
                  selectedCategoryId: _selectedCategoryId,
                  onCategorySelected: (id) {
                    setState(() => _selectedCategoryId = id);
                  },
                ),

                ProductGradientSubmitButton(
                  isLoading: productState.status == ProductStatus.loading,
                  text: "Update Product",
                  onTap: _handleUpdate,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
