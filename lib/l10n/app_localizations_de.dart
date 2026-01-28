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

  @override
  String get addCard => 'Karte hinzufügen';

  @override
  String get editCard => 'Karte bearbeiten';

  @override
  String get cardContent => 'Inhalt';

  @override
  String get cardContentRequired => 'Inhalt ist erforderlich';

  @override
  String get cardHint => 'Hinweis (optional)';

  @override
  String get cardHintPlaceholder => 'Hinweis zum Erinnern eingeben';

  @override
  String get discardChanges => 'Änderungen verwerfen';

  @override
  String get discardChangesMessage => 'Ungespeicherte Änderungen verwerfen?';

  @override
  String get keepEditing => 'Weiter bearbeiten';

  @override
  String get discard => 'Verwerfen';
}
