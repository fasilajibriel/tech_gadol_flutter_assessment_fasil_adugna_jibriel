import 'package:equatable/equatable.dart';

sealed class Failure extends Equatable {
  final String message;
  final int statusCode;

  const Failure({
    required this.message,
    this.statusCode = 500,
  });

  @override
  List<Object> get props => [message, statusCode];
}

final class ApiFailure extends Failure {
  const ApiFailure({
    required super.message,
    required super.statusCode,
  });
}

final class UnknownFailure extends Failure {
  const UnknownFailure({
    required super.message,
  }) : super(statusCode: 500);
}

final class StorageFailure extends Failure {
  const StorageFailure({
    required super.message,
  }) : super(statusCode: 500);
}

final class JwtDecodeFailure extends Failure {
  const JwtDecodeFailure({
    required super.message,
  }) : super(statusCode: 401);
}

final class AuthFailure extends Failure {
  const AuthFailure({
    required super.message,
  }) : super(statusCode: 401);
}

final class DataParsingFailure extends Failure {
  const DataParsingFailure({
    required super.message,
  }) : super(statusCode: 422);
}

final class LocationFailure extends Failure {
  const LocationFailure({
    required super.message,
  }) : super(statusCode: 503);
}

final class PermissionFailure extends Failure {
  const PermissionFailure({
    required super.message,
  }) : super(statusCode: 403);
}

final class NavigationFailure extends Failure {
  const NavigationFailure({
    required super.message,
  }) : super(statusCode: 500);
}

final class NetworkFailure extends Failure {
  const NetworkFailure({
    required super.message,
    super.statusCode = 503,
  });
}
