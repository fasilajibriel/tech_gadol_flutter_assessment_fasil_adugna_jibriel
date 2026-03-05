import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/app.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/config/flavor_config.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/di/injector.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const flavorName = String.fromEnvironment('FLAVOR', defaultValue: 'prod');
  FlavorConfig.initialize(FlavorConfig.fromName(flavorName));

  await dotenv.load(fileName: '.env_$flavorName');
  await setupDependencies();

  runApp(const App());
}
