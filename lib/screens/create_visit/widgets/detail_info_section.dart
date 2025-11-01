import 'package:flutter/material.dart';
import '../../../utils/constants.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/custom_dropdown.dart';
import 'elevator_selector.dart';

class DetailInfoSection extends StatelessWidget {
  final TextEditingController buildingAgeController;
  final String? selectedStructure;
  final ValueChanged<String?> onStructureChanged;
  final String? selectedDirection;
  final ValueChanged<String?> onDirectionChanged;
  final bool? hasElevator;
  final ValueChanged<bool?> onElevatorChanged;
  final String? selectedParkingType;
  final ValueChanged<String?> onParkingTypeChanged;
  final TextEditingController householdCountController;
  final TextEditingController areaController;
  final TextEditingController schoolInfoController;
  final VoidCallback onFieldChanged;

  const DetailInfoSection({
    super.key,
    required this.buildingAgeController,
    required this.selectedStructure,
    required this.onStructureChanged,
    required this.selectedDirection,
    required this.onDirectionChanged,
    required this.hasElevator,
    required this.onElevatorChanged,
    required this.selectedParkingType,
    required this.onParkingTypeChanged,
    required this.householdCountController,
    required this.areaController,
    required this.schoolInfoController,
    required this.onFieldChanged,
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
            '상세 정보',
            style: AppTextStyles.headline.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppDimensions.itemSpacing),
          CustomTextField(
            label: AppStrings.buildingAge,
            hint: '예: 10',
            controller: buildingAgeController,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          CustomDropdown<String>(
            label: AppStrings.structure,
            value: selectedStructure,
            items: StructureOptions.options,
            itemLabel: (item) => item,
            onChanged: (value) {
              onStructureChanged(value);
              onFieldChanged();
            },
          ),
          const SizedBox(height: AppDimensions.itemSpacing),
          CustomDropdown<String>(
            label: '향',
            value: selectedDirection,
            items: DirectionOptions.options,
            itemLabel: (item) => item,
            onChanged: (value) {
              onDirectionChanged(value);
              onFieldChanged();
            },
          ),
          const SizedBox(height: AppDimensions.itemSpacing),
          ElevatorSelector(
            selectedValue: hasElevator,
            onChanged: (value) {
              onElevatorChanged(value);
              onFieldChanged();
            },
          ),
          const SizedBox(height: AppDimensions.itemSpacing),
          CustomDropdown<String>(
            label: '주차장',
            value: selectedParkingType,
            items: ParkingOptions.options,
            itemLabel: (item) => item,
            onChanged: (value) {
              onParkingTypeChanged(value);
              onFieldChanged();
            },
          ),
          const SizedBox(height: AppDimensions.itemSpacing),
          CustomTextField(
            label: '세대수',
            hint: '예: 150',
            controller: householdCountController,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: AppDimensions.itemSpacing),
          CustomTextField(
            label: '해당평형 (㎡)',
            hint: '예: 84',
            controller: areaController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: AppDimensions.itemSpacing),
          CustomTextField(
            label: '학교정보',
            hint: '초/중 학군, 학업성취도 입력',
            controller: schoolInfoController,
            maxLines: 3,
          ),
        ],
      ),
    );
  }

}

