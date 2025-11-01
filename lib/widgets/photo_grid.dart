import 'package:flutter/material.dart';
import 'dart:io';
import '../utils/constants.dart';

class PhotoGrid extends StatelessWidget {
  final List<String> photoPaths;
  final VoidCallback? onAddPhoto;
  final Function(int)? onPhotoTap;

  const PhotoGrid({
    super.key,
    required this.photoPaths,
    this.onAddPhoto,
    this.onPhotoTap,
  });

  @override
  Widget build(BuildContext context) {
    if (photoPaths.isEmpty && onAddPhoto == null) {
      return const SizedBox.shrink();
    }

    final itemCount = photoPaths.length + (onAddPhoto != null ? 1 : 0);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        if (onAddPhoto != null && index == photoPaths.length) {
          return GestureDetector(
            onTap: onAddPhoto,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.separator,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.primary, width: 1, style: BorderStyle.solid),
              ),
              child: const Icon(Icons.add_photo_alternate, color: AppColors.primary, size: 32),
            ),
          );
        }

        final photoPath = photoPaths[index];
        final file = File(photoPath);
        return GestureDetector(
          onTap: () => onPhotoTap?.call(index),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              file,
              fit: BoxFit.cover,
              cacheWidth: 300, // 썸네일 크기로 제한하여 메모리 사용량 감소
              cacheHeight: 300,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: AppColors.separator,
                  child: const Icon(Icons.broken_image, color: Colors.grey),
                );
              },
              frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                if (wasSynchronouslyLoaded) {
                  return child;
                }
                return AnimatedOpacity(
                  opacity: frame == null ? 0 : 1,
                  duration: const Duration(milliseconds: 150), // 애니메이션 시간 단축
                  child: child,
                );
              },
            ),
          ),
        );
      },
    );
  }
}

