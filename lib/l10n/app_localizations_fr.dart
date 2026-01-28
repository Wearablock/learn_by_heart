// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Par Coeur - Memoriser';

  @override
  String get homeTitle => 'Mes cartes';

  @override
  String get emptyStateTitle => 'Pas encore de cartes';

  @override
  String get emptyStateSubtitle =>
      'Ajoutez votre première carte pour commencer';

  @override
  String get addCardButton => 'Ajouter une carte';

  @override
  String cardStudyCount(int count) {
    return 'Étudié $count fois';
  }

  @override
  String get cardContentHint => 'Entrez le texte à mémoriser';

  @override
  String get deleteCard => 'Supprimer la carte';

  @override
  String get deleteCardConfirm => 'Voulez-vous vraiment supprimer cette carte?';

  @override
  String get cancel => 'Annuler';

  @override
  String get delete => 'Supprimer';

  @override
  String get save => 'Enregistrer';

  @override
  String get addCard => 'Ajouter une carte';

  @override
  String get editCard => 'Modifier la carte';

  @override
  String get cardContent => 'Contenu';

  @override
  String get cardContentRequired => 'Le contenu est requis';

  @override
  String get cardHint => 'Indice (optionnel)';

  @override
  String get cardHintPlaceholder => 'Entrez un indice pour aider à mémoriser';

  @override
  String get discardChanges => 'Annuler les modifications';

  @override
  String get discardChangesMessage =>
      'Vous avez des modifications non enregistrées. Les annuler?';

  @override
  String get keepEditing => 'Continuer';

  @override
  String get discard => 'Annuler';

  @override
  String get startStudy => 'Commencer l\'étude';

  @override
  String get studying => 'Étude en cours';

  @override
  String get enterAnswer => 'Entrez votre réponse';

  @override
  String get submit => 'Soumettre';

  @override
  String get correct => 'Correct !';

  @override
  String get incorrect => 'Incorrect';

  @override
  String get yourAnswer => 'Votre réponse';

  @override
  String get correctAnswerLabel => 'Bonne réponse';

  @override
  String get next => 'Suivant';

  @override
  String get studyComplete => 'Étude terminée';

  @override
  String get accuracy => 'Précision';

  @override
  String get wrongAnswers => 'Mauvaises réponses';

  @override
  String get studyAgain => 'Réétudier';

  @override
  String get backToHome => 'Retour à l\'accueil';

  @override
  String get noCardsToStudy => 'Aucune carte à étudier';

  @override
  String get studyExitConfirm =>
      'La progression ne sera pas sauvegardée. Quitter ?';

  @override
  String get exit => 'Quitter';

  @override
  String get emptyAnswer => '(vide)';
}
