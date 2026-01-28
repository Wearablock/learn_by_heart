import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:learn_by_heart/core/database/database_service.dart';
import 'package:learn_by_heart/core/database/seed_service.dart';
import 'package:learn_by_heart/core/theme/app_theme.dart';
import 'package:learn_by_heart/l10n/app_localizations.dart';
import 'package:learn_by_heart/features/home/presentation/pages/home_page.dart';
import 'package:learn_by_heart/features/home/presentation/providers/card_provider.dart';

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
        ChangeNotifierProvider(create: (_) => CardProvider()),
      ],
      child: MaterialApp(
        title: 'Learn by Heart',
        debugShowCheckedModeBanner: false,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        home: const HomePage(),
      ),
    );
  }
}
