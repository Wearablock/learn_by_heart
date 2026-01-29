import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:learn_by_heart/core/database/database_service.dart';
import 'package:learn_by_heart/core/database/seed_service.dart';
import 'package:learn_by_heart/core/services/ad_service.dart';
import 'package:learn_by_heart/core/theme/app_theme.dart';
import 'package:learn_by_heart/l10n/app_localizations.dart';
import 'package:learn_by_heart/features/navigation/presentation/pages/main_scaffold.dart';
import 'package:learn_by_heart/features/navigation/presentation/providers/navigation_provider.dart';
import 'package:learn_by_heart/features/home/presentation/providers/card_provider.dart';
import 'package:learn_by_heart/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:learn_by_heart/features/statistics/presentation/providers/statistics_provider.dart';
import 'package:learn_by_heart/features/settings/presentation/providers/settings_provider.dart';
import 'package:learn_by_heart/features/onboarding/presentation/pages/onboarding_page.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await DatabaseService.initialize();
  await SeedService.seedIfEmpty();
  await AdService().initialize();

  final prefs = await SharedPreferences.getInstance();
  final showOnboarding = !(prefs.getBool('onboarding_complete') ?? false);

  FlutterNativeSplash.remove();
  runApp(MyApp(showOnboarding: showOnboarding));
}

class MyApp extends StatefulWidget {
  final bool showOnboarding;

  const MyApp({super.key, required this.showOnboarding});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool _showOnboarding;

  @override
  void initState() {
    super.initState();
    _showOnboarding = widget.showOnboarding;
  }

  void _completeOnboarding() {
    setState(() {
      _showOnboarding = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => CardProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => StatisticsProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settings, child) {
          return MaterialApp(
            onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
            debugShowCheckedModeBanner: false,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: settings.locale,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: settings.themeMode,
            home: _showOnboarding
                ? OnboardingPage(onComplete: _completeOnboarding)
                : const MainScaffold(),
          );
        },
      ),
    );
  }
}
