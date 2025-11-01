import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import '../models/visit_note.dart';
import '../providers/visit_notes_provider.dart';
import '../utils/constants.dart';
import '../utils/date_formatter.dart';
import '../utils/price_display_formatter.dart';
import '../widgets/toast_message.dart';
import '../widgets/image_viewer.dart';
import 'create_visit_screen.dart';

class DetailVisitScreen extends ConsumerWidget {
  final String visitNoteId;

  const DetailVisitScreen({super.key, required this.visitNoteId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visitNotesState = ref.watch(visitNotesProvider);
    final visitNotes = visitNotesState.notes;
    
    // 노트를 안전하게 찾기
    final visitNote = visitNotes.where((note) => note.id == visitNoteId).firstOrNull;

    if (visitNote == null) {
      // 노트를 찾지 못한 경우 (삭제되었거나 존재하지 않는 경우)
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppStrings.visitNotFound),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      });

      return Scaffold(
        backgroundColor: AppColors.groupedBackground,
        appBar: AppBar(
          title: Text(
            AppStrings.visitDetail,
            style: AppTextStyles.title3,
          ),
          backgroundColor: AppColors.groupedBackground,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return _buildDetailContent(context, ref, visitNote);
  }

  Widget _buildDetailContent(BuildContext context, WidgetRef ref, VisitNote visitNote) {
    return Scaffold(
      backgroundColor: AppColors.groupedBackground,
      appBar: AppBar(
        title: const Text(
          '임장 상세',
          style: AppTextStyles.title3,
        ),
        backgroundColor: AppColors.groupedBackground,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.padding, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(AppDimensions.cardPadding),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    visitNote.apartmentName.isNotEmpty
                        ? visitNote.apartmentName
                        : AppStrings.noRecords,
                    style: AppTextStyles.title.copyWith(fontSize: 22),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    DateFormatter.formatDateTime(visitNote.date),
                    style: AppTextStyles.caption,
                  ),
                  if (visitNote.location.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    _buildDetailRow(AppStrings.location, visitNote.location),
                  ],
                  if (visitNote.buildingAge != null) ...[
                    const SizedBox(height: 12),
                    _buildDetailRow(
                      AppStrings.buildingAge,
                      '${visitNote.buildingAge}년',
                    ),
                  ],
                  if (visitNote.direction != null) ...[
                    const SizedBox(height: 12),
                    _buildDetailRow(AppStrings.direction, visitNote.direction!),
                  ],
                  if (visitNote.structure != null) ...[
                    const SizedBox(height: 12),
                    _buildDetailRow(AppStrings.structure, visitNote.structure!),
                  ],
                  if (visitNote.hasElevator != null) ...[
                    const SizedBox(height: 12),
                    _buildDetailRow(AppStrings.elevator, visitNote.hasElevator! ? AppStrings.elevatorYes : AppStrings.elevatorNo),
                  ],
                  if (visitNote.parkingType != null) ...[
                    const SizedBox(height: 12),
                    _buildDetailRow(AppStrings.parking, visitNote.parkingType!),
                  ],
                  if (visitNote.householdCount != null) ...[
                    const SizedBox(height: 12),
                    _buildDetailRow(AppStrings.householdCount, '${visitNote.householdCount}세대'),
                  ],
                  if (visitNote.area != null) ...[
                    const SizedBox(height: 12),
                    _buildDetailRow(AppStrings.areaLabel, '${visitNote.area}㎡'),
                  ],
                  if (visitNote.schoolInfo != null && visitNote.schoolInfo!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    _buildDetailRow(AppStrings.schoolInfo, visitNote.schoolInfo!),
                  ],
                  if (visitNote.onlinePrice != null ||
                      visitNote.fieldPrice != null ||
                      visitNote.salePrice != null ||
                      visitNote.rentPrice != null ||
                      visitNote.actualPrice != null) ...[
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 16),
                    Text(
                      AppStrings.priceInfoSection,
                      style: AppTextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (visitNote.onlinePrice != null) ...[
                      const SizedBox(height: 8),
                      _buildDetailRow(AppStrings.onlinePriceLabel, '${PriceDisplayFormatter.formatPrice(visitNote.onlinePrice)}원'),
                    ],
                    if (visitNote.fieldPrice != null) ...[
                      const SizedBox(height: 8),
                      _buildDetailRow(AppStrings.fieldPriceLabel, '${PriceDisplayFormatter.formatPrice(visitNote.fieldPrice)}원'),
                    ],
                    if (visitNote.salePrice != null) ...[
                      const SizedBox(height: 8),
                      _buildDetailRow(AppStrings.salePriceLabel, '${PriceDisplayFormatter.formatPrice(visitNote.salePrice)}원'),
                    ],
                    if (visitNote.rentPrice != null) ...[
                      const SizedBox(height: 8),
                      _buildDetailRow(AppStrings.rentPriceLabel, '${PriceDisplayFormatter.formatPrice(visitNote.rentPrice)}원'),
                    ],
                    if (visitNote.actualPrice != null) ...[
                      const SizedBox(height: 8),
                      _buildDetailRow(AppStrings.actualPriceLabel, '${PriceDisplayFormatter.formatPrice(visitNote.actualPrice)}원'),
                    ],
                  ],
                  if (visitNote.memo.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 16),
                    Text(
                      AppStrings.memo,
                      style: AppTextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      visitNote.memo,
                      style: AppTextStyles.body,
                    ),
                  ],
                ],
              ),
            ),
            if (visitNote.photoPaths.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                AppStrings.photos,
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1,
                ),
                itemCount: visitNote.photoPaths.length,
                itemBuilder: (context, index) {
                  final photoPath = visitNote.photoPaths[index];
                  final file = File(photoPath);
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ImageViewer(
                            imagePaths: visitNote.photoPaths,
                            initialIndex: index,
                          ),
                        ),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        file,
                        fit: BoxFit.cover,
                        cacheWidth: 300, // 썸네일 크기로 제한
                        cacheHeight: 300,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: AppColors.separator,
                            child: const Icon(Icons.broken_image,
                                color: Colors.grey),
                          );
                        },
                        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                          if (wasSynchronouslyLoaded) {
                            return child;
                          }
                          return AnimatedOpacity(
                            opacity: frame == null ? 0 : 1,
                            duration: const Duration(milliseconds: 150),
                            child: child,
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(AppDimensions.padding),
        decoration: const BoxDecoration(
          color: AppColors.cardBackground,
          border: Border(
            top: BorderSide(color: AppColors.separator, width: 1),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateVisitScreen(
                        editNote: visitNote,
                      ),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: AppColors.primary),
                ),
                child: Text(
                  AppStrings.edit,
                  style: AppTextStyles.button.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(AppStrings.deleteConfirmTitle),
                      content: Text(AppStrings.deleteConfirmMessage),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text(AppStrings.cancel),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text(
                            AppStrings.delete,
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );

                  if (confirmed == true && context.mounted) {
                    await ref
                        .read(visitNotesProvider.notifier)
                        .deleteVisitNote(visitNoteId);
                    if (context.mounted) {
                      ToastMessage.show(context, AppStrings.deleted);
                      Navigator.pop(context);
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  AppStrings.delete,
                  style: AppTextStyles.button,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: AppTextStyles.caption,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.bodySmall,
          ),
        ),
      ],
    );
  }

}

