/// 가격을 한국어 형식으로 표시하는 유틸리티
class PriceDisplayFormatter {
  /// 가격을 한국어 형식으로 포맷팅 (예: "5.5억", "5,000만")
  static String formatPrice(int? price) {
    if (price == null || price == 0) return '';
    
    if (price >= 100000000) {
      // 1억 이상인 경우: "5.5억" 형식
      final eok = price / 100000000;
      if (eok % 1 == 0) {
        return '${eok.toInt()}억';
      } else {
        return '${eok.toStringAsFixed(1)}억';
      }
    } else if (price >= 10000) {
      // 1만 이상인 경우: "5,000만" 형식
      final man = (price / 10000).toInt();
      return '$man만';
    }
    // 1만 미만인 경우: 그대로 표시
    return price.toString();
  }

  /// 가격 정보 중 우선순위가 높은 가격 반환
  /// 우선순위: 실거래가 > 매매가 > 현장시세 > 온라인시세
  static int? getPriorityPrice({
    int? actualPrice,
    int? salePrice,
    int? fieldPrice,
    int? onlinePrice,
  }) {
    return actualPrice ?? salePrice ?? fieldPrice ?? onlinePrice;
  }

  /// 가격 정보를 포맷팅하여 반환 (우선순위 적용)
  static String? formatPriorityPrice({
    int? actualPrice,
    int? salePrice,
    int? fieldPrice,
    int? onlinePrice,
  }) {
    final price = getPriorityPrice(
      actualPrice: actualPrice,
      salePrice: salePrice,
      fieldPrice: fieldPrice,
      onlinePrice: onlinePrice,
    );
    if (price == null) return null;
    return formatPrice(price);
  }

  /// 가격 타입 라벨 반환 (어떤 가격인지 표시)
  static String? getPriceTypeLabel({
    int? actualPrice,
    int? salePrice,
    int? fieldPrice,
    int? onlinePrice,
  }) {
    if (actualPrice != null) return '실거래가';
    if (salePrice != null) return '매매가';
    if (fieldPrice != null) return '현장시세';
    if (onlinePrice != null) return '온라인시세';
    return null;
  }
}

