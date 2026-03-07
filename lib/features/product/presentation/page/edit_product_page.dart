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
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();

  final List<XFile> _selectedMedia = [];
  final ImagePicker _imagePicker = ImagePicker();
  String? _selectedCategoryId;

  // track if user upload new media
  bool _hasNewMedia = false;
  List<String>? _existingMediaUrl;
  
  // For image carousel
  int _currentImageIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    
    _pageController = PageController();

    // pre-fill controllers with existing data
    _titleController.text = widget.product.title;
    _descController.text = widget.product.description;
    _priceController.text = widget.product.price.toString();
    _stockController.text = widget.product.stock.toString();
    _selectedCategoryId = widget.product.categoryId;

    // store existing media url
    _existingMediaUrl = widget.product.images;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _pageController.dispose();
    super.dispose();
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
          _hasNewMedia = true;
        });
      }
    } catch (e) {
      debugPrint('Gallery error: $e');
      if (mounted) {
        SnackbarUtils.showError(
          context,
          "Cannot access the gallery. Please try the Camera",
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

    List<String>? finalMediaUrl;

    if (_hasNewMedia && _selectedMedia.isNotEmpty) {
      // Use the local file path for new image (backend will handle upload)
      finalMediaUrl = [_selectedMedia.first.path];
      print('🟢 Using new image path: $finalMediaUrl');
    } else {
      // Keep existing image URL from backend
      finalMediaUrl = _existingMediaUrl;
      print('🟢 Keeping existing image: $finalMediaUrl');
    }

    // calling the api to update
    await ref
        .read(productViewModelProvider.notifier)
        .updateProduct(
          productId: widget.product.productId!,
          title: _titleController.text.trim(),
          description: _descController.text.trim(),
          price: double.parse(_priceController.text.trim()),
          stock: int.parse(_stockController.text.trim()),
          categoryId: _selectedCategoryId!,
          images: finalMediaUrl,
        );
  }

  @override
  Widget build(BuildContext context) {
    final categoryState = ref.watch(categoryViewModelProvider);
    final productState = ref.watch(productViewModelProvider);

    // listen for the success or failure
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
                // Existing Images Carousel (if not uploading new image)
                if (!_hasNewMedia && _existingMediaUrl != null && _existingMediaUrl!.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ProductFormSectionHeader(title: 'Current Images'),
                      const SizedBox(height: 12),
                      Container(
                        height: 250,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Stack(
                          children: [
                            // Image PageView
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: PageView.builder(
                                controller: _pageController,
                                onPageChanged: (index) {
                                  setState(() {
                                    _currentImageIndex = index;
                                  });
                                },
                                itemCount: _existingMediaUrl!.length,
                                itemBuilder: (context, index) {
                                  return Image.network(
                                    ApiEndpoints.productImage(_existingMediaUrl![index]),
                                    width: double.infinity,
                                    fit: BoxFit.contain,
                                    loadingBuilder: (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: context.borderColor,
                                        child: Icon(
                                          Icons.image_not_supported_outlined,
                                          color: context.textTertiary,
                                          size: 48,
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                            
                            // Navigation arrows (only show if multiple images)
                            if (_existingMediaUrl!.length > 1) ...[
                              // Left arrow
                              if (_currentImageIndex > 0)
                                Positioned(
                                  left: 16,
                                  top: 0,
                                  bottom: 0,
                                  child: Center(
                                    child: GestureDetector(
                                      onTap: () {
                                        _pageController.previousPage(
                                          duration: const Duration(milliseconds: 300),
                                          curve: Curves.easeInOut,
                                        );
                                      },
                                      child: Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.1),
                                              blurRadius: 8,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: const Icon(
                                          Icons.chevron_left,
                                          color: Colors.black,
                                          size: 24,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              
                              // Right arrow
                              if (_currentImageIndex < _existingMediaUrl!.length - 1)
                                Positioned(
                                  right: 16,
                                  top: 0,
                                  bottom: 0,
                                  child: Center(
                                    child: GestureDetector(
                                      onTap: () {
                                        _pageController.nextPage(
                                          duration: const Duration(milliseconds: 300),
                                          curve: Curves.easeInOut,
                                        );
                                      },
                                      child: Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.1),
                                              blurRadius: 8,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: const Icon(
                                          Icons.chevron_right,
                                          color: Colors.black,
                                          size: 24,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              
                              // Dot indicators
                              Positioned(
                                bottom: 16,
                                left: 0,
                                right: 0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                    _existingMediaUrl!.length,
                                    (index) => Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 4),
                                      width: _currentImageIndex == index ? 24 : 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: _currentImageIndex == index
                                            ? Colors.black
                                            : Colors.grey[400],
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                
                // Upload New Image Section
                const ProductFormSectionHeader(title: 'Change Image'),
                const SizedBox(height: 12),
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
                                color: _hasNewMedia ? Colors.green : Colors.orange,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                _hasNewMedia ? Icons.check : Icons.edit,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _hasNewMedia ? 'New Image' : 'Upload New',
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
                      ),
                  ],
                ),
                const SizedBox(height: 12),
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
                const SizedBox(height: 32),
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
