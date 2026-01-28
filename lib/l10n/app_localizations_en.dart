// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Learn by Heart - Memorize';

  @override
  String get homeTitle => 'My Cards';

  @override
  String get emptyStateTitle => 'No cards yet';

  @override
  String get emptyStateSubtitle => 'Add your first card to start memorizing';

  @override
  String get addCardButton => 'Add Card';

  @override
  String cardStudyCount(int count) {
    return '$count times studied';
  }

  @override
  String get cardContentHint => 'Enter text to memorize';

  @override
  String get deleteCard => 'Delete Card';

  @override
  String get deleteCardConfirm => 'Are you sure you want to delete this card?';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get save => 'Save';
}
