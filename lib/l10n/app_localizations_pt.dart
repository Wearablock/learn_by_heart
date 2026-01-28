// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Decorar - Memorizar';

  @override
  String get homeTitle => 'Meus cartões';

  @override
  String get emptyStateTitle => 'Nenhum cartão ainda';

  @override
  String get emptyStateSubtitle => 'Adicione seu primeiro cartão para começar';

  @override
  String get addCardButton => 'Adicionar cartão';

  @override
  String cardStudyCount(int count) {
    return 'Estudado $count vezes';
  }

  @override
  String get cardContentHint => 'Digite o texto para memorizar';

  @override
  String get deleteCard => 'Excluir cartão';

  @override
  String get deleteCardConfirm => 'Tem certeza que deseja excluir este cartão?';

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Excluir';

  @override
  String get save => 'Salvar';
}
