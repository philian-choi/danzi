import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../widgets/toast_message.dart';

/// 통일된 에러 처리 유틸리티
class ErrorHandler {
  /// UI 컨텍스트에서 에러를 처리하고 사용자에게 표시
  /// 
  /// [context] 위젯 컨텍스트 (ToastMessage 표시용)
  /// [error] 발생한 에러 객체
  /// [userMessage] 사용자에게 표시할 메시지 (null이면 기본 메시지)
  /// [logError] 로그를 출력할지 여부 (기본: true)
  static void handleError(
    BuildContext? context,
    Object error, {
    String? userMessage,
    bool logError = true,
  }) {
    if (logError) {
      debugPrint('Error: $error');
      if (kDebugMode && error is Error) {
        debugPrint('Stack trace: ${error.stackTrace}');
      }
    }

    if (context != null && context.mounted && userMessage != null) {
      ToastMessage.show(context, userMessage);
    }
  }

  /// 비동기 작업에서 발생한 에러를 안전하게 처리
  /// 
  /// [context] 위젯 컨텍스트
  /// [error] 발생한 에러
  /// [userMessage] 사용자에게 표시할 메시지
  /// [onError] 추가적인 에러 처리 콜백 (선택)
  static void handleAsyncError(
    BuildContext? context,
    Object error, {
    String? userMessage,
    VoidCallback? onError,
  }) {
    handleError(context, error, userMessage: userMessage);
    onError?.call();
  }

  /// 파일 작업 관련 에러 처리
  static void handleFileError(
    BuildContext? context,
    Object error, {
    String? fileName,
  }) {
    final message = fileName != null
        ? '${fileName} 파일 처리 중 오류가 발생했습니다'
        : '파일 처리 중 오류가 발생했습니다';
    handleError(context, error, userMessage: message);
  }

  /// 네트워크 관련 에러 처리 (향후 확장용)
  static void handleNetworkError(
    BuildContext? context,
    Object error, {
    String? userMessage,
  }) {
    handleError(
      context,
      error,
      userMessage: userMessage ?? '네트워크 연결을 확인해주세요',
    );
  }

  /// 데이터 파싱 관련 에러 처리
  static void handleParseError(
    BuildContext? context,
    Object error, {
    String? dataType,
  }) {
    final message = dataType != null
        ? '${dataType} 데이터를 불러오는 중 오류가 발생했습니다'
        : '데이터를 불러오는 중 오류가 발생했습니다';
    handleError(context, error, userMessage: message);
  }
}

