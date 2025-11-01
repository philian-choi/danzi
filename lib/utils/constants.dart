import 'package:flutter/material.dart';

class AppColors {
  // iOS 스타일 색상 팔레트
  static const Color background = Color(0xFFF2F2F7); // iOS System Gray 6
  static const Color text = Color(0xFF000000); // iOS Label
  static const Color secondaryText = Color(0xFF3C3C43); // iOS Secondary Label (60% opacity)
  static const Color tertiaryText = Color(0xFF8E8E93); // iOS Tertiary Label (30% opacity)
  static const Color primary = Color(0xFF007AFF); // iOS Blue
  static const Color cardBackground = Colors.white;
  static const Color separator = Color(0xFFC6C6C8); // iOS Separator
  static const Color groupedBackground = Color(0xFFF2F2F7);
}

class AppTextStyles {
  // iOS 타이포그래피 스타일
  static const TextStyle largeTitle = TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.bold,
    color: AppColors.text,
    letterSpacing: 0.37,
    height: 1.2,
  );

  static const TextStyle title1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.text,
    letterSpacing: 0.36,
    height: 1.2,
  );

  static const TextStyle title2 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.text,
    letterSpacing: 0.35,
    height: 1.3,
  );

  static const TextStyle title3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.text,
    letterSpacing: 0.38,
    height: 1.3,
  );

  static const TextStyle headline = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    color: AppColors.text,
    letterSpacing: -0.41,
    height: 1.3,
  );

  static const TextStyle body = TextStyle(
    fontSize: 17,
    color: AppColors.text,
    letterSpacing: -0.41,
    height: 1.4,
  );

  static const TextStyle callout = TextStyle(
    fontSize: 16,
    color: AppColors.text,
    letterSpacing: -0.32,
    height: 1.4,
  );

  static const TextStyle subheadline = TextStyle(
    fontSize: 15,
    color: AppColors.secondaryText,
    letterSpacing: -0.24,
    height: 1.4,
  );

  static const TextStyle footnote = TextStyle(
    fontSize: 13,
    color: AppColors.secondaryText,
    letterSpacing: -0.08,
    height: 1.4,
  );

  static const TextStyle caption1 = TextStyle(
    fontSize: 12,
    color: AppColors.tertiaryText,
    letterSpacing: 0,
    height: 1.3,
  );

  static const TextStyle caption2 = TextStyle(
    fontSize: 11,
    color: AppColors.tertiaryText,
    letterSpacing: 0.07,
    height: 1.3,
  );

  // Legacy 호환성
  static const TextStyle title = title2;
  static const TextStyle bodySmall = subheadline;
  static const TextStyle caption = footnote;

  static const TextStyle button = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: -0.41,
  );
}

class AppDimensions {
  // iOS 스타일 간격
  static const double padding = 20.0;
  static const double cardPadding = 16.0;
  static const double borderRadius = 10.0; // iOS 표준
  static const double cardElevation = 0.0;
  static const double sectionSpacing = 32.0;
  static const double itemSpacing = 16.0;
  static const double touchTargetMinSize = 44.0; // iOS 최소 터치 타겟
}

class AppStrings {
  static const String appName = '임장노트';
  static const String noRecords = '기록이 없습니다';
  static const String newVisit = '새 임장 작성';
  static const String location = '소재지';
  static const String apartmentName = '단지명';
  static const String buildingAge = '연식';
  static const String structure = '구조';
  static const String memo = '메모';
  static const String photos = '사진';
  static const String save = '저장';
  static const String edit = '수정';
  static const String delete = '삭제';
  static const String cancel = '취소';
  static const String confirm = '확인';
  static const String saved = '저장되었습니다';
  static const String deleted = '삭제되었습니다';
  static const String deleteConfirm = '이 임장 기록을 삭제하시겠습니까?';
  static const String addPhoto = '사진 추가';
  static const String camera = '카메라';
  static const String gallery = '갤러리';
  static const String backup = '데이터 백업';
  static const String restore = '데이터 복원';
  static const String bottomText = '하단 고정 문구';
  static const String home = '홈';
  static const String create = '작성';
  static const String settings = '설정';
  
  // 섹션 제목
  static const String basicInfo = '기본 정보';
  static const String detailInfo = '상세 정보';
  static const String priceInfo = '시세 정보';
  static const String additionalInfo = '추가 정보';
  
  // 필드 라벨
  static const String date = '날짜';
  static const String direction = '향';
  static const String elevator = '엘리베이터';
  static const String parking = '주차장';
  static const String householdCount = '세대수';
  static const String area = '해당평형 (㎡)';
  static const String schoolInfo = '학교정보';
  
  // 가격 필드
  static const String onlinePrice = '온라인 시세 (원)';
  static const String fieldPrice = '현장 시세 (원)';
  static const String salePrice = '매매가 (원)';
  static const String rentPrice = '전월세가 (원)';
  static const String actualPrice = '실거래가 (원)';
  
  // 기타
  static const String editVisit = '임장 수정';
  static const String savedStatus = '저장됨';
  static const String deleteConfirm = '삭제 확인';
  static const String priceInfoSection = '시세정보';
  static const String elevatorNone = '미선택';
  static const String elevatorYes = '있음';
  static const String elevatorNo = '없음';
  static const String photoDelete = '사진 삭제';
  static const String photoDeleteConfirm = '정말 이 사진을 삭제하시겠습니까?';
  static const String apartmentNameRequired = '단지명은 필수 항목입니다';
  static const String searchNoResults = '검색 결과가 없습니다';
  static const String visitNotFound = '임장 기록을 찾을 수 없습니다';
  static const String visitDetail = '임장 상세';
  static const String somePhotoSaveFailed = '일부 사진 저장에 실패했습니다';
  static const String photoSaveFailed = '사진 저장에 실패했습니다';
  static const String backupShared = '백업 데이터가 공유되었습니다';
  static const String backupFailed = '백업에 실패했습니다';
  static const String restoreSuccess = '데이터가 복원되었습니다';
  static const String restoreFailed = '복원에 실패했습니다. JSON 형식을 확인해주세요';
  static const String fileReadError = '파일을 읽는 중 오류가 발생했습니다';
  static const String sortOption = '정렬 옵션';
  static const String dateNewest = '날짜 (최신순)';
  static const String dateOldest = '날짜 (오래된순)';
  static const String priceHigh = '시세 (높은순)';
  static const String priceLow = '시세 (낮은순)';
  static const String noVisitRecords = '임장 기록이 없습니다';
  static const String createFirstVisit = '첫 임장 기록을 작성해보세요';
  static const String createFirstVisitButton = '첫 임장 작성하기';
}

class StructureOptions {
  static const List<String> options = [
    '복도식',
    '계단식',
    '타워형',
    '판상형',
    '혼합형',
  ];
}

class DirectionOptions {
  static const List<String> options = [
    '남향',
    '남동향',
    '동향',
    '북동향',
    '북향',
    '북서향',
    '서향',
    '남서향',
  ];
}

class ParkingOptions {
  static const List<String> options = [
    '지상',
    '지하',
    '혼합',
  ];
}

