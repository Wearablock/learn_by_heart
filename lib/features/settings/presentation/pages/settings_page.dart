import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_urls.dart';
import '../../../../core/services/iap_service.dart';
import '../../../../core/widgets/app_image.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/settings_provider.dart';
import 'webview_screen.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.navSettings),
      ),
      body: Consumer<SettingsProvider>(
        builder: (context, settings, child) {
          if (settings.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView(
            children: [
              _SectionHeader(title: l10n.appearance),
              _ThemeTile(
                currentMode: settings.themeMode,
                onChanged: settings.setThemeMode,
              ),
              const Divider(),
              _SectionHeader(title: l10n.language),
              _LanguageTile(
                currentLocale: settings.locale,
                onChanged: settings.setLocale,
              ),
              const Divider(),
              _SectionHeader(title: l10n.studySettings),
              _PassThresholdTile(
                value: settings.passThreshold,
                onChanged: settings.setPassThreshold,
              ),
              const Divider(),
              _SectionHeader(title: l10n.removeAds),
              const _RemoveAdsTile(),
              const Divider(),
              _SectionHeader(title: l10n.termsAndPolicies),
              _TermsTile(),
              const Divider(),
              _SectionHeader(title: l10n.about),
              _AboutTile(),
            ],
          );
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _ThemeTile extends StatelessWidget {
  final ThemeMode currentMode;
  final ValueChanged<ThemeMode> onChanged;

  const _ThemeTile({
    required this.currentMode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ListTile(
      leading: const Icon(Icons.palette_outlined),
      title: Text(_getThemeLabel(l10n, currentMode)),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _showThemeDialog(context, l10n),
    );
  }

  String _getThemeLabel(AppLocalizations l10n, ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return l10n.themeLight;
      case ThemeMode.dark:
        return l10n.themeDark;
      case ThemeMode.system:
        return l10n.themeSystem;
    }
  }

  void _showThemeDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(l10n.appearance),
        children: [
          _buildThemeOption(context, l10n.themeLight, ThemeMode.light),
          _buildThemeOption(context, l10n.themeDark, ThemeMode.dark),
          _buildThemeOption(context, l10n.themeSystem, ThemeMode.system),
        ],
      ),
    );
  }

  Widget _buildThemeOption(BuildContext context, String label, ThemeMode mode) {
    final isSelected = currentMode == mode;
    return ListTile(
      leading: Icon(
        isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
        color: isSelected ? Theme.of(context).colorScheme.primary : null,
      ),
      title: Text(label),
      onTap: () {
        onChanged(mode);
        Navigator.pop(context);
      },
    );
  }
}

class _LanguageTile extends StatelessWidget {
  final Locale? currentLocale;
  final ValueChanged<Locale?> onChanged;

  const _LanguageTile({
    required this.currentLocale,
    required this.onChanged,
  });

  static const _supportedLocales = [
    (null, 'System'),
    (Locale('en'), 'English'),
    (Locale('ko'), '한국어'),
    (Locale('ja'), '日本語'),
    (Locale('zh'), '中文'),
    (Locale('es'), 'Español'),
    (Locale('fr'), 'Français'),
    (Locale('de'), 'Deutsch'),
    (Locale('it'), 'Italiano'),
    (Locale('pt'), 'Português'),
    (Locale('ru'), 'Русский'),
    (Locale('ar'), 'العربية'),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentLabel = _supportedLocales.firstWhere(
      (e) => e.$1?.languageCode == currentLocale?.languageCode,
      orElse: () => _supportedLocales.first,
    ).$2;

    return ListTile(
      leading: const Icon(Icons.language_outlined),
      title: Text(l10n.language),
      subtitle: Text(currentLabel),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _showLanguageDialog(context, l10n),
    );
  }

