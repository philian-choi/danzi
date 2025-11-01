import 'package:flutter/services.dart';

/// 천단위 구분자를 자동으로 추가하는 숫자 입력 포맷터
class PriceInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // 숫자만 추출
    final digitsOnly = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    // 빈 문자열이면 그대로 반환
    if (digitsOnly.isEmpty) {
      return newValue.copyWith(
        text: '',
        selection: const TextSelection.collapsed(offset: 0),
      );
    }

    // 천단위 구분자 추가
    final formattedValue = _addThousandSeparator(digitsOnly);

    // 커서 위치 조정
    final oldLength = oldValue.text.replaceAll(RegExp(r'[^\d]'), '').length;
    final newLength = digitsOnly.length;
    final offsetChange = formattedValue.length - newValue.text.length;

    int newOffset;
    if (newLength > oldLength) {
      // 숫자가 추가된 경우: 형식화된 문자열의 끝으로 이동
      newOffset = formattedValue.length;
    } else {
      // 숫자가 삭제된 경우: 기존 오프셋에 변화량 반영
      newOffset = (newValue.selection.baseOffset + offsetChange).clamp(0, formattedValue.length);
    }

    return TextEditingValue(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: newOffset),
    );
  }

  String _addThousandSeparator(String digits) {
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(digits[i]);
    }
    return buffer.toString();
  }

  /// 문자열에서 콤마를 제거하여 숫자만 반환
  static String removeCommas(String formattedText) {
    return formattedText.replaceAll(',', '');
  }

  /// 숫자에 천단위 구분자를 추가하여 문자열로 반환
  static String formatNumber(int? number) {
    if (number == null) return '';
    final formatter = PriceInputFormatter();
    return formatter.formatEditUpdate(
      const TextEditingValue(text: ''),
      TextEditingValue(text: number.toString()),
    ).text;
  }
}

