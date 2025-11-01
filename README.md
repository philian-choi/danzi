# 단지노트 (Danzi Note)

부동산 임장 기록을 관리하는 오프라인 전용 Flutter 앱입니다. 현장에서 아파트 정보를 기록하고 사진을 첨부하여 관리할 수 있습니다.

## 프로젝트 개요

이 앱은 부동산 중개업무 중 임장(현장 방문) 시 수집한 정보를 체계적으로 기록하고 관리하기 위한 도구입니다.

### 주요 특징

- ✅ **100% 오프라인 동작** - 인터넷 연결 없이 완전히 작동
- 📸 **사진 다중 선택** - 갤러리에서 여러 장의 사진을 한 번에 선택 가능
- 💾 **자동 저장** - 입력 중인 내용이 3초마다 자동으로 드래프트 저장
- 🔍 **검색 및 정렬** - 단지명, 소재지, 메모로 검색 및 다양한 기준으로 정렬
- 📤 **데이터 백업/복원** - JSON 형식으로 데이터 내보내기 및 복원
- 🎨 **iOS 스타일 디자인** - 일관된 iOS 디자인 시스템 적용

## 기술 스택

- **Framework**: Flutter (SDK >=3.0.0 <4.0.0)
- **상태 관리**: Flutter Riverpod 2.5.1
- **로컬 저장소**: SharedPreferences
- **이미지 처리**: image_picker 1.0.7
- **파일 관리**: file_picker 6.1.1, path_provider 2.1.2
- **공유 기능**: share_plus 7.2.2
- **국제화**: intl 0.19.0

## 프로젝트 구조

```
lib/
├── main.dart                    # 앱 진입점 및 테마 설정
├── models/
│   └── visit_note.dart          # VisitNote 데이터 모델
├── providers/
│   └── visit_notes_provider.dart # 상태 관리 (Riverpod)
├── screens/
│   ├── home_screen.dart          # 홈 화면 (목록, 검색, 정렬)
│   ├── create_visit_screen.dart  # 임장 기록 작성/수정
│   ├── detail_visit_screen.dart  # 임장 기록 상세 보기
│   └── settings_screen.dart      # 설정 화면 (백업/복원)
├── services/
│   └── storage_service.dart      # 로컬 저장소 서비스
├── utils/
│   ├── constants.dart            # 상수 정의 (색상, 스타일, 문자열)
│   ├── date_formatter.dart       # 날짜 포맷팅 유틸리티
│   ├── debouncer.dart            # 디바운싱 유틸리티
│   └── price_formatter.dart      # 가격 입력 포맷터 (천단위 구분자)
└── widgets/
    ├── custom_text_field.dart    # 커스텀 텍스트 필드
    ├── visit_card.dart           # 임장 기록 카드
    ├── photo_grid.dart           # 사진 그리드
    └── toast_message.dart        # 토스트 메시지
```

## 설치 및 실행

### 사전 요구사항

- Flutter SDK 3.0.0 이상
- Android Studio / Xcode (플랫폼별)
- iOS 시뮬레이터 또는 Android 에뮬레이터

### 설치

```bash
# 의존성 설치
flutter pub get

# iOS (macOS만)
cd ios && pod install && cd ..

# 실행
flutter run
```

### 빌드

```bash
# iOS
flutter build ios

# Android
flutter build apk
# 또는
flutter build appbundle
```

## 아키텍처 및 상태 관리

### 상태 관리 패턴

이 앱은 **Flutter Riverpod**을 사용하여 상태를 관리합니다.

#### Provider 구조

```dart
// Provider 정의 위치: lib/providers/visit_notes_provider.dart

// 1. 저장소 서비스 Provider
final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});

// 2. 메인 상태 Provider (StateNotifier)
final visitNotesProvider = StateNotifierProvider<VisitNotesNotifier, VisitNotesState>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  return VisitNotesNotifier(storageService);
});

// 3. 드래프트 Provider (FutureProvider)
final draftProvider = FutureProvider<VisitNote?>((ref) async {
  final storageService = ref.watch(storageServiceProvider);
  return await storageService.getDraft();
});
```

#### 상태 모델

```dart
class VisitNotesState {
  final List<VisitNote> notes;      // 임장 기록 목록
  final bool isLoading;              // 로딩 상태
  
  VisitNotesState({required this.notes, this.isLoading = false});
}
```

### 데이터 흐름

1. **읽기**: `ref.watch(visitNotesProvider)` - UI가 상태 변화를 자동으로 감지
2. **쓰기**: `ref.read(visitNotesProvider.notifier).addVisitNote(note)` - 상태 변경
3. **영구 저장**: `StorageService`가 `SharedPreferences`에 JSON 형식으로 저장

