import 'package:flutter/foundation.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/app/routes.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/helpers/utils.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/domain/app_router.dart';

class SplashProvider with ChangeNotifier {
  SplashProvider({required AppRouter router}) : _router = router;

  final AppRouter _router;

  bool _hasConnection = true;
  bool _isLoading = true;

  bool get hasConnection => _hasConnection;
  bool get isLoading => _isLoading;

  Future<void> initialize() async {
    _setLoading(true);
    final connected = await Utils.hasInternetConnection();
    if (!connected) {
      _hasConnection = false;
      _setLoading(false);
      return;
    }

    _hasConnection = true;
    _setLoading(false);
    _router.go(Routes.home.path);
  }

  Future<void> retry() async {
    await initialize();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
