import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/error/failure.dart';

extension FailureExtensions on Failure {
  String get userMessage {
    switch (this) {
      case ApiFailure():
        return _getApiErrorMessage(statusCode, message);
      case AuthFailure():
        return message.isNotEmpty
            ? message
            : 'Authentication failed. Please check your credentials.';
      case StorageFailure():
        return 'Storage error: $message';
      case JwtDecodeFailure():
        return 'Session expired. Please login again.';
      case NetworkFailure():
        return message.isNotEmpty
            ? message
            : 'Network error. Please check your internet connection.';
      case PermissionFailure():
        return 'Permission denied: $message';
      case LocationFailure():
        return 'Location error: $message';
      case DataParsingFailure():
        return 'Data parsing error: $message';
      case NavigationFailure():
        return 'Navigation error: $message';
      case UnknownFailure():
        return 'Something went wrong. Please try again later.';
    }
  }

  String _getApiErrorMessage(int statusCode, String fallbackMessage) {
    switch (statusCode) {
      case 400:
        return 'Bad request. Please check your input.';
      case 401:
        return 'Unauthorized. Please login again.';
      case 403:
        return 'Forbidden. You do not have permission to access this resource.';
      case 404:
        return 'Resource not found.';
      case 408:
        return 'Request timed out. Please try again.';
      case 429:
        return 'Too many requests. Please try again later.';
      case 500:
        return 'Server error. Please try again later.';
      case 502:
        return 'Bad gateway. Please try again later.';
      case 503:
        return 'Service unavailable. Please try again later.';
      case 504:
        return 'Gateway timeout. Please try again later.';
      default:
        return fallbackMessage.isNotEmpty
            ? fallbackMessage
            : 'API error: $statusCode';
    }
  }
}
