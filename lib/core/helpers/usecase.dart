import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/helpers/typedef.dart';

/// A generic use case template for all business logic operations.
///
/// [ResultType] is the return type (e.g., `AuthUser`).
/// [Params] is the input parameters (use [NoParams] if none).
abstract class UseCase<ResultType, Params> {
  FutureResult<ResultType> call(Params params);
}

/// Used when a use case doesn’t require input parameters.
class NoParams {}
