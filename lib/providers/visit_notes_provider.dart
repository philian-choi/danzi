import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/visit_note.dart';
import '../services/storage_service.dart';
import 'storage_provider.dart';

final visitNotesProvider = StateNotifierProvider<VisitNotesNotifier, VisitNotesState>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  return VisitNotesNotifier(storageService);
});

class VisitNotesState {
  final List<VisitNote> notes;
  final bool isLoading;

  VisitNotesState({
    required this.notes,
    this.isLoading = false,
  });

  VisitNotesState copyWith({
    List<VisitNote>? notes,
    bool? isLoading,
  }) {
    return VisitNotesState(
      notes: notes ?? this.notes,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class VisitNotesNotifier extends StateNotifier<VisitNotesState> {
  final StorageService _storageService;

  VisitNotesNotifier(this._storageService) 
      : super(VisitNotesState(notes: [], isLoading: true)) {
    // 비동기로 데이터 로드 (초기화는 동기적으로)
    Future.microtask(() => loadVisitNotes());
  }

  Future<void> loadVisitNotes() async {
    state = state.copyWith(isLoading: true);
    final notes = await _storageService.getAllVisitNotes();
    state = VisitNotesState(notes: notes, isLoading: false);
  }

  Future<void> addVisitNote(VisitNote note) async {
    _storageService.clearCache();
    await _storageService.saveVisitNote(note);
    await loadVisitNotes();
  }

  Future<void> updateVisitNote(VisitNote note) async {
    _storageService.clearCache();
    await _storageService.saveVisitNote(note);
    await loadVisitNotes();
  }

  Future<void> deleteVisitNote(String id) async {
    // 노트를 안전하게 찾기
    final note = state.notes.where((n) => n.id == id).firstOrNull;
    
    if (note != null) {
      // 파일 삭제는 백그라운드에서 처리
      Future.microtask(() async {
        for (final photoPath in note.photoPaths) {
          await _storageService.deletePhotoFile(photoPath);
        }
      });
    }
    
    _storageService.clearCache();
    await _storageService.deleteVisitNote(id);
    await loadVisitNotes();
  }

  Future<void> clearDraft() async {
    await _storageService.clearDraft();
  }
}

final draftProvider = FutureProvider<VisitNote?>((ref) async {
  final storageService = ref.watch(storageServiceProvider);
  return await storageService.getDraft();
});

