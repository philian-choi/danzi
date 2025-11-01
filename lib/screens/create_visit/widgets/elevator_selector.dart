import 'package:flutter/material.dart';
import '../../../utils/constants.dart';

class ElevatorSelector extends StatelessWidget {
  final bool? selectedValue;
  final ValueChanged<bool?> onChanged;

  const ElevatorSelector({
    super.key,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '엘리베이터',
          style: AppTextStyles.bodySmall.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
            border: Border.all(color: AppColors.separator),
          ),
          child: Row(
            children: [
              Expanded(
                child: _ElevatorOption(
                  label: '미선택',
                  isSelected: selectedValue == null,
                  onTap: () => onChanged(null),
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: AppColors.separator,
              ),
              Expanded(
                child: _ElevatorOption(
                  label: '있음',
                  isSelected: selectedValue == true,
                  onTap: () => onChanged(true),
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: AppColors.separator,
              ),
              Expanded(
                child: _ElevatorOption(
                  label: '없음',
                  isSelected: selectedValue == false,
                  onTap: () => onChanged(false),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ElevatorOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ElevatorOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: AppTextStyles.bodySmall.copyWith(
            color: isSelected ? AppColors.primary : AppColors.text,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