### 저장 구조

- **임장 기록**: `SharedPreferences`의 `visit_notes` 키에 JSON 배열로 저장
- **드래프트**: `draft_visit_note` 키에 임시 저장
- **사진 파일**: `path_provider`로 얻은 앱 문서 디렉토리에 저장

## 주요 기능 상세

### 1. 임장 기록 작성 (`CreateVisitScreen`)

**주요 필드:**
- 기본 정보: 날짜, 소재지, 단지명, 연식
- 건물 정보: 구조, 향, 엘리베이터, 주차장, 세대수, 평형
- 시세 정보: 온라인 시세, 현장 시세, 매매가, 전월세가, 실거래가
- 기타: 학교정보, 메모, 사진

**특징:**
- 자동 저장: 입력 후 3초 디바운스로 드래프트 자동 저장
- 시세 입력 포맷팅: 천단위 구분자 자동 추가 (예: 500,000,000)
- 사진 다중 선택: 갤러리에서 여러 장 동시 선택 가능
- 저장 상태 표시: AppBar에 저장 중/저장됨 인디케이터 표시

### 2. 홈 화면 (`HomeScreen`)

**기능:**
- 임장 기록 목록 표시
- 검색: 단지명, 소재지, 메모에서 키워드 검색
- 정렬: 날짜(최신/오래된순), 단지명, 시세(높은/낮은순)
- 스와이프 삭제: 왼쪽으로 스와이프하여 삭제 (확인 다이얼로그 포함)

**네비게이션:**
- 하단 탭: 홈, 작성, 설정
- 탭 전환 시 페이지 전환 효과 없이 IndexedStack으로 즉시 전환

### 3. 상세 화면 (`DetailVisitScreen`)

**기능:**
- 임장 기록의 모든 정보 표시
- 사진 갤러리 (확대 보기 지원)
- 수정 버튼: `CreateVisitScreen`으로 이동하여 수정
- 삭제 버튼: 확인 후 삭제

### 4. 설정 화면 (`SettingsScreen`)

**기능:**
- 데이터 백업: JSON 형식으로 데이터 내보내기 (share_plus 사용)
- 데이터 복원: JSON 파일 선택하여 복원 (file_picker 사용)

## 데이터 모델

### VisitNote

```dart
class VisitNote {
  final String id;                  // UUID
  final DateTime date;              // 임장 날짜
  final String location;            // 소재지
  final String apartmentName;      // 단지명
  final int? buildingAge;           // 연식 (년)
  final String? direction;         // 향 (남향, 남동향 등)
  final String? structure;          // 구조 (복도식, 계단식 등)
  final bool? hasElevator;          // 엘리베이터 (true/false/null)
  final String? parkingType;       // 주차장 (지상/지하/혼합)
  final int? householdCount;       // 세대수
  final double? area;              // 해당평형 (㎡)
  final String? schoolInfo;        // 학교정보
  final int? onlinePrice;          // 온라인 시세 (원)
  final int? fieldPrice;           // 현장 시세 (원)
  final int? salePrice;            // 매매가 (원)
  final int? rentPrice;            // 전월세가 (원)
  final int? actualPrice;          // 실거래가 (원)
  final String memo;               // 메모
  final List<String> photoPaths;   // 사진 파일 경로 목록
  final int timestamp;             // 생성/수정 타임스탬프
}
```

### JSON 직렬화

- `toJson()`: VisitNote → Map<String, dynamic>
- `fromJson()`: Map<String, dynamic> → VisitNote
- 에러 처리: 개별 노트 파싱 실패 시 건너뛰기

## 주요 파일 설명

### `lib/main.dart`

앱의 진입점으로 다음을 설정:
- Riverpod ProviderScope
- MaterialApp 테마 (iOS 스타일)
- 로컬화 설정 (한국어)

### `lib/services/storage_service.dart`

로컬 데이터 저장소 관리:
- `saveVisitNote()`: 임장 기록 저장
- `getAllVisitNotes()`: 모든 기록 조회 (캐시 사용)
- `deleteVisitNote()`: 기록 삭제
- `exportData()` / `importData()`: 백업/복원
- `saveDraft()` / `getDraft()`: 드래프트 관리

**주의사항:**
- `clearCache()`를 호출하여 캐시를 초기화해야 변경사항이 반영됨

### `lib/providers/visit_notes_provider.dart`

