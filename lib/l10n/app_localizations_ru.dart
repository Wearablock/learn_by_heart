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
}
