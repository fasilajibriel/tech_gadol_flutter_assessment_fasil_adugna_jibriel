import 'package:flutter_test/flutter_test.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/app/routes.dart';

void main() {
  test('App route paths are stable', () {
    expect(Routes.splash.path, '/splash');
    expect(Routes.home.path, '/home');
  });
}
