/// Standardized response format for all API calls.
///
/// [T]: Type of the data payload (e.g., `UserDTO`).
/// [statusCode]: HTTP status code (e.g., 200, 404).
/// [data]: Parsed response data (nullable).
/// [message]: Optional message from the server.
class ApiResponse<T> {
  final int statusCode;
  final T? data;
  final String? message;

  ApiResponse({
    required this.statusCode,
    this.data,
    this.message,
  });

  /// Returns `true` if the status code is 2xx.
  bool get isSuccess => statusCode >= 200 && statusCode < 300;
}
