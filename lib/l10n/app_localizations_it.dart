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

  @override
  String get addCard => 'Aggiungi scheda';

  @override
  String get editCard => 'Modifica scheda';

  @override
  String get cardContent => 'Contenuto';

  @override
  String get cardContentRequired => 'Il contenuto è obbligatorio';

  @override
  String get cardHint => 'Suggerimento (opzionale)';

  @override
  String get cardHintPlaceholder => 'Inserisci un suggerimento per ricordare';

  @override
  String get discardChanges => 'Annulla modifiche';

  @override
  String get discardChangesMessage => 'Hai modifiche non salvate. Annullarle?';

  @override
  String get keepEditing => 'Continua a modificare';

  @override
  String get discard => 'Annulla';

  @override
  String get startStudy => 'Inizia studio';

  @override
  String get studying => 'Studiando';

  @override
  String get enterAnswer => 'Inserisci la risposta';

  @override
  String get submit => 'Invia';

  @override
  String get correct => 'Corretto!';

  @override
  String get incorrect => 'Sbagliato';

  @override
  String get yourAnswer => 'La tua risposta';

  @override
  String get correctAnswerLabel => 'Risposta corretta';

  @override
  String get next => 'Avanti';

  @override
  String get studyComplete => 'Studio completato';

  @override
  String get accuracy => 'Precisione';

  @override
  String get wrongAnswers => 'Risposte sbagliate';

  @override
  String get studyAgain => 'Studia di nuovo';

  @override
  String get backToHome => 'Torna alla home';

  @override
  String get noCardsToStudy => 'Nessuna scheda da studiare';

  @override
  String get studyExitConfirm => 'I progressi non verranno salvati. Uscire?';

  @override
  String get exit => 'Esci';
}
