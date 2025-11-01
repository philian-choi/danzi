import 'package:intl/intl.dart';

class DateFormatter {
  static String formatDate(DateTime date) {
    return DateFormat('yyyy년 MM월 dd일', 'ko_KR').format(date);
  }

  static String formatDateTime(DateTime date) {
    return DateFormat('yyyy년 MM월 dd일 HH:mm', 'ko_KR').format(date);
  }

  static String formatDateShort(DateTime date) {
    return DateFormat('MM월 dd일', 'ko_KR').format(date);
  }
}

