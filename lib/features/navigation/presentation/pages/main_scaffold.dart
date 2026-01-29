import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../dashboard/presentation/pages/dashboard_page.dart';
import '../../../cards/presentation/pages/cards_page.dart';
import '../../../statistics/presentation/pages/statistics_page.dart';
import '../../../settings/presentation/pages/settings_page.dart';
import '../providers/navigation_provider.dart';

class MainScaffold extends StatelessWidget {
  const MainScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Consumer<NavigationProvider>(
      builder: (context, navProvider, child) {
        return Scaffold(
          body: IndexedStack(
            index: navProvider.currentIndex,
            children: const [
              DashboardPage(),
              CardsPage(),
              StatisticsPage(),
              SettingsPage(),
            ],
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: navProvider.currentIndex,
            onDestinationSelected: navProvider.setIndex,
            destinations: [
              NavigationDestination(
                icon: const Icon(Icons.home_outlined),
                selectedIcon: const Icon(Icons.home),
                label: l10n.navHome,
              ),
              NavigationDestination(
                icon: const Icon(Icons.library_books_outlined),
                selectedIcon: const Icon(Icons.library_books),
                label: l10n.navCards,
              ),
              NavigationDestination(
                icon: const Icon(Icons.bar_chart_outlined),
                selectedIcon: const Icon(Icons.bar_chart),
                label: l10n.navStatistics,
              ),
              NavigationDestination(
                icon: const Icon(Icons.settings_outlined),
                selectedIcon: const Icon(Icons.settings),
                label: l10n.navSettings,
              ),
            ],
          ),
        );
      },
    );
  }
}
