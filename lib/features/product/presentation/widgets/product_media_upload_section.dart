import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hamro_deal/app/theme/theme_extensions.dart';

class ProductMediaUploadSection extends StatelessWidget {
  final List<File> selectedMedia;
  final VoidCallback onAddMedia;
  final VoidCallback onRemoveMedia;

  const ProductMediaUploadSection({
    super.key,
    required this.selectedMedia,
    required this.onAddMedia,
    required this.onRemoveMedia,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: context.softShadow,
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          GestureDetector(
            onTap: onAddMedia,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300, width: 2),
              ),
              child: const Center(child: Icon(Icons.add_a_photo_rounded)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: selectedMedia.isEmpty
                ? Text(
                    "No media selected.\nTap to add.",
                    style: TextStyle(color: context.textSecondary),
                  )
                : Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.file(
                          selectedMedia.first,
                          height: 110,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 6,
                        right: 6,
                        child: GestureDetector(
                          onTap: onRemoveMedia,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
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
          ),
        ],
      ),
    );
  }
}
