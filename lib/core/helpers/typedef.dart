import 'package:dartz/dartz.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/error/failure.dart';

/// A function signature for asynchronous operations returning a result or error.
///
/// This typedef represents operations that return `T` on success or `Failure`
/// on error, promoting better error handling by encapsulating data in
/// `Either` from Dartz.
typedef FutureResult<T> = Future<Either<Failure, T>>;

/// A function signature for asynchronous operations that return no value,
/// handling only success or failure.
///
/// This is ideal for operations like delete, update, or any void operation
/// that either succeeds silently or fails with a `Failure`.
typedef FutureVoid = FutureResult<void>;
