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
}
