# iOS 빌드 문제 해결 가이드

## 수행한 작업
1. ✅ Flutter clean 실행
2. ✅ 빌드 캐시 및 Pods 삭제
3. ✅ Podfile에 iOS 플랫폼 버전 추가 (13.0)
4. ✅ CocoaPods 재설치

## 다음 단계

### 옵션 1: 유선 연결 사용 (권장)
```bash
# iPhone을 USB로 연결한 후
flutter devices
# 유선 연결된 기기로 실행
flutter run -d <기기_ID>
```

### 옵션 2: 타임아웃 증가
```bash
flutter run --device-timeout 10
```

### 옵션 3: Xcode에서 직접 실행
```bash
open ios/Runner.xcworkspace
# Xcode에서 Product > Run 선택
```

### 옵션 4: 시뮬레이터 사용
```bash
flutter emulators
flutter emulators --launch <시뮬레이터_이름>
flutter run
```

## 문제가 계속되면
1. Xcode 완전 종료 후 재시작
2. DerivedData 삭제: `rm -rf ~/Library/Developer/Xcode/DerivedData`
3. iPhone 재부팅
4. 개발자 인증서 확인

