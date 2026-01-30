import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/core/utils/snakbar_utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hamro_deal/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:hamro_deal/features/auth/presentation/state/auth_state.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  // State variables
  File? _selectedImage; // Stores the picked image
  final ImagePicker _picker = ImagePicker(); // Image picker instance

  Future<void> _pickImage() async {
    // show dialog to choose camera or gallery
    final ImageSource? source = await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Image Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (source == null) return;

    final XFile? pickedFile = await _picker.pickImage(
      source: source,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_selectedImage == null) return;

    final url = await ref
        .read(authViewModelProvider.notifier)
        .uploadProfilePicture(_selectedImage!);

    if (!mounted) return;

    if (url != null) {
      SnackbarUtils.showSuccess(
        context,
        'Profile picture uploaded successfully!',
      );

      setState(() {
        _selectedImage = null;
      });
    } else {
      final authState = ref.read(authViewModelProvider);
      SnackbarUtils.showError(
        context,
        authState.errorMessage ?? 'Upload failed',
      );
    }
  }

  Widget _buildProfilePicture() {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 80,
            backgroundColor: Colors.grey[300],
            backgroundImage: _selectedImage != null
                ? FileImage(_selectedImage!)
                : null,
          ),
          // camera icon button
          Positioned(
            bottom: 0,
            right: 0,
            child: CircleAvatar(
              radius: 25,
              backgroundColor: Theme.of(context).primaryColor,
              child: IconButton(
                onPressed: _pickImage,
                icon: const Icon(Icons.camera_alt, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadButton(AuthState authState) {
    final isLoading = authState.status == AuthStatus.loading;
    final hasImage = _selectedImage != null;

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: (hasImage && !isLoading) ? _uploadImage : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          disabledBackgroundColor: Colors.grey[300],
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Text(
                'Upload Profile Picture',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Watch auth state for changes
    final authState = ref.watch(authViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildProfilePicture(),
            const SizedBox(height: 30),
            _buildUploadButton(authState),
            const SizedBox(height: 30),
            if (_selectedImage == null)
              Text(
                'Tap the camera icon to select a profile picture',
                style: TextStyle(color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),

            // We'll add widgets here step by step!
          ],
        ),
      ),
    );
  }
}
