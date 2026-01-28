// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'A Memoria - Memorizza';

  @override
  String get homeTitle => 'Le mie schede';

  @override
  String get emptyStateTitle => 'Nessuna scheda ancora';

  @override
  String get emptyStateSubtitle => 'Aggiungi la tua prima scheda per iniziare';

  @override
  String get addCardButton => 'Aggiungi scheda';

  @override
  String cardStudyCount(int count) {
    return 'Studiato $count volte';
  }

  @override
  String get cardContentHint => 'Inserisci il testo da memorizzare';

  @override
  String get deleteCard => 'Elimina scheda';

  @override
  String get deleteCardConfirm =>
      'Sei sicuro di voler eliminare questa scheda?';

  @override
  String get cancel => 'Annulla';

  @override
  String get delete => 'Elimina';

  @override
  String get save => 'Salva';
}
