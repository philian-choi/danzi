import 'package:flutter/material.dart';
import '../../../utils/constants.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/photo_grid.dart';

class AdditionalInfoSection extends StatelessWidget {
  final TextEditingController memoController;
  final List<String> photoPaths;
  final VoidCallback onAddPhoto;
  final Function(int) onPhotoTap;

  const AdditionalInfoSection({
    super.key,
    required this.memoController,
    required this.photoPaths,
    required this.onAddPhoto,
    required this.onPhotoTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
        border: Border.all(color: AppColors.separator, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '추가 정보',
            style: AppTextStyles.headline.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppDimensions.itemSpacing),
          CustomTextField(
            label: AppStrings.memo,
            hint: '메모를 입력하세요',
            controller: memoController,
            maxLines: 5,
          ),
          const SizedBox(height: AppDimensions.itemSpacing),
          Text(
            AppStrings.photos,
            style: AppTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          PhotoGrid(
            photoPaths: photoPaths,
            onAddPhoto: onAddPhoto,
            onPhotoTap: onPhotoTap,
          ),
        ],
      ),
    );
  }
}

