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
}
