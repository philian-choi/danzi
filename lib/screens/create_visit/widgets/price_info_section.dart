import 'package:flutter/material.dart';
import '../../../utils/constants.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../utils/price_formatter.dart';

class PriceInfoSection extends StatelessWidget {
  final TextEditingController onlinePriceController;
  final TextEditingController fieldPriceController;
  final TextEditingController salePriceController;
  final TextEditingController rentPriceController;
  final TextEditingController actualPriceController;

  const PriceInfoSection({
    super.key,
    required this.onlinePriceController,
    required this.fieldPriceController,
    required this.salePriceController,
    required this.rentPriceController,
    required this.actualPriceController,
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
            AppStrings.priceInfo,
            style: AppTextStyles.headline.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppDimensions.itemSpacing),
          CustomTextField(
            label: AppStrings.onlinePrice,
            hint: '예: 500,000,000',
            controller: onlinePriceController,
            keyboardType: TextInputType.number,
            inputFormatters: [PriceInputFormatter()],
          ),
          const SizedBox(height: AppDimensions.itemSpacing),
          CustomTextField(
            label: AppStrings.fieldPrice,
            hint: '예: 520,000,000',
            controller: fieldPriceController,
            keyboardType: TextInputType.number,
            inputFormatters: [PriceInputFormatter()],
          ),
          const SizedBox(height: AppDimensions.itemSpacing),
          CustomTextField(
            label: AppStrings.salePrice,
            hint: '예: 510,000,000',
            controller: salePriceController,
            keyboardType: TextInputType.number,
            inputFormatters: [PriceInputFormatter()],
          ),
          const SizedBox(height: AppDimensions.itemSpacing),
          CustomTextField(
            label: AppStrings.rentPrice,
            hint: '예: 20,000,000',
            controller: rentPriceController,
            keyboardType: TextInputType.number,
            inputFormatters: [PriceInputFormatter()],
          ),
          const SizedBox(height: AppDimensions.itemSpacing),
          CustomTextField(
            label: AppStrings.actualPrice,
            hint: '예: 505,000,000',
            controller: actualPriceController,
            keyboardType: TextInputType.number,
            inputFormatters: [PriceInputFormatter()],
          ),
        ],
      ),
    );
  }
}

