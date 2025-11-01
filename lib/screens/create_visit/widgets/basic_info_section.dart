import 'package:flutter/material.dart';
import '../../../utils/constants.dart';
import '../../../widgets/custom_text_field.dart';
import 'date_picker_field.dart';

class BasicInfoSection extends StatelessWidget {
  final DateTime selectedDate;
  final VoidCallback onDateTap;
  final TextEditingController locationController;
  final TextEditingController apartmentNameController;
  final bool apartmentNameError;

  const BasicInfoSection({
    super.key,
    required this.selectedDate,
    required this.onDateTap,
    required this.locationController,
    required this.apartmentNameController,
    required this.apartmentNameError,
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
            '기본 정보',
            style: AppTextStyles.headline.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppDimensions.itemSpacing),
          DatePickerField(
            selectedDate: selectedDate,
            onTap: onDateTap,
          ),
          const SizedBox(height: AppDimensions.itemSpacing),
          CustomTextField(
            label: AppStrings.location,
            hint: '예: 서울시 강남구 역삼동',
            controller: locationController,
          ),
          const SizedBox(height: AppDimensions.itemSpacing),
          CustomTextField(
            label: AppStrings.apartmentName,
            hint: '예: 한신아파트',
            controller: apartmentNameController,
            isRequired: true,
            showError: apartmentNameError,
          ),
        ],
      ),
    );
  }
}

