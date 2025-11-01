import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/visit_note.dart';
import '../utils/error_handler.dart';

class StorageService {
  static const String _visitNotesKey = 'visit_notes';
  static const String _draftKey = 'draft_visit_note';
  
  SharedPreferences? _prefs;
  List<VisitNote>? _cachedNotes;
  
  Future<SharedPreferences> get _preferences async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  Future<void> saveVisitNote(VisitNote note) async {
    final prefs = await _preferences;
    final notes = await getAllVisitNotes();
    final existingIndex = notes.indexWhere((n) => n.id == note.id);

    if (existingIndex >= 0) {
      notes[existingIndex] = note;
    } else {
      notes.add(note);
    }

    notes.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    _cachedNotes = notes; // 캐시 업데이트

    final jsonList = notes.map((n) => n.toJson()).toList();
    await prefs.setString(_visitNotesKey, jsonEncode(jsonList));
  }

  Future<List<VisitNote>> getAllVisitNotes() async {
    if (_cachedNotes != null) {
      return _cachedNotes!;
    }
    
    final prefs = await _preferences;
    final jsonString = prefs.getString(_visitNotesKey);

    if (jsonString == null || jsonString.isEmpty) {
      _cachedNotes = [];
      return [];
    }

    try {
      final jsonList = jsonDecode(jsonString) as List;
      final notes = <VisitNote>[];
      for (final item in jsonList) {
        try {
          notes.add(VisitNote.fromJson(item as Map<String, dynamic>));
        } catch (e) {
          ErrorHandler.handleError(null, e, logError: true, userMessage: null);
          // 개별 노트 파싱 실패 시 건너뛰기
        }
      }
      notes.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      _cachedNotes = notes;
      return notes;
    } catch (e) {
      ErrorHandler.handleParseError(null, e, dataType: '임장 기록');
      _cachedNotes = [];
      return [];
    }
  }
  
  void clearCache() {
    _cachedNotes = null;
  }

  Future<void> deleteVisitNote(String id) async {
    final prefs = await _preferences;
    final notes = await getAllVisitNotes();
    notes.removeWhere((note) => note.id == id);
    _cachedNotes = notes; // 캐시 업데이트

    final jsonList = notes.map((n) => n.toJson()).toList();
    await prefs.setString(_visitNotesKey, jsonEncode(jsonList));
  }

  Future<VisitNote?> getDraft() async {
    final prefs = await _preferences;
    final jsonString = prefs.getString(_draftKey);

    if (jsonString == null || jsonString.isEmpty) {
      return null;
    }

    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return VisitNote.fromJson(json);
    } catch (e) {
      ErrorHandler.handleParseError(null, e, dataType: '드래프트');
      return null;
    }
  }

  Future<void> saveDraft(VisitNote note) async {
    final prefs = await _preferences;
    await prefs.setString(_draftKey, jsonEncode(note.toJson()));
  }

  Future<void> clearDraft() async {
    final prefs = await _preferences;
    await prefs.remove(_draftKey);
  }

  Future<String> exportData() async {
    final notes = await getAllVisitNotes();
    final jsonList = notes.map((n) => n.toJson()).toList();
    return jsonEncode(jsonList);
  }

  Future<bool> importData(String jsonString) async {
    try {
      final jsonList = jsonDecode(jsonString) as List;
      final notes = jsonList
          .map((json) => VisitNote.fromJson(json as Map<String, dynamic>))
          .toList();

      final prefs = await _preferences;
      _cachedNotes = notes; // 캐시 업데이트
      await prefs.setString(_visitNotesKey, jsonEncode(notes.map((n) => n.toJson()).toList()));
      return true;
    } catch (e) {
      ErrorHandler.handleParseError(null, e, dataType: '임포트 데이터');
      return false;
    }
  }

  Future<void> deletePhotoFile(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      // Ignore deletion errors
    }
  }
}

