import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/app/theme/theme_extensions.dart';
import 'package:hamro_deal/core/utils/snakbar_utils.dart';
import 'package:hamro_deal/features/product/presentation/view_model/product_view_mode.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class AddProductScreen extends ConsumerStatefulWidget {
  const AddProductScreen({super.key});

  @override
  ConsumerState<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends ConsumerState<AddProductScreen> {
  // Media
  final List<XFile> _selectedMedia = [];
  final ImagePicker _imagePicker = ImagePicker();

  // Form controllers (UI only)
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  final _qtyController = TextEditingController();

  // Dropdown UI values (dummy UI data for now)
  String? _selectedCategoryId;
  String? _selectedStatus;

  final _categories = const [
    {'id': 'cat_1', 'name': 'Electronics'},
    {'id': 'cat_2', 'name': 'Fashion'},
    {'id': 'cat_3', 'name': 'Home & Living'},
    {'id': 'cat_4', 'name': 'Groceries'},
  ];

  final _statuses = const ['active', 'draft', 'sold'];

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _priceController.dispose();
    _qtyController.dispose();
    super.dispose();
  }

  Future<bool> _askUserPermisson(Permission permission) async {
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
        content: const Text("Go to Permission Settings to use this features"),
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
    final hasPermisson = await _askUserPermisson(Permission.camera);
    if (!hasPermisson) return;

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

      // You already do this - leaving it as-is
      await ref
          .read(productViewModelProvider.notifier)
          .uploadPhoto(File(photo.path));
    }
  }

  Future<void> _pickFromGallery({bool allowMultiple = false}) async {
    try {
      if (allowMultiple) {
        final List<XFile> images = await _imagePicker.pickMultiImage(
          imageQuality: 80,
        );

        if (images.isNotEmpty) {
          setState(() {
            _selectedMedia
              ..clear()
              ..addAll(images);
          });
        }
      } else {
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

          await ref
              .read(productViewModelProvider.notifier)
              .uploadPhoto(File(image.path));
        }
      }
    } catch (e) {
      debugPrint('Gallery Error $e');
      if (mounted) {
        SnackbarUtils.showError(
          context,
          "Cannot access the gallery. Please open the camera and click the photo",
        );
      }
    }
  }

  Future<void> _pickFromVideo() async {
    try {
      final hasPermission = await _askUserPermisson(Permission.camera);
      if (!hasPermission) return;

      final hasMicPermission = await _askUserPermisson(Permission.microphone);
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

        // UI only for video upload (you can add later)
      }
    } catch (e) {
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
                title: const Text('Open video'),
                onTap: () {
                  Navigator.pop(context);
                  _pickFromVideo();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(16);

    return Scaffold(
      appBar: AppBar(title: const Text("Add Product"), centerTitle: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SectionTitle(title: 'Photos / Videos'),
              const SizedBox(height: 12),

              // Media card
              Container(
                decoration: BoxDecoration(
                  color: context.surfaceColor,
                  borderRadius: radius,
                  border: Border.all(color: Colors.grey.shade300),
                ),
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _AddMediaTile(onTap: _pickMedia),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _selectedMedia.isEmpty
                          ? _EmptyMediaHint()
                          : _SelectedMediaPreview(
                              path: _selectedMedia.first.path,
                              onRemove: () {
                                setState(() => _selectedMedia.clear());
                              },
                            ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              _SectionTitle(title: 'Product Information'),
              const SizedBox(height: 12),

              _InputCard(
                child: Column(
                  children: [
                    _LabeledField(
                      label: "Product Name",
                      child: TextField(
                        controller: _nameController,
                        decoration: _inputDecoration("e.g. iPhone 15 Pro"),
                      ),
                    ),
                    const SizedBox(height: 14),
                    _LabeledField(
                      label: "Description",
                      child: TextField(
                        controller: _descController,
                        minLines: 4,
                        maxLines: 6,
                        decoration: _inputDecoration(
                          "Write product details...",
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: _LabeledField(
                            label: "Price",
                            child: TextField(
                              controller: _priceController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              decoration: _inputDecoration(
                                "e.g. 999.99",
                              ).copyWith(prefixText: "Rs "),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _LabeledField(
                            label: "Quantity",
                            child: TextField(
                              controller: _qtyController,
                              keyboardType: TextInputType.number,
                              decoration: _inputDecoration("e.g. 10"),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              _InputCard(
                child: Column(
                  children: [
                    _LabeledField(
                      label: "Category",
                      child: DropdownButtonFormField<String>(
                        value: _selectedCategoryId,
                        decoration: _inputDecoration("Select a category"),
                        items: _categories
                            .map(
                              (c) => DropdownMenuItem<String>(
                                value: c['id']!,
                                child: Text(c['name']!),
                              ),
                            )
                            .toList(),
                        onChanged: (v) {
                          setState(() => _selectedCategoryId = v);
                        },
                      ),
                    ),
                    const SizedBox(height: 14),
                    _LabeledField(
                      label: "Status",
                      child: DropdownButtonFormField<String>(
                        value: _selectedStatus,
                        decoration: _inputDecoration("Select status"),
                        items: _statuses
                            .map(
                              (s) => DropdownMenuItem<String>(
                                value: s,
                                child: Text(s),
                              ),
                            )
                            .toList(),
                        onChanged: (v) => setState(() => _selectedStatus = v),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    // UI only for now
                    // SnackbarUtils.showMessage(
                    //   context,
                    //   "UI ready ✅ (No functionality yet)",
                    // );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: radius),
                  ),
                  child: const Text(
                    "Create Product",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),

              const SizedBox(height: 12),
              Center(
                child: Text(
                  "You can connect this button to your ViewModel later.",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade500),
      ),
    );
  }
}

// ---------- Small UI widgets ----------

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
    );
  }
}

class _InputCard extends StatelessWidget {
  final Widget child;
  const _InputCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      padding: const EdgeInsets.all(14),
      child: child,
    );
  }
}

class _LabeledField extends StatelessWidget {
  final String label;
  final Widget child;
  const _LabeledField({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

class _AddMediaTile extends StatelessWidget {
  final VoidCallback onTap;
  const _AddMediaTile({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 110,
        height: 110,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300, width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.add_a_photo_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add Photo / Video',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyMediaHint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Text(
        "No media selected.\nTap ‘Add Photo / Video’ to upload.",
        style: TextStyle(color: Colors.grey.shade600, height: 1.3),
      ),
    );
  }
}

class _SelectedMediaPreview extends StatelessWidget {
  final String path;
  final VoidCallback onRemove;

  const _SelectedMediaPreview({required this.path, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.file(
            File(path),
            height: 110,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 6,
          right: 6,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(6),
              child: const Icon(Icons.close, color: Colors.white, size: 16),
            ),
          ),
        ),
      ],
    );
  }
}
