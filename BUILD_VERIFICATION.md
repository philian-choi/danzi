# 빌드 설정 검증 가이드

이 문서는 App Store 제출을 위한 빌드 설정 검증 체크리스트입니다.

## 확인된 설정

### ✅ Debug 모드 설정
- `lib/main.dart`에서 `debugShowCheckedModeBanner: false` 설정 확인됨
- Release 빌드 시 자동으로 Debug 배너가 표시되지 않음

### ✅ Info.plist 권한 설정
- `NSCameraUsageDescription`: 설정됨
- `NSPhotoLibraryUsageDescription`: 설정됨
- `UIUserInterfaceStyle`: 설정됨 (다크 모드 지원)

### ✅ Privacy Manifest
- `ios/Runner/PrivacyInfo.xcprivacy`: 생성 완료
- 트래킹 선언: false
- API 사용 선언: File timestamp APIs

## Xcode에서 확인해야 할 설정

### 1. 프로젝트 설정 열기
```bash
open ios/Runner.xcworkspace
```

### 2. Target 설정 확인

#### General 탭
- [ ] **Bundle Identifier**: `com.danzi.danzi` (App Store Connect와 일치해야 함)
- [ ] **Version**: `1.0.0` (pubspec.yaml의 version과 일치)
- [ ] **Build**: `1` (또는 적절한 번호)
- [ ] **Display Name**: `단지노트`
- [ ] **Deployment Target**: `13.0` 이상 (권장: 13.0)

#### Signing & Capabilities 탭
- [ ] **Automatically manage signing**: 체크됨 (또는 수동 서명)
- [ ] **Team**: Apple Developer Program 멤버십이 있는 Team 선택
  - 예: `2UFQWX8C96` (APP_STORE_SUBMISSION.md에 명시된 Team)
- [ ] **Bundle Identifier**: `com.danzi.danzi`
- [ ] **Provisioning Profile**: 자동 또는 수동으로 설정

#### Build Settings 탭
- [ ] **iOS Deployment Target**: `13.0` 이상 확인
- [ ] **Code Signing Identity**: 
  - Debug: `Apple Development`
  - Release: `Apple Distribution`
- [ ] **Product Bundle Identifier**: `com.danzi.danzi`

### 3. Scheme 설정 확인

#### Run Scheme (Debug)
- [ ] **Build Configuration**: Debug
- [ ] **Run**: Debug 설정 사용

#### Archive Scheme (Release)
- [ ] **Build Configuration**: Release
- [ ] Product > Scheme > Edit Scheme에서:
  - Run > Build Configuration: Release
  - Archive > Build Configuration: Release

## 빌드 검증 단계

### 1단계: Flutter 빌드 확인
```bash
# 프로젝트 루트에서
flutter clean
flutter pub get
flutter build ios --release
```

**확인 사항:**
- [ ] 빌드 오류 없음
- [ ] 경고 메시지 확인 (치명적이지 않은 경우 무시 가능)

### 2단계: Xcode Archive 생성

1. Xcode에서 `ios/Runner.xcworkspace` 열기
2. 상단 바에서 "Any iOS Device" 또는 실제 디바이스 선택
3. Product > Scheme > Edit Scheme:
   - Run > Build Configuration: Release로 변경
4. Product > Archive 실행

**확인 사항:**
- [ ] Archive 생성 성공
- [ ] 오류 없음

### 3단계: Archive 검증

1. Organizer 창에서 생성된 Archive 선택
2. "Validate App" 클릭
3. 다음 정보 입력:
   - **Team**: 선택
   - **Automatically manage signing**: 체크
4. "Next" 클릭 후 검증 진행

**확인 사항:**
- [ ] 검증 성공
- [ ] 경고 확인 (치명적이지 않은 경우 무시 가능)

### 4단계: 일반적인 문제 해결

#### Code Signing 오류
- Xcode > Preferences > Accounts에서 Apple ID 로그인 확인
- Team이 올바르게 선택되어 있는지 확인
- Bundle Identifier가 App Store Connect에 등록되어 있는지 확인

#### Provisioning Profile 오류
- Xcode에서 "Automatically manage signing" 사용 권장
- 수동 관리 시 App Store Distribution 프로파일 필요

#### Archive 실패
- `pod install` 실행: `cd ios && pod install`
- Flutter 캐시 정리: `flutter clean && flutter pub get`
- Xcode 캐시 정리: Xcode > Product > Clean Build Folder

## Release 빌드 체크리스트

Archive 생성 전 다음을 확인하세요:

### 코드 레벨
- [ ] `debugShowCheckedModeBanner: false` 설정 (이미 완료)
- [ ] 하드코딩된 API 키 또는 민감 정보 없음
- [ ] 테스트용 더미 데이터 제거

### 설정 레벨
- [ ] Info.plist 모든 필수 키 설정 완료
- [ ] PrivacyInfo.xcprivacy 파일 존재
- [ ] Bundle Identifier 확인
- [ ] Version 번호 확인

### Xcode 레벨
- [ ] Release 빌드 설정으로 Archive
- [ ] Code Signing 설정 확인
- [ ] Deployment Target 확인

## App Store Connect 업로드

### 업로드 방법
1. Organizer에서 Archive 선택
2. "Distribute App" 클릭
3. "App Store Connect" 선택
4. 업로드 옵션 선택 (일반적으로 첫 번째 옵션)
5. 업로드 완료까지 대기 (몇 분 소요 가능)

### 업로드 후 확인
- [ ] App Store Connect에서 빌드가 나타나는지 확인 (최대 1시간 소요)
- [ ] 빌드 상태가 "Processing" 또는 "Ready to Submit"인지 확인

## 최종 체크리스트

제출 전 다음 항목을 모두 확인하세요:

### 필수 파일
- [ ] PrivacyInfo.xcprivacy 파일 존재
- [ ] Info.plist 권한 설명 완료
- [ ] 모든 설정 파일 정상

### 빌드 설정
- [ ] Release 빌드로 Archive 생성
- [ ] 검증 통과
- [ ] 업로드 완료

### App Store Connect
- [ ] 빌드 선택 완료
- [ ] 모든 필수 정보 입력 완료
- [ ] 프라이버시 정책 URL 입력 완료
- [ ] App Privacy 선언 완료

---

**참고**: 
- Bundle Identifier는 `com.danzi.danzi`로 설정되어 있습니다.
- Development Team은 `2UFQWX8C96`입니다 (APP_STORE_SUBMISSION.md 참고).
- iOS 최소 버전은 13.0입니다.

