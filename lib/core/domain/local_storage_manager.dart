// core/domain/services/storage_handler.dart
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/helpers/typedef.dart';

abstract class LocalStorageManager {
  FutureResult<void> writeString(String key, String value);
  FutureResult<void> writeMap(String key, Map<String, dynamic> value);
  FutureResult<String> readString(String key);
  FutureResult<Map<String, dynamic>> readMap(String key);
  FutureResult<void> delete(String key);
  FutureResult<void> clearAll();
}
