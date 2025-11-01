import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import '../models/visit_note.dart';
import '../providers/visit_notes_provider.dart';
import '../utils/constants.dart';
import '../utils/debouncer.dart';
import '../widgets/toast_message.dart';
import '../utils/price_formatter.dart';
import 'create_visit/widgets/basic_info_section.dart';
import 'create_visit/widgets/detail_info_section.dart';
import 'create_visit/widgets/price_info_section.dart';
import 'create_visit/widgets/additional_info_section.dart';

class CreateVisitScreen extends ConsumerStatefulWidget {
  final VisitNote? editNote;

  const CreateVisitScreen({super.key, this.editNote});

  @override
  ConsumerState<CreateVisitScreen> createState() => _CreateVisitScreenState();
}

class _CreateVisitScreenState extends ConsumerState<CreateVisitScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _locationController;
  late TextEditingController _apartmentNameController;
  late TextEditingController _buildingAgeController;
  late TextEditingController _householdCountController;
  late TextEditingController _areaController;
  late TextEditingController _schoolInfoController;
  late TextEditingController _onlinePriceController;
  late TextEditingController _fieldPriceController;
  late TextEditingController _salePriceController;
  late TextEditingController _rentPriceController;
  late TextEditingController _actualPriceController;
  late TextEditingController _memoController;
  final _debouncer = Debouncer(delay: const Duration(seconds: 3));
  DateTime _selectedDate = DateTime.now();
  String? _selectedStructure;
  String? _selectedDirection;
  bool? _hasElevator;
  String? _selectedParkingType;
  List<String> _photoPaths = [];
  String _saveStatus = ''; // 'saving', 'saved', ''
  bool _apartmentNameError = false; // 단지명 필드 에러 상태

  @override
  void initState() {
    super.initState();
    if (widget.editNote != null) {
      final note = widget.editNote!;
      _locationController = TextEditingController(text: note.location);
      _apartmentNameController = TextEditingController(text: note.apartmentName);
      _buildingAgeController = TextEditingController(
        text: note.buildingAge?.toString() ?? '',
      );
      _householdCountController = TextEditingController(
        text: note.householdCount?.toString() ?? '',
      );
      _areaController = TextEditingController(
        text: note.area?.toString() ?? '',
      );
      _schoolInfoController = TextEditingController(text: note.schoolInfo ?? '');
      _onlinePriceController = TextEditingController(
        text: PriceInputFormatter.formatNumber(note.onlinePrice),
      );
      _fieldPriceController = TextEditingController(
        text: PriceInputFormatter.formatNumber(note.fieldPrice),
      );
      _salePriceController = TextEditingController(
        text: PriceInputFormatter.formatNumber(note.salePrice),
      );
      _rentPriceController = TextEditingController(
        text: PriceInputFormatter.formatNumber(note.rentPrice),
      );
      _actualPriceController = TextEditingController(
        text: PriceInputFormatter.formatNumber(note.actualPrice),
      );
      _memoController = TextEditingController(text: note.memo);
      _selectedDate = note.date;
      _selectedStructure = note.structure;
      _selectedDirection = note.direction;
      _hasElevator = note.hasElevator;
      _selectedParkingType = note.parkingType;
      _photoPaths = List.from(note.photoPaths);
    } else {
      _locationController = TextEditingController();
      _apartmentNameController = TextEditingController();
      _buildingAgeController = TextEditingController();
      _householdCountController = TextEditingController();
      _areaController = TextEditingController();
      _schoolInfoController = TextEditingController();
      _onlinePriceController = TextEditingController();
      _fieldPriceController = TextEditingController();
      _salePriceController = TextEditingController();
      _rentPriceController = TextEditingController();
      _actualPriceController = TextEditingController();
      _memoController = TextEditingController();
      _loadDraft();
    }

    _locationController.addListener(_onFieldChanged);
    _apartmentNameController.addListener(_onFieldChanged);
    _buildingAgeController.addListener(_onFieldChanged);
    _householdCountController.addListener(_onFieldChanged);
    _areaController.addListener(_onFieldChanged);
    _schoolInfoController.addListener(_onFieldChanged);
    _onlinePriceController.addListener(_onFieldChanged);
    _fieldPriceController.addListener(_onFieldChanged);
    _salePriceController.addListener(_onFieldChanged);
    _rentPriceController.addListener(_onFieldChanged);
    _actualPriceController.addListener(_onFieldChanged);
    _memoController.addListener(_onFieldChanged);
  }

  Future<void> _loadDraft() async {
    final draft = await ref.read(storageServiceProvider).getDraft();
    if (draft != null && mounted) {
      _locationController.text = draft.location;
      _apartmentNameController.text = draft.apartmentName;
      _buildingAgeController.text = draft.buildingAge?.toString() ?? '';
      _householdCountController.text = draft.householdCount?.toString() ?? '';
      _areaController.text = draft.area?.toString() ?? '';
      _schoolInfoController.text = draft.schoolInfo ?? '';
      _onlinePriceController.text = PriceInputFormatter.formatNumber(draft.onlinePrice);
      _fieldPriceController.text = PriceInputFormatter.formatNumber(draft.fieldPrice);
      _salePriceController.text = PriceInputFormatter.formatNumber(draft.salePrice);
      _rentPriceController.text = PriceInputFormatter.formatNumber(draft.rentPrice);
      _actualPriceController.text = PriceInputFormatter.formatNumber(draft.actualPrice);
      _memoController.text = draft.memo;
      _selectedDate = draft.date;
      _selectedStructure = draft.structure;
      _selectedDirection = draft.direction;
      _hasElevator = draft.hasElevator;
      _selectedParkingType = draft.parkingType;
      _photoPaths = List.from(draft.photoPaths);
      setState(() {});
    }
  }

  void _onFieldChanged() {
    // 단지명 에러 상태 초기화
    if (_apartmentNameError && _apartmentNameController.text.trim().isNotEmpty) {
      setState(() {
        _apartmentNameError = false;
      });
    }
    _debouncer.run(_autoSave);
  }

  Future<void> _autoSave() async {
    if (widget.editNote != null) return;

    setState(() {
      _saveStatus = 'saving';
    });

    final note = _createVisitNote();
    if (note != null) {
      await ref.read(storageServiceProvider).saveDraft(note);
      
      if (mounted) {
        setState(() {
          _saveStatus = 'saved';
        });
        
        // 2초 후 상태 메시지 숨기기
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              _saveStatus = '';
            });
          }
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _saveStatus = '';
        });
      }
    }
  }

  VisitNote? _createVisitNote() {
    // 최소한 하나의 항목은 입력되어야 함
    if (_locationController.text.isEmpty &&
        _apartmentNameController.text.isEmpty &&
        _memoController.text.isEmpty) {
      return null;
    }

    return VisitNote(
      id: widget.editNote?.id ?? const Uuid().v4(),
      date: _selectedDate,
      location: _locationController.text,
      apartmentName: _apartmentNameController.text,
      buildingAge: _buildingAgeController.text.isEmpty
          ? null
          : int.tryParse(_buildingAgeController.text),
      direction: _selectedDirection,
      structure: _selectedStructure,
      hasElevator: _hasElevator,
      parkingType: _selectedParkingType,
      householdCount: _householdCountController.text.isEmpty
          ? null
          : int.tryParse(_householdCountController.text),
      area: _areaController.text.isEmpty
          ? null
          : double.tryParse(_areaController.text),
      schoolInfo: _schoolInfoController.text.isEmpty
          ? null
          : _schoolInfoController.text,
      onlinePrice: _onlinePriceController.text.isEmpty
          ? null
          : int.tryParse(PriceInputFormatter.removeCommas(_onlinePriceController.text)),
      fieldPrice: _fieldPriceController.text.isEmpty
          ? null
          : int.tryParse(PriceInputFormatter.removeCommas(_fieldPriceController.text)),
      salePrice: _salePriceController.text.isEmpty
          ? null
          : int.tryParse(PriceInputFormatter.removeCommas(_salePriceController.text)),
      rentPrice: _rentPriceController.text.isEmpty
          ? null
          : int.tryParse(PriceInputFormatter.removeCommas(_rentPriceController.text)),
      actualPrice: _actualPriceController.text.isEmpty
          ? null
          : int.tryParse(PriceInputFormatter.removeCommas(_actualPriceController.text)),
      memo: _memoController.text,
      photoPaths: _photoPaths,
      timestamp: widget.editNote?.timestamp ?? DateTime.now().millisecondsSinceEpoch,
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    
    if (source == ImageSource.gallery) {
      // 갤러리에서 다중 선택
      final pickedFiles = await picker.pickMultiImage();
      if (pickedFiles.isNotEmpty) {
        await _saveImages(pickedFiles);
      }
    } else {
      // 카메라에서 단일 선택
      final pickedFile = await picker.pickImage(source: source);
      if (pickedFile != null) {
        await _saveImages([pickedFile]);
      }
    }
  }

  Future<void> _saveImages(List<XFile> files) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final savedPaths = <String>[];
      
      for (final pickedFile in files) {
        final timestamp = DateTime.now().millisecondsSinceEpoch + savedPaths.length;
        // 확장자 추출 (경로에 .이 여러 개 있을 수 있음)
        final pathParts = pickedFile.path.split('.');
        final extension = pathParts.length > 1 ? pathParts.last.toLowerCase() : 'jpg';
        final fileName = 'photo_$timestamp.$extension';
        final savedFile = File('${directory.path}/$fileName');
        
        // 원본 파일이 존재하는지 확인
        final sourceFile = File(pickedFile.path);
        if (!await sourceFile.exists()) {
          continue;
        }
        
        await sourceFile.copy(savedFile.path);
        
        // 복사된 파일 확인
        if (await savedFile.exists()) {
          savedPaths.add(savedFile.path);
        }
      }
      
      if (savedPaths.isNotEmpty) {
        setState(() {
          _photoPaths.addAll(savedPaths);
        });
        _onFieldChanged();
        
        if (mounted && savedPaths.length < files.length) {
          ToastMessage.show(context, '일부 사진 저장에 실패했습니다');
        }
      } else if (mounted) {
        ToastMessage.show(context, '사진 저장에 실패했습니다');
      }
    } catch (e) {
      if (mounted) {
        ToastMessage.show(context, '사진 저장에 실패했습니다: ${e.toString()}');
      }
    }
  }

  Future<void> _removePhoto(int index) async {
    final path = _photoPaths[index];
    try {
      await File(path).delete();
    } catch (e) {
      // Ignore
    }
    setState(() {
      _photoPaths.removeAt(index);
    });
    _onFieldChanged();
  }

  Future<void> _showImagePicker() async {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text(AppStrings.camera),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text(AppStrings.gallery),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveNote() async {
    // 필수 필드 검증 (단지명은 필수)
    final apartmentNameEmpty = _apartmentNameController.text.trim().isEmpty;
    setState(() {
      _apartmentNameError = apartmentNameEmpty;
    });

    if (apartmentNameEmpty) {
      ToastMessage.show(context, '단지명은 필수 항목입니다');
      return;
    }

    final note = _createVisitNote();
    if (note == null) {
      ToastMessage.show(context, '최소한 하나의 항목을 입력해주세요');
      return;
    }

    await ref.read(visitNotesProvider.notifier).addVisitNote(note);
    if (widget.editNote == null) {
      await ref.read(visitNotesProvider.notifier).clearDraft();
    }

    if (mounted) {
      ToastMessage.show(context, AppStrings.saved);
      Navigator.pop(context);
    }
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
      _onFieldChanged();
    }
  }

  @override
  void dispose() {
    _debouncer.cancel();
    _locationController.dispose();
    _apartmentNameController.dispose();
    _buildingAgeController.dispose();
    _householdCountController.dispose();
    _areaController.dispose();
    _schoolInfoController.dispose();
    _onlinePriceController.dispose();
    _fieldPriceController.dispose();
    _salePriceController.dispose();
    _rentPriceController.dispose();
    _actualPriceController.dispose();
    _memoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.groupedBackground,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          widget.editNote != null ? '임장 수정' : AppStrings.newVisit,
          style: AppTextStyles.title3,
        ),
        backgroundColor: AppColors.groupedBackground,
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          if (_saveStatus.isNotEmpty && widget.editNote == null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Center(
                child: _saveStatus == 'saving'
                    ? SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                        ),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.check_circle,
                            size: 16,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '저장됨',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveNote,
            tooltip: '저장',
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.padding, vertical: 8),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 기본 정보 섹션
                  BasicInfoSection(
                    selectedDate: _selectedDate,
                    onDateTap: _selectDate,
                    locationController: _locationController,
                    apartmentNameController: _apartmentNameController,
                    apartmentNameError: _apartmentNameError,
                  ),
                  const SizedBox(height: AppDimensions.itemSpacing),
                  // 상세 정보 섹션
                  DetailInfoSection(
                    buildingAgeController: _buildingAgeController,
                    selectedStructure: _selectedStructure,
                    onStructureChanged: (value) {
                      setState(() {
                        _selectedStructure = value;
                      });
                    },
                    selectedDirection: _selectedDirection,
                    onDirectionChanged: (value) {
                      setState(() {
                        _selectedDirection = value;
                      });
                    },
                    hasElevator: _hasElevator,
                    onElevatorChanged: (value) {
                      setState(() {
                        _hasElevator = value;
                      });
                    },
                    selectedParkingType: _selectedParkingType,
                    onParkingTypeChanged: (value) {
                      setState(() {
                        _selectedParkingType = value;
                      });
                    },
                    householdCountController: _householdCountController,
                    areaController: _areaController,
                    schoolInfoController: _schoolInfoController,
                    onFieldChanged: _onFieldChanged,
                  ),
                  const SizedBox(height: AppDimensions.itemSpacing),
                  // 시세정보 섹션
                  PriceInfoSection(
                    onlinePriceController: _onlinePriceController,
                    fieldPriceController: _fieldPriceController,
                    salePriceController: _salePriceController,
                    rentPriceController: _rentPriceController,
                    actualPriceController: _actualPriceController,
                  ),
                  const SizedBox(height: AppDimensions.itemSpacing),
                  // 추가 정보 섹션
                  AdditionalInfoSection(
                    memoController: _memoController,
                    photoPaths: _photoPaths,
                    onAddPhoto: _showImagePicker,
                    onPhotoTap: (index) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  File(_photoPaths[index]),
                                  fit: BoxFit.contain,
                                  cacheHeight: 300,
                                  cacheWidth: 300,
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextButton(
                                onPressed: () async {
                                  final confirmed = await showDialog<bool>(
                                    context: context,
                                    builder: (deleteContext) => AlertDialog(
                                      title: const Text('사진 삭제'),
                                      content: const Text('정말 이 사진을 삭제하시겠습니까?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(deleteContext, false),
                                          child: const Text(AppStrings.cancel),
                                        ),
                                        TextButton(
                                          onPressed: () => Navigator.pop(deleteContext, true),
                                          child: const Text(
                                            AppStrings.delete,
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                  
                                  if (confirmed == true) {
                                    if (context.mounted) {
                                      Navigator.pop(context); // 이미지 보기 다이얼로그 닫기
                                      _removePhoto(index);
                                    }
                                  }
                                },
                                child: const Text(
                                  '삭제',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).viewInsets.bottom + 100,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

}

