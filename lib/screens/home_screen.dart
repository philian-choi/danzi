import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/visit_note.dart';
import '../providers/visit_notes_provider.dart';
import '../utils/constants.dart';
import '../utils/debouncer.dart';
import '../widgets/visit_card.dart';
import 'create_visit_screen.dart';
import 'detail_visit_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

enum SortOption {
  dateNewest,
  dateOldest,
  apartmentName,
  priceHigh,
  priceLow,
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;
  bool _isSearchMode = false;
  final TextEditingController _searchController = TextEditingController();
  SortOption _sortOption = SortOption.dateNewest;
  String _debouncedSearchQuery = '';
  final Debouncer _searchDebouncer = Debouncer(delay: const Duration(milliseconds: 400));

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchDebouncer.cancel();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _searchDebouncer.run(() {
      if (mounted) {
        setState(() {
          _debouncedSearchQuery = _searchController.text.toLowerCase().trim();
          // 검색어가 비어지고 검색 모드일 때는 검색 모드 유지 (사용자가 명시적으로 종료할 때까지)
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.groupedBackground,
      appBar: AppBar(
        title: _isSearchMode && _selectedIndex == 0
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: AppTextStyles.body,
                decoration: InputDecoration(
                  hintText: '단지명, 소재지, 메모 검색...',
                  hintStyle: AppTextStyles.body.copyWith(
                    color: AppColors.tertiaryText,
                  ),
                  border: InputBorder.none,
                ),
                onChanged: (_) {
                  // Debounce는 리스너에서 처리
                },
              )
            : Text(
                _selectedIndex == 0 ? AppStrings.appName : AppStrings.settings,
                style: _selectedIndex == 0
                    ? AppTextStyles.largeTitle.copyWith(fontSize: 28)
                    : AppTextStyles.title3,
              ),
        actions: _selectedIndex == 0
            ? [
                if (!_isSearchMode)
                  IconButton(
                    icon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.sort),
                        const SizedBox(width: 4),
                        Text(
                          _getSortLabel(_sortOption),
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    onPressed: () => _showSortDialog(),
                    tooltip: '정렬: ${_getSortLabel(_sortOption)}',
                  ),
                if (_isSearchMode)
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        _isSearchMode = false;
                        _searchController.clear();
                      });
                    },
                  )
                else
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      setState(() {
                        _isSearchMode = true;
                      });
                    },
                  ),
              ]
            : null,
        backgroundColor: AppColors.groupedBackground,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildHomeBody(),
          _buildPlaceholder(), // 생성 버튼은 Navigator.push로 처리
          _buildSettingsBody(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildHomeBody() {
    final visitNotesState = ref.watch(visitNotesProvider);
    final visitNotes = visitNotesState.notes;
    
    // 로딩 중인 경우
    if (visitNotesState.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    
    // Debounced 검색어로 필터링
    final searchQuery = _debouncedSearchQuery;
    var filteredNotes = searchQuery.isEmpty
        ? List<VisitNote>.from(visitNotes)
        : visitNotes.where((note) {
            return note.apartmentName.toLowerCase().contains(searchQuery) ||
                note.location.toLowerCase().contains(searchQuery) ||
                note.memo.toLowerCase().contains(searchQuery);
          }).toList();

    // 정렬 적용
    filteredNotes = _sortNotes(filteredNotes);

    // 검색 결과가 없고 검색어가 있는 경우
    if (filteredNotes.isEmpty && visitNotes.isNotEmpty && searchQuery.isNotEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.padding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.search_off,
                size: 64,
                color: AppColors.tertiaryText,
              ),
              const SizedBox(height: 16),
              Text(
                '검색 결과가 없습니다',
                style: AppTextStyles.title3.copyWith(
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '다른 검색어를 시도해보세요',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.tertiaryText,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    if (filteredNotes.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.padding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.folder_outlined,
                size: 80,
                color: AppColors.tertiaryText,
              ),
              const SizedBox(height: 24),
              Text(
                '임장 기록이 없습니다',
                style: AppTextStyles.title3.copyWith(
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '첫 임장 기록을 작성해보세요',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.tertiaryText,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CreateVisitScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.add_circle_outline),
                label: const Text('첫 임장 작성하기'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.only(
            top: 8,
            left: AppDimensions.padding,
            right: AppDimensions.padding,
            bottom: AppDimensions.padding,
          ),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final note = filteredNotes[index];
                return VisitCard(
                  key: ValueKey(note.id),
                  visitNote: note,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailVisitScreen(visitNoteId: note.id),
                      ),
                    );
                  },
                  onDelete: () async {
                    await ref.read(visitNotesProvider.notifier).deleteVisitNote(note.id);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(AppStrings.deleted),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                );
              },
              childCount: filteredNotes.length,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholder() {
    return const SizedBox.shrink();
  }

  Widget _buildSettingsBody() {
    return const SettingsScreenBody();
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppColors.separator,
            width: 0.5,
          ),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CreateVisitScreen(),
              ),
            );
          } else {
            setState(() {
              _selectedIndex = index;
            });
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: AppStrings.home,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            activeIcon: Icon(Icons.add_circle),
            label: AppStrings.create,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: AppStrings.settings,
          ),
        ],
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.tertiaryText,
        backgroundColor: AppColors.cardBackground,
        elevation: 0,
        selectedFontSize: 13,
        unselectedFontSize: 13,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  List<VisitNote> _sortNotes(List<VisitNote> notes) {
    final sorted = List<VisitNote>.from(notes);
    
    switch (_sortOption) {
      case SortOption.dateNewest:
        sorted.sort((a, b) => b.timestamp.compareTo(a.timestamp));
        break;
      case SortOption.dateOldest:
        sorted.sort((a, b) => a.timestamp.compareTo(b.timestamp));
        break;
      case SortOption.apartmentName:
        sorted.sort((a, b) => a.apartmentName.compareTo(b.apartmentName));
        break;
      case SortOption.priceHigh:
        sorted.sort((a, b) {
          final priceA = a.actualPrice ?? a.salePrice ?? a.onlinePrice ?? 0;
          final priceB = b.actualPrice ?? b.salePrice ?? b.onlinePrice ?? 0;
          return priceB.compareTo(priceA);
        });
        break;
      case SortOption.priceLow:
        sorted.sort((a, b) {
          final priceA = a.actualPrice ?? a.salePrice ?? a.onlinePrice ?? 0;
          final priceB = b.actualPrice ?? b.salePrice ?? b.onlinePrice ?? 0;
          return priceA.compareTo(priceB);
        });
        break;
    }
    
    return sorted;
  }

  Future<void> _showSortDialog() async {
    final result = await showDialog<SortOption>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('정렬 옵션'),
        content: StatefulBuilder(
          builder: (context, setDialogState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<SortOption>(
                  title: const Text('날짜 (최신순)'),
                  value: SortOption.dateNewest,
                  groupValue: _sortOption,
                  secondary: _sortOption == SortOption.dateNewest
                      ? const Icon(Icons.check, color: AppColors.primary)
                      : null,
                  onChanged: (value) {
                    if (value != null) {
                      setDialogState(() {
                        _sortOption = value;
                      });
                      Navigator.pop(context, value);
                    }
                  },
                ),
                RadioListTile<SortOption>(
                  title: const Text('날짜 (오래된순)'),
                  value: SortOption.dateOldest,
                  groupValue: _sortOption,
                  secondary: _sortOption == SortOption.dateOldest
                      ? const Icon(Icons.check, color: AppColors.primary)
                      : null,
                  onChanged: (value) {
                    if (value != null) {
                      setDialogState(() {
                        _sortOption = value;
                      });
                      Navigator.pop(context, value);
                    }
                  },
                ),
                RadioListTile<SortOption>(
                  title: const Text('단지명'),
                  value: SortOption.apartmentName,
                  groupValue: _sortOption,
                  secondary: _sortOption == SortOption.apartmentName
                      ? const Icon(Icons.check, color: AppColors.primary)
                      : null,
                  onChanged: (value) {
                    if (value != null) {
                      setDialogState(() {
                        _sortOption = value;
                      });
                      Navigator.pop(context, value);
                    }
                  },
                ),
                RadioListTile<SortOption>(
                  title: const Text('시세 (높은순)'),
                  value: SortOption.priceHigh,
                  groupValue: _sortOption,
                  secondary: _sortOption == SortOption.priceHigh
                      ? const Icon(Icons.check, color: AppColors.primary)
                      : null,
                  onChanged: (value) {
                    if (value != null) {
                      setDialogState(() {
                        _sortOption = value;
                      });
                      Navigator.pop(context, value);
                    }
                  },
                ),
                RadioListTile<SortOption>(
                  title: const Text('시세 (낮은순)'),
                  value: SortOption.priceLow,
                  groupValue: _sortOption,
                  secondary: _sortOption == SortOption.priceLow
                      ? const Icon(Icons.check, color: AppColors.primary)
                      : null,
                  onChanged: (value) {
                    if (value != null) {
                      setDialogState(() {
                        _sortOption = value;
                      });
                      Navigator.pop(context, value);
                    }
                  },
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppStrings.cancel),
          ),
        ],
      ),
    );

    if (result != null) {
      setState(() {
        _sortOption = result;
      });
    }
  }

  String _getSortLabel(SortOption option) {
    switch (option) {
      case SortOption.dateNewest:
        return '최신순';
      case SortOption.dateOldest:
        return '오래된순';
      case SortOption.apartmentName:
        return '단지명';
      case SortOption.priceHigh:
        return '가격높은순';
      case SortOption.priceLow:
        return '가격낮은순';
    }
  }
}
