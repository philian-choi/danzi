import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';
import '../providers/visit_notes_provider.dart';
import '../providers/storage_provider.dart';
import '../utils/constants.dart';
import '../utils/error_handler.dart';
import '../widgets/toast_message.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.groupedBackground,
      appBar: AppBar(
        title: const Text(
          AppStrings.settings,
          style: AppTextStyles.title3,
        ),
        backgroundColor: AppColors.groupedBackground,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: const SettingsScreenBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        onTap: (index) {
          if (index == 0) {
            Navigator.popUntil(context, (route) => route.isFirst);
          } else if (index == 1) {
            Navigator.pop(context);
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: AppStrings.home,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: AppStrings.create,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: AppStrings.settings,
          ),
        ],
      ),
    );
  }
}

class SettingsScreenBody extends ConsumerStatefulWidget {
  const SettingsScreenBody({super.key});

  @override
  ConsumerState<SettingsScreenBody> createState() => _SettingsScreenBodyState();
}

class _SettingsScreenBodyState extends ConsumerState<SettingsScreenBody> {
  Future<void> _exportData() async {
    try {
      final storageService = ref.read(storageServiceProvider);
      final jsonString = await storageService.exportData();
      
      await Share.shareXFiles(
        [],
        text: jsonString,
        subject: '단지노트 백업 데이터',
      );
      
      if (mounted) {
        ToastMessage.show(context, AppStrings.backupShared);
      }
    } catch (e) {
      ErrorHandler.handleError(context, e, userMessage: AppStrings.backupFailed);
    }
  }

  Future<void> _importData() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result == null || result.files.single.path == null) {
        return;
      }

      final file = File(result.files.single.path!);
      final jsonString = await file.readAsString();

      if (!mounted) return;

      final storageService = ref.read(storageServiceProvider);
      final success = await storageService.importData(jsonString);

      if (!mounted) return;

      if (success) {
        await ref.read(visitNotesProvider.notifier).loadVisitNotes();
        if (mounted) {
          ToastMessage.show(context, AppStrings.restoreSuccess);
        }
      } else {
        if (mounted) {
          ToastMessage.show(context, AppStrings.restoreFailed);
        }
      }
    } catch (e) {
      ErrorHandler.handleFileError(context, e, fileName: '백업 파일');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.padding, vertical: 8),
      children: [
        _buildSectionTitle('데이터 관리'),
        _buildSettingTile(
          icon: Icons.backup,
          title: AppStrings.backup,
          subtitle: '데이터를 JSON 형식으로 내보내기',
          onTap: _exportData,
        ),
        _buildSettingTile(
          icon: Icons.restore,
          title: AppStrings.restore,
          subtitle: 'JSON 데이터를 복원하기',
          onTap: _importData,
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 8),
      child: Text(
        title,
        style: AppTextStyles.bodySmall.copyWith(
          fontWeight: FontWeight.w600,
          color: const Color(0xFF666666),
        ),
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
        border: Border.all(color: AppColors.separator, width: 1),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title, style: AppTextStyles.bodySmall),
        subtitle: Text(subtitle, style: AppTextStyles.caption),
        onTap: onTap,
        trailing: const Icon(Icons.chevron_right, color: AppColors.separator),
      ),
    );
  }
}

