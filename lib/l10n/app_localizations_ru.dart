// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Наизусть - Запоминай';

  @override
  String get homeTitle => 'Мои карточки';

  @override
  String get emptyStateTitle => 'Пока нет карточек';

  @override
  String get emptyStateSubtitle => 'Добавьте первую карточку, чтобы начать';

  @override
  String get addCardButton => 'Добавить карточку';

  @override
  String cardStudyCount(int count) {
    return 'Изучено $count раз';
  }

  @override
  String get cardContentHint => 'Введите текст для запоминания';

  @override
  String get deleteCard => 'Удалить карточку';

  @override
  String get deleteCardConfirm =>
      'Вы уверены, что хотите удалить эту карточку?';

  @override
  String get cancel => 'Отмена';

  @override
  String get delete => 'Удалить';

  @override
  String get save => 'Сохранить';

  @override
  String get addCard => 'Добавить карточку';

  @override
  String get editCard => 'Редактировать карточку';

  @override
  String get cardContent => 'Содержание';

  @override
  String get cardContentRequired => 'Содержание обязательно';

  @override
  String get cardHint => 'Подсказка (необязательно)';

  @override
  String get cardHintPlaceholder => 'Введите подсказку для запоминания';

  @override
  String get discardChanges => 'Отменить изменения';

  @override
  String get discardChangesMessage =>
      'У вас есть несохранённые изменения. Отменить?';

  @override
  String get keepEditing => 'Продолжить';

  @override
  String get discard => 'Отменить';

  @override
  String get startStudy => 'Начать изучение';

  @override
  String get studying => 'Изучение';

  @override
  String get enterAnswer => 'Введите ответ';

  @override
  String get submit => 'Отправить';

  @override
  String get correct => 'Верно!';

  @override
  String get incorrect => 'Неверно';

  @override
  String get yourAnswer => 'Ваш ответ';

  @override
  String get correctAnswerLabel => 'Правильный ответ';

  @override
  String get next => 'Далее';

  @override
  String get studyComplete => 'Изучение завершено';

  @override
  String get accuracy => 'Точность';

  @override
  String get wrongAnswers => 'Неправильные ответы';

  @override
  String get studyAgain => 'Изучать снова';

  @override
  String get backToHome => 'На главную';

  @override
  String get noCardsToStudy => 'Нет карточек для изучения';

  @override
  String get studyExitConfirm => 'Прогресс не будет сохранён. Выйти?';

  @override
  String get exit => 'Выйти';
}
