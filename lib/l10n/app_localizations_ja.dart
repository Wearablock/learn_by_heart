// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => '暗記 - テキストを覚える';

  @override
  String get homeTitle => 'マイカード';

  @override
  String get emptyStateTitle => 'カードがありません';

  @override
  String get emptyStateSubtitle => '最初のカードを追加して暗記を始めましょう';

  @override
  String get addCardButton => 'カードを追加';

  @override
  String cardStudyCount(int count) {
    return '$count回学習';
  }

  @override
  String get cardContentHint => '暗記する内容を入力';

  @override
  String get deleteCard => 'カードを削除';

  @override
  String get deleteCardConfirm => 'このカードを削除しますか？';

  @override
  String get cancel => 'キャンセル';

  @override
  String get delete => '削除';

  @override
  String get save => '保存';

  @override
  String get addCard => 'カードを追加';

  @override
  String get editCard => 'カードを編集';

  @override
  String get cardContent => '内容';

  @override
  String get cardContentRequired => '内容を入力してください';

  @override
  String get cardHint => 'ヒント（任意）';

  @override
  String get cardHintPlaceholder => '記憶に役立つヒントを入力';

  @override
  String get discardChanges => '変更を破棄';

  @override
  String get discardChangesMessage => '保存されていない変更があります。破棄しますか？';

  @override
  String get keepEditing => '編集を続ける';

  @override
  String get discard => '破棄';

  @override
  String get startStudy => '学習開始';

  @override
  String get studying => '学習中';

  @override
  String get enterAnswer => '答えを入力';

  @override
  String get submit => '送信';

  @override
  String get correct => '正解！';

  @override
  String get incorrect => '不正解';

  @override
  String get yourAnswer => 'あなたの答え';

  @override
  String get correctAnswerLabel => '正解';

  @override
  String get next => '次へ';

  @override
  String get studyComplete => '学習完了';

  @override
  String get accuracy => '正答率';

  @override
  String get wrongAnswers => '間違えた問題';

  @override
  String get studyAgain => 'もう一度学習';

  @override
  String get backToHome => 'ホームに戻る';

  @override
  String get noCardsToStudy => '学習するカードがありません';

  @override
  String get studyExitConfirm => '進捗は保存されません。終了しますか？';

  @override
  String get exit => '終了';

  @override
  String get emptyAnswer => '（空欄）';
}
