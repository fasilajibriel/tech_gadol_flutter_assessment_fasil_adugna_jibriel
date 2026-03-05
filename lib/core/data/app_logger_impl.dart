// core/data/services/production_logger.dart
import 'package:logger/logger.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/domain/app_logger.dart';

/// Production-grade logging implementation using the `logger` package.
///
/// Formats messages with optional class/method context:
/// ```
/// [MyClass].myMethod: Message here
/// ```
class AppLoggerImpl implements AppLogger {
  final Logger _logger;

  AppLoggerImpl(this._logger);

  /// Debug-level messages (verbose development-only details)
  @override
  void debug(String message, {String? className, String? methodName}) {
    _log(Level.debug, message, className, methodName);
  }

  /// Info-level messages (general operational events)
  @override
  void info(String message, {String? className, String? methodName}) {
    _log(Level.info, message, className, methodName);
  }

  /// Warning-level messages (unexpected but recoverable issues)
  @override
  void warning(String message, {String? className, String? methodName}) {
    _log(Level.warning, message, className, methodName);
  }

  /// Error-level messages (critical failures requiring attention)
  @override
  void error(String message, {String? className, String? methodName, Object? error, StackTrace? stackTrace}) {
    // final formatted = _formatMessage(message, className, methodName);
    _logger.log(
      Level.error,
      // formatted,
      message,
      error: className,
      stackTrace: stackTrace,
    );
  }

  void _log(Level level, String message, String? className, String? methodName) {
    _logger.log(level, _formatMessage(message, className, methodName));
  }

  String _formatMessage(String message, String? className, String? methodName) {
    final buffer = StringBuffer();
    if (className != null) buffer.write('[$className]');
    if (methodName != null) buffer.write('.$methodName');
    if (buffer.isNotEmpty) buffer.write(': ');
    buffer.write(message);
    return buffer.toString();
  }
}
