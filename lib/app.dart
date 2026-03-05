import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/app/go_router_config.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/config/flavor_config.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/core/presentation/providers/theme_provider.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/di/injector.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/features/splash/presentation/state/splash_provider.dart';
import 'package:tech_gadol_flutter_assessment_fasil_adugna_jibriel/shared/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => getIt<SplashProvider>()..initialize()),
        ChangeNotifierProvider(create: (_) => getIt<ThemeProvider>()..initialize()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp.router(
            routerConfig: GoRouterConfig.getRouter(),
            title: FlavorConfig.instance.appName,
            theme: AppTheme.lightTheme.copyWith(
              textTheme: AppTheme.lightTheme.textTheme.apply(fontFamily: GoogleFonts.poppins().fontFamily),
            ),
            darkTheme: AppTheme.darkTheme.copyWith(
              textTheme: AppTheme.darkTheme.textTheme.apply(fontFamily: GoogleFonts.poppins().fontFamily),
            ),
            themeMode: themeProvider.themeMode,
            debugShowCheckedModeBanner: !FlavorConfig.instance.isProduction,
          );
        },
      ),
    );
  }
}
