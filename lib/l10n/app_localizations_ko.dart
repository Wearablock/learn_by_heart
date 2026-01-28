// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => '암기하기 - 문장 암기';

  @override
  String get homeTitle => '내 카드';

  @override
  String get emptyStateTitle => '아직 카드가 없어요';

  @override
  String get emptyStateSubtitle => '첫 번째 카드를 추가해서 암기를 시작하세요';

  @override
  String get addCardButton => '카드 추가';

  @override
  String cardStudyCount(int count) {
    return '$count회 학습';
  }

  @override
  String get cardContentHint => '암기할 내용을 입력하세요';

  @override
  String get deleteCard => '카드 삭제';

  @override
  String get deleteCardConfirm => '이 카드를 삭제할까요?';

  @override
  String get cancel => '취소';

  @override
  String get delete => '삭제';

  @override
  String get save => '저장';

  @override
  String get addCard => '카드 추가';

  @override
  String get editCard => '카드 편집';

  @override
  String get cardContent => '내용';

  @override
  String get cardContentRequired => '내용을 입력해주세요';

  @override
  String get cardHint => '힌트 (선택)';

  @override
  String get cardHintPlaceholder => '기억에 도움이 될 힌트를 입력하세요';

  @override
  String get discardChanges => '변경 취소';

  @override
  String get discardChangesMessage => '저장하지 않은 변경 사항이 있습니다. 취소할까요?';

  @override
  String get keepEditing => '계속 편집';

  @override
  String get discard => '취소';
}
