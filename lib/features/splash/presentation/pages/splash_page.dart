import 'package:flutter/material.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/config/flavor_config.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/constants/theme_constants.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/features/splash/presentation/state/splash_provider.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/shared/theme/app_theme.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Consumer<SplashProvider>(
            builder: (context, provider, _) {
              if (!provider.hasConnection) {
                return Padding(
                  padding: const EdgeInsets.all(ThemeConstants.defaultPadding),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.wifi_off_rounded, size: 56, color: AppTheme.lightTheme.colorScheme.primary),
                      const SizedBox(height: ThemeConstants.defaultPadding),
                      const Text(
                        'No Internet Connection',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      const SizedBox(height: ThemeConstants.defaultPadding),
                      const Text(
                        'Please check your connection and try again.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: ThemeConstants.defaultPadding),
                      ElevatedButton(onPressed: provider.retry, child: const Text('Retry')),
                    ],
                  ),
                );
              }

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.account_balance_wallet_rounded, size: 64, color: AppTheme.lightTheme.colorScheme.primary),
                  const SizedBox(height: ThemeConstants.defaultPadding),
                  const Text('ET Calendar', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: ThemeConstants.defaultPadding),
                  if (provider.isLoading) CircularProgressIndicator(color: FlavorConfig.instance.primaryColor),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
