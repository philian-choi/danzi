import 'package:flutter/material.dart';
import 'dart:io';
import '../models/visit_note.dart';
import '../utils/constants.dart';
import '../utils/date_formatter.dart';
import '../utils/price_display_formatter.dart';

class VisitCard extends StatefulWidget {
  final VisitNote visitNote;
  final VoidCallback onTap;
  final Future<void> Function()? onDelete;

  const VisitCard({
    super.key,
    required this.visitNote,
    required this.onTap,
    required this.onDelete,
  });

  @override
  State<VisitCard> createState() => _VisitCardState();
}

class _VisitCardState extends State<VisitCard>
    with SingleTickerProviderStateMixin {
  double _scale = 1.0;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.addListener(() {
      setState(() {
        _scale = _scaleAnimation.value;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(widget.visitNote.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (_) async {
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(AppStrings.deleteConfirmTitle),
            content: const Text(AppStrings.deleteConfirmMessage),
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
        return confirmed ?? false;
      },
      onDismissed: (_) {
        widget.onDelete?.call();
      },
      child: InkWell(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) => _controller.reverse(),
        onTapCancel: () => _controller.reverse(),
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
        child: Transform.scale(
          scale: _scale,
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        widget.visitNote.apartmentName.isNotEmpty
                            ? widget.visitNote.apartmentName
                            : AppStrings.noRecords,
                        style: AppTextStyles.headline,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      DateFormatter.formatDateShort(widget.visitNote.date),
                      style: AppTextStyles.footnote.copyWith(
                        color: AppColors.tertiaryText,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.visitNote.location.isNotEmpty)
                      Expanded(
                        child: Text(
                          widget.visitNote.location,
                          style: AppTextStyles.subheadline,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    if (widget.visitNote.location.isNotEmpty) const SizedBox(width: 12),
                    if (PriceDisplayFormatter.formatPriorityPrice(
                          actualPrice: widget.visitNote.actualPrice,
                          salePrice: widget.visitNote.salePrice,
                          fieldPrice: widget.visitNote.fieldPrice,
                          onlinePrice: widget.visitNote.onlinePrice,
                        ) != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.attach_money,
                              size: 14,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              PriceDisplayFormatter.formatPriorityPrice(
                                actualPrice: widget.visitNote.actualPrice,
                                salePrice: widget.visitNote.salePrice,
                                fieldPrice: widget.visitNote.fieldPrice,
                                onlinePrice: widget.visitNote.onlinePrice,
                              )!,
                              style: AppTextStyles.footnote.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                if (widget.visitNote.memo.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      widget.visitNote.memo,
                      style: AppTextStyles.footnote,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                if (widget.visitNote.photoPaths.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      children: [
                        // 첫 번째 사진 썸네일
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.file(
                            File(widget.visitNote.photoPaths[0]),
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                            cacheWidth: 100,
                            cacheHeight: 100,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 48,
                                height: 48,
                                color: AppColors.separator,
                                child: const Icon(
                                  Icons.broken_image,
                                  size: 24,
                                  color: AppColors.tertiaryText,
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        // 사진 개수 정보
                        Row(
                          children: [
                            const Icon(
                              Icons.photo_library_outlined,
                              size: 16,
                              color: AppColors.tertiaryText,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${widget.visitNote.photoPaths.length}',
                              style: AppTextStyles.caption2,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