  void _showLanguageDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(l10n.language),
        children: _supportedLocales.map((entry) {
          final locale = entry.$1;
          final label = entry.$2;
          final isSelected =
              locale?.languageCode == currentLocale?.languageCode;
          return ListTile(
            leading: Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? Theme.of(context).colorScheme.primary : null,
            ),
            title: Text(label),
            onTap: () {
              onChanged(locale);
              Navigator.pop(context);
            },
          );
        }).toList(),
      ),
    );
  }
}

class _PassThresholdTile extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;

  const _PassThresholdTile({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.check_circle_outline),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.passThreshold,
                      style: theme.textTheme.bodyLarge,
                    ),
                    Text(
                      l10n.passThresholdDesc,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${(value * 100).toInt()}%',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Slider(
            value: value,
            min: 0.5,
            max: 1.0,
            divisions: 10,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _RemoveAdsTile extends StatefulWidget {
  const _RemoveAdsTile();

  @override
  State<_RemoveAdsTile> createState() => _RemoveAdsTileState();
}

class _RemoveAdsTileState extends State<_RemoveAdsTile> {
  final _iapService = IapService();
  bool _isPurchasing = false;
  bool _isRestoring = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    if (_iapService.adsRemoved) {
      return ListTile(
        leading: Icon(
          Icons.check_circle,
          color: theme.colorScheme.primary,
        ),
        title: Text(l10n.adsRemoved),
        subtitle: Text(l10n.adsRemovedDesc),
      );
    }

    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.block_outlined),
          title: Text(l10n.removeAdsTitle),
          subtitle: Text(
            _iapService.priceString.isNotEmpty
                ? l10n.removeAdsDesc(_iapService.priceString)
                : l10n.removeAdsDescLoading,
          ),
          trailing: _isPurchasing
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : FilledButton(
                  onPressed: _iapService.isAvailable ? _purchase : null,
                  child: Text(l10n.purchase),
                ),
          onTap: _iapService.isAvailable && !_isPurchasing ? _purchase : null,
        ),
        ListTile(
          leading: const Icon(Icons.restore_outlined),
          title: Text(l10n.restorePurchases),
          trailing: _isRestoring
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : null,
          onTap: _iapService.isAvailable && !_isRestoring ? _restore : null,
        ),
      ],
    );
  }

  Future<void> _purchase() async {
    setState(() => _isPurchasing = true);
    try {
      await _iapService.purchaseRemoveAds();
    } finally {
      if (mounted) {
        setState(() => _isPurchasing = false);
      }
    }
  }

  Future<void> _restore() async {
    setState(() => _isRestoring = true);
    try {
      await _iapService.restorePurchases();
    } finally {
      if (mounted) {
        setState(() => _isRestoring = false);
      }
    }
  }
}

class _TermsTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
    final langCode = locale.languageCode;

    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.article_outlined),
          title: Text(l10n.termsOfService),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _openWebView(
            context,
            l10n.termsOfService,
            _buildUrlWithLang(AppUrls.termsUrl, langCode),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.privacy_tip_outlined),
          title: Text(l10n.privacyPolicy),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _openWebView(
            context,
            l10n.privacyPolicy,
            _buildUrlWithLang(AppUrls.privacyUrl, langCode),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.help_outline),
          title: Text(l10n.support),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _openWebView(
            context,
            l10n.support,
            _buildUrlWithLang(AppUrls.supportUrl, langCode),
          ),
        ),
      ],
    );
  }

  String _buildUrlWithLang(String url, String langCode) {
    return '$url?lang=$langCode';
  }

  void _openWebView(BuildContext context, String title, String url) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WebViewScreen(title: title, url: url),
      ),
    );
  }
}

class _AboutTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Column(
      children: [
        // App info with mascot
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: AppImage(
                  assetPath: 'assets/icon/app_icon.png',
                  width: 64,
                  height: 64,
                  fallback: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      Icons.favorite,
                      color: theme.colorScheme.primary,
                      size: 32,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Learn by Heart',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${l10n.version} 1.0.0',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        ListTile(
          leading: const Icon(Icons.description_outlined),
          title: Text(l10n.licenses),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => showLicensePage(context: context),
        ),
      ],
    );
  }
}
