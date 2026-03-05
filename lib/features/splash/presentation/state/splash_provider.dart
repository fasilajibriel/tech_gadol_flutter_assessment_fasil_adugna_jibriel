import 'package:flutter/foundation.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/app/routes.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/presentation/state/provider_view_state.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/helpers/utils.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/domain/app_router.dart';

class SplashProvider with ChangeNotifier {
  SplashProvider({required AppRouter router}) : _router = router;

  final AppRouter _router;

  bool _hasConnection = true;
  bool _isLoading = true;
  ProviderViewState _state = ProviderViewState.initial;
  String? _errorMessage;

  bool get hasConnection => _hasConnection;
  bool get isLoading => _isLoading;
  ProviderViewState get state => _state;
  String? get errorMessage => _errorMessage;

  Future<void> initialize() async {
    _state = ProviderViewState.loading;
    _setLoading(true);
    final connected = await Utils.hasInternetConnection();
    if (!connected) {
      _hasConnection = false;
      _errorMessage = 'No internet connection.';
      _state = ProviderViewState.error;
      _setLoading(false);
      return;
    }

    _hasConnection = true;
    _errorMessage = null;
    _state = ProviderViewState.loaded;
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
