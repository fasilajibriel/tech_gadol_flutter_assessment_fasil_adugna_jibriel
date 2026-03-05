import 'package:flutter/material.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/config/flavor_config.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/constants/theme_constants.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/presentation/state/provider_view_state.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/features/splash/presentation/state/splash_provider.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/shared/widgets/empty_state_widget.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/shared/widgets/error_state_widget.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/shared/widgets/initial_state_widget.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/shared/widgets/loading_state_widget.dart';
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
              switch (provider.state) {
                case ProviderViewState.initial:
                  return const InitialStateWidget(
                    message: 'Preparing application...',
                  );
                case ProviderViewState.loading:
                  return const LoadingStateWidget(
                    message: 'Checking internet connection...',
                  );
                case ProviderViewState.error:
                  return ErrorStateWidget(
                    message:
                        provider.errorMessage ??
                        'No internet connection. Please try again.',
                    onRetry: provider.retry,
                  );
                case ProviderViewState.empty:
                  return EmptyStateWidget(
                    message: 'Nothing to show on splash.',
                    actionLabel: 'Retry',
                    onAction: provider.retry,
                  );
                case ProviderViewState.loaded:
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.account_balance_wallet_rounded,
                        size: 64,
                        color: AppTheme.lightTheme.colorScheme.primary,
                      ),
                      const SizedBox(height: ThemeConstants.defaultPadding),
                      Text(
                        FlavorConfig.instance.appName,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  );
              }
            },
          ),
        ),
      ),
    );
  }
}
