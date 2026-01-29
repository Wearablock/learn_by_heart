import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/statistics_provider.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.navStatistics),
      ),
      body: Consumer<StatisticsProvider>(
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
                _OverallSummaryCard(
                  totalStudied: provider.totalStudyCount,
                  averageAccuracy: provider.averageAccuracy,
                ),
                const SizedBox(height: 16),
                _DailyChartCard(
                  isWeeklyView: provider.isWeeklyView,
                  stats: provider.currentStats,
                  onViewChanged: provider.setWeeklyView,
                ),
                const SizedBox(height: 16),
                _CardAccuracyCard(cardStats: provider.cardStats),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _OverallSummaryCard extends StatelessWidget {
  final int totalStudied;
  final double averageAccuracy;

  const _OverallSummaryCard({
    required this.totalStudied,
    required this.averageAccuracy,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Text(
                    '$totalStudied',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  Text(
                    l10n.totalStudied,
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Container(
              width: 1,
              height: 40,
              color: theme.colorScheme.outlineVariant,
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    '${averageAccuracy.toStringAsFixed(0)}%',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.tertiary,
                    ),
                  ),
                  Text(
                    l10n.averageAccuracy,
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DailyChartCard extends StatelessWidget {
  final bool isWeeklyView;
  final List<DailyStats> stats;
  final ValueChanged<bool> onViewChanged;

  const _DailyChartCard({
    required this.isWeeklyView,
    required this.stats,
    required this.onViewChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final maxY = stats.isEmpty
        ? 10.0
        : (stats.map((s) => s.studyCount).reduce((a, b) => a > b ? a : b) + 2)
            .toDouble();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: SegmentedButton<bool>(
                    segments: [
                      ButtonSegment(
                        value: true,
                        label: Text(l10n.weeklyTab),
                      ),
                      ButtonSegment(
                        value: false,
                        label: Text(l10n.monthlyTab),
                      ),
                    ],
                    selected: {isWeeklyView},
                    onSelectionChanged: (selected) {
                      onViewChanged(selected.first);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: stats.isEmpty || stats.every((s) => s.studyCount == 0)
                  ? Center(
                      child: Text(
                        l10n.noStudyData,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    )
                  : BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: maxY,
                        barGroups: _buildBarGroups(theme),
                        titlesData: FlTitlesData(
                          show: true,
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) =>
                                  _buildBottomTitle(value, context),
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 30,
                              getTitlesWidget: (value, meta) {
                                if (value == value.roundToDouble()) {
                                  return Text(
                                    value.toInt().toString(),
                                    style: theme.textTheme.bodySmall,
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                          ),
                        ),
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          horizontalInterval: maxY / 5,
                        ),
                        borderData: FlBorderData(show: false),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  List<BarChartGroupData> _buildBarGroups(ThemeData theme) {
    return stats.asMap().entries.map((entry) {
      final index = entry.key;
      final stat = entry.value;
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: stat.studyCount.toDouble(),
            color: theme.colorScheme.primary,
            width: isWeeklyView ? 20 : 8,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ],
      );
    }).toList();
  }

  Widget _buildBottomTitle(double value, BuildContext context) {
    final theme = Theme.of(context);
    final index = value.toInt();
    if (index < 0 || index >= stats.length) {
      return const SizedBox.shrink();
    }

    final date = stats[index].date;
    String label;

    if (isWeeklyView) {
      // Show day name for weekly view
      final weekdays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
      label = weekdays[date.weekday - 1];
    } else {
      // Show day number for monthly view (every 5 days)
      if (index % 5 == 0 || index == stats.length - 1) {
        label = '${date.day}';
      } else {
        return const SizedBox.shrink();
      }
    }

    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        label,
        style: theme.textTheme.bodySmall,
      ),
    );
  }
}

class _CardAccuracyCard extends StatelessWidget {
  final List<CardStats> cardStats;

  const _CardAccuracyCard({required this.cardStats});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final studiedCards = cardStats.where((s) => s.totalStudies > 0).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.accuracy,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            if (studiedCards.isEmpty)
              Text(
                l10n.noStudyData,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              )
            else
              ...studiedCards.take(10).map(
                    (stat) => _CardAccuracyItem(stat: stat),
                  ),
          ],
        ),
      ),
    );
  }
}

class _CardAccuracyItem extends StatelessWidget {
  final CardStats stat;

  const _CardAccuracyItem({required this.stat});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            stat.content,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: stat.accuracy / 100,
                    minHeight: 8,
                    backgroundColor: theme.colorScheme.surfaceContainerHighest,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 45,
                child: Text(
                  '${stat.accuracy.toStringAsFixed(0)}%',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
