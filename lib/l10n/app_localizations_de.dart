// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Auswendig - Memorieren';

  @override
  String get homeTitle => 'Meine Karten';

  @override
  String get emptyStateTitle => 'Noch keine Karten';

  @override
  String get emptyStateSubtitle => 'Füge deine erste Karte hinzu';

  @override
  String get addCardButton => 'Karte hinzufügen';

  @override
  String cardStudyCount(int count) {
    return '$count Mal gelernt';
  }

  @override
  String get cardContentHint => 'Text zum Auswendiglernen eingeben';

  @override
  String get deleteCard => 'Karte löschen';

  @override
  String get deleteCardConfirm => 'Diese Karte wirklich löschen?';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get delete => 'Löschen';

  @override
  String get save => 'Speichern';
}
