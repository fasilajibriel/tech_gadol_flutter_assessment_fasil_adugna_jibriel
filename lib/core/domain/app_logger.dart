// core/domain/services/app_logger.dart
/// Abstract logging contract for application-wide logging
abstract class AppLogger {
  void debug(String message, {String? className, String? methodName});
  void info(String message, {String? className, String? methodName});
  void warning(String message, {String? className, String? methodName});
  void error(
    String message, {
    String? className,
    String? methodName,
    Object? error,
    StackTrace? stackTrace,
  });
}
