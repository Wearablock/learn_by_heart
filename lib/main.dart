import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:learn_by_heart/core/database/database_service.dart';
import 'package:learn_by_heart/core/database/seed_service.dart';
import 'package:learn_by_heart/core/theme/app_theme.dart';
import 'package:learn_by_heart/l10n/app_localizations.dart';
import 'package:learn_by_heart/features/navigation/presentation/pages/main_scaffold.dart';
import 'package:learn_by_heart/features/navigation/presentation/providers/navigation_provider.dart';
import 'package:learn_by_heart/features/home/presentation/providers/card_provider.dart';
import 'package:learn_by_heart/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:learn_by_heart/features/statistics/presentation/providers/statistics_provider.dart';
import 'package:learn_by_heart/features/settings/presentation/providers/settings_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseService.initialize();
  await SeedService.seedIfEmpty();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
            home: const MainScaffold(),
          );
        },
      ),
    );
  }
}
