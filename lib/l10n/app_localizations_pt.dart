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

  @override
  String get addCard => 'Adicionar cartão';

  @override
  String get editCard => 'Editar cartão';

  @override
  String get cardContent => 'Conteúdo';

  @override
  String get cardContentRequired => 'O conteúdo é obrigatório';

  @override
  String get cardHint => 'Dica (opcional)';

  @override
  String get cardHintPlaceholder => 'Digite uma dica para ajudar a lembrar';

  @override
  String get discardChanges => 'Descartar alterações';

  @override
  String get discardChangesMessage =>
      'Você tem alterações não salvas. Descartá-las?';

  @override
  String get keepEditing => 'Continuar editando';

  @override
  String get discard => 'Descartar';

  @override
  String get startStudy => 'Iniciar estudo';

  @override
  String get studying => 'Estudando';

  @override
  String get enterAnswer => 'Digite sua resposta';

  @override
  String get submit => 'Enviar';

  @override
  String get correct => 'Correto!';

  @override
  String get incorrect => 'Incorreto';

  @override
  String get yourAnswer => 'Sua resposta';

  @override
  String get correctAnswerLabel => 'Resposta correta';

  @override
  String get next => 'Próximo';

  @override
  String get studyComplete => 'Estudo concluído';

  @override
  String get accuracy => 'Precisão';

  @override
  String get wrongAnswers => 'Respostas erradas';

  @override
  String get studyAgain => 'Estudar novamente';

  @override
  String get backToHome => 'Voltar ao início';

  @override
  String get noCardsToStudy => 'Nenhum cartão para estudar';

  @override
  String get studyExitConfirm => 'O progresso não será salvo. Sair?';

  @override
  String get exit => 'Sair';
}
