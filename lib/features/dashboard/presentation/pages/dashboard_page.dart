import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/streak_widget.dart';
import '../widgets/recent_card_widget.dart';
import '../widgets/today_summary_widget.dart';
import '../widgets/due_cards_widget.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.navHome),
      ),
      body: Consumer<DashboardProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return RefreshIndicator(
            onRefresh: provider.refresh,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                StreakWidget(streak: provider.streak),
                const SizedBox(height: 8),
                RecentCardWidget(card: provider.recentCard),
                const SizedBox(height: 8),
                TodaySummaryWidget(
                  studyCount: provider.todayStudyCount,
                  accuracy: provider.todayAccuracy,
                ),
                const SizedBox(height: 8),
                DueCardsWidget(
                  dueCount: provider.dueCardsCount,
                  cardIds: provider.dueCardIds,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