상태 관리 로직:
- `VisitNotesNotifier`: 임장 기록 목록 상태 관리
- `loadVisitNotes()`: 저장소에서 데이터 로드
- `addVisitNote()` / `updateVisitNote()`: 기록 추가/수정
- `deleteVisitNote()`: 기록 삭제 (사진 파일도 함께 삭제)

### `lib/utils/price_formatter.dart`

시세 입력 필드 포맷터:
- `PriceInputFormatter`: 천단위 구분자 자동 추가
- `PriceInputFormatter.formatNumber()`: 숫자 → 포맷된 문자열
- `PriceInputFormatter.removeCommas()`: 포맷된 문자열 → 숫자

### `lib/utils/constants.dart`

앱 전역 상수 정의:
- `AppColors`: 색상 팔레트 (iOS 스타일)
- `AppTextStyles`: 텍스트 스타일 (iOS 타이포그래피)
- `AppDimensions`: 간격 및 크기 상수
- `AppStrings`: 문자열 리소스
- `StructureOptions` / `DirectionOptions` / `ParkingOptions`: 선택 옵션

## 개발 가이드

### 새로운 필드 추가하기

1. **모델 수정** (`lib/models/visit_note.dart`)
   ```dart
   final String? newField;
   
   // 생성자에 추가
   // toJson()에 추가
   // fromJson()에 추가
   // copyWith()에 추가
   ```

2. **UI 수정** (`lib/screens/create_visit_screen.dart`)
   - Controller 추가
   - initState에서 초기화
   - Form에 필드 추가
   - `_createVisitNote()`에서 값 할당

3. **상세 화면 수정** (`lib/screens/detail_visit_screen.dart`)
   - 표시 로직 추가

### 새로운 화면 추가하기

1. `lib/screens/`에 새 파일 생성
2. `ConsumerWidget` 또는 `ConsumerStatefulWidget` 사용
3. 필요 시 `visitNotesProvider` 사용하여 데이터 접근

### 스타일 가이드

- **색상**: `AppColors` 클래스 사용
- **텍스트 스타일**: `AppTextStyles` 클래스 사용
- **간격**: `AppDimensions` 상수 사용
- **문자열**: `AppStrings` 상수 사용 (다국어 지원 고려)

### 에러 처리 패턴

```dart
try {
  // 작업 수행
} catch (e) {
  if (mounted) {
    ToastMessage.show(context, '에러 메시지: ${e.toString()}');
  }
}
```

### 비동기 작업

```dart
// mounted 체크 필수
if (mounted) {
  // UI 업데이트
}
```

## 주의사항 및 트러블슈팅

### 데이터 동기화

- `StorageService`는 내부 캐시를 사용하므로, 데이터 변경 후 `clearCache()` 호출 필요
- `VisitNotesNotifier`의 메서드들은 자동으로 캐시를 초기화함

### 사진 저장

- 사진은 앱 문서 디렉토리에 저장되며, 기록 삭제 시 함께 삭제됨
- 파일 경로는 절대 경로로 저장됨 (상대 경로 사용 불가)

### 성능 고려사항

- 대량의 사진이 있는 경우 메모리 사용량 주의
- `PhotoGrid`는 썸네일을 위해 `cacheWidth: 300` 사용
- 리스트는 `SliverList`를 사용하여 스크롤 성능 최적화

### 플랫폼별 이슈

**iOS:**
- `Info.plist`에 카메라 및 사진 라이브러리 권한 설정 필요:
  ```xml
  <key>NSCameraUsageDescription</key>
  <string>임장 기록에 사진을 첨부하기 위해 카메라 접근이 필요합니다</string>
  <key>NSPhotoLibraryUsageDescription</key>
  <string>임장 기록에 사진을 첨부하기 위해 사진 라이브러리 접근이 필요합니다</string>
  ```

**Android:**
- `AndroidManifest.xml`에 권한 설정 필요:
  ```xml
  <uses-permission android:name="android.permission.CAMERA" />
  <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
  ```

## 테스트

```bash
# 단위 테스트
flutter test

# 위젯 테스트 (현재 기본 테스트만 존재)
flutter test test/widget_test.dart
```

## 향후 개선 가능 사항

- [ ] 필터 기능 추가 (날짜 범위, 시세 범위)
- [ ] 다국어 지원 (i18n)
- [ ] 다크 모드 지원
- [ ] 데이터 통계 및 차트
- [ ] 클라우드 백업 연동
- [ ] 검색 결과 하이라이트

## 라이선스

이 프로젝트는 회사 내부 사용을 위한 것으로 라이선스 정보는 별도로 확인하세요.

---

**문의**: 프로젝트 관련 질문은 팀 리드에게 문의하세요.
