# iOS App Store 제출 가이드

## 현재 상태 확인

### ✅ 완료된 설정
- Info.plist 권한 설정 완료
  - NSCameraUsageDescription (카메라 권한)
  - NSPhotoLibraryUsageDescription (갤러리 권한)
  - UIUserInterfaceStyle (다크 모드 지원)
- Bundle Identifier: `com.danzi.danzi`
- Development Team: `2UFQWX8C96`
- iOS 최소 버전: 13.0
- 앱 아이콘: 모든 필수 크기 준비됨 (1024x1024 포함)
- Launch Screen: 설정됨

## 필수 작업 체크리스트

### 1. Apple Developer 계정 준비
- [ ] Apple Developer Program 멤버십 확인 ($99/년)
- [ ] https://developer.apple.com 에서 로그인 가능한지 확인

### 2. App Store Connect 설정
- [ ] https://appstoreconnect.apple.com 접속
- [ ] "나의 앱"에서 새 앱 생성
- [ ] Bundle ID 연결: `com.danzi.danzi`
- [ ] 앱 이름: "단지노트" (또는 원하는 이름)
- [ ] Primary Language: 한국어
- [ ] 카테고리 선택 (예: 생산성, 부동산 관련)

### 3. 앱 정보 입력
- [ ] 앱 설명 작성 (한국어, 최대 4000자)
- [ ] 키워드 입력 (최대 100자, 쉼표로 구분)
- [ ] 지원 URL 입력 (웹사이트 또는 지원 페이지)
- [ ] **프라이버시 정책 URL 입력 (필수)** 
  - 개인정보 처리방침 페이지 준비 필요
  - 사용자 데이터 수집/저장 정책 명시
- [ ] 마케팅 URL (선택사항)

### 4. 스크린샷 준비
필수 크기:
- [ ] iPhone 6.7" (iPhone 14 Pro Max 등) - 1290x2796px
- [ ] iPhone 6.5" (iPhone 11 Pro Max 등) - 1242x2688px  
- [ ] iPhone 5.5" (iPhone 8 Plus 등) - 1242x2208px

권장 방법:
1. 실제 디바이스나 시뮬레이터에서 앱 실행
2. 주요 화면 캡처
3. https://www.appstorescreenshot.com 같은 도구로 크기 조정
4. App Store Connect에 업로드

### 5. 빌드 및 Archive

#### 명령어로 빌드
```bash
# Flutter 빌드
flutter build ios --release

# 또는 Xcode에서 직접 Archive
```

#### Xcode에서 Archive
1. `ios/Runner.xcworkspace` 파일을 Xcode로 열기
2. 상단 바에서 "Any iOS Device" 선택
3. Product > Scheme > Edit Scheme > Run에서 Build Configuration을 "Release"로 설정
4. Product > Archive 실행
5. 빌드 완료 후 Organizer 창이 열림

### 6. Archive 검증 및 업로드
1. Organizer에서 생성된 Archive 선택
2. "Validate App" 클릭
3. 검증 통과 후 "Distribute App" 클릭
4. "App Store Connect" 선택
5. 배포 옵션 선택 (일반적으로 첫 번째 옵션)
6. 업로드 완료까지 대기 (몇 분 소요될 수 있음)

### 7. App Store Connect에서 빌드 선택
- [ ] 업로드 완료 후 App Store Connect에서 "빌드" 섹션 확인
- [ ] 새로 업로드한 빌드 선택
- [ ] "저장" 클릭

### 8. TestFlight 베타 테스트 (권장)
- [ ] TestFlight 탭으로 이동
- [ ] 내부 테스터 추가 (Apple ID 이메일)
- [ ] 외부 테스터 추가 (선택, 최대 10,000명)
- [ ] 베타 앱 리뷰 정보 입력
- [ ] 테스터에게 초대 이메일 발송
- [ ] 피드백 수집 및 버그 수정

### 9. 최종 제출 전 검토
- [ ] 모든 필수 정보 입력 완료
- [ ] 스크린샷 업로드 완료
- [ ] 빌드 선택 완료
- [ ] 버전 정보 확인 (1.0.0)
- [ ] Export Compliance 질문 답변
  - 암호화 사용 여부: 일반적으로 "아니오" 또는 "예, 하지만 App Store 규칙 준수"
- [ ] Content Rights 확인
  - 타사 콘텐츠 사용 시 라이선스 확인

### 10. 제출
- [ ] "검토를 위해 제출" 버튼 클릭
- [ ] 최종 확인사항 체크
- [ ] 제출 완료

### 11. 검토 대기
- [ ] 상태: "검토 중"으로 변경됨 (보통 1-3일)
- [ ] 승인 또는 거부 통보 대기
- [ ] 거부 시 피드백 검토 및 수정 후 재제출

## 유용한 리소스

- [Apple App Store 리뷰 가이드라인](https://developer.apple.com/app-store/review/guidelines/)
- [App Store Connect 도움말](https://help.apple.com/app-store-connect/)
- [Flutter iOS 배포 가이드](https://docs.flutter.dev/deployment/ios)

## 문제 해결

### 빌드 오류
- Xcode 최신 버전 사용 확인
- `pod install` 실행: `cd ios && pod install`
- Flutter 캐시 정리: `flutter clean`

### Archive 실패
- Signing & Capabilities에서 Team 확인
- Bundle Identifier가 App Store Connect에 등록되어 있는지 확인
- 인증서 및 프로비저닝 프로파일 확인

### 업로드 실패
- 네트워크 연결 확인
- Xcode의 Organizer에서 에러 메시지 확인
- App Store Connect의 상태 확인

## 중요 참고사항

1. **프라이버시 정책**: App Store 정책상 프라이버시 정책 URL이 필수입니다. 웹사이트나 GitHub Pages에 호스팅할 수 있습니다.

2. **첫 제출**: 첫 제출은 보통 1-3일 정도 소요됩니다.

3. **버전 관리**: 이후 업데이트는 `pubspec.yaml`의 버전을 증가시켜야 합니다.
   - 예: 1.0.0+1 → 1.0.1+2 (버전+빌드번호)

4. **TestFlight**: 베타 테스트를 통해 실제 사용자 피드백을 받는 것을 강력히 권장합니다.

