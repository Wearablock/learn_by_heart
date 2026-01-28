// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '用心学 - 记忆';

  @override
  String get homeTitle => '我的卡片';

  @override
  String get emptyStateTitle => '还没有卡片';

  @override
  String get emptyStateSubtitle => '添加第一张卡片开始记忆';

  @override
  String get addCardButton => '添加卡片';

  @override
  String cardStudyCount(int count) {
    return '学习$count次';
  }

  @override
  String get cardContentHint => '输入要记忆的内容';

  @override
  String get deleteCard => '删除卡片';

  @override
  String get deleteCardConfirm => '确定要删除这张卡片吗？';

  @override
  String get cancel => '取消';

  @override
  String get delete => '删除';

  @override
  String get save => '保存';

  @override
  String get addCard => '添加卡片';

  @override
  String get editCard => '编辑卡片';

  @override
  String get cardContent => '内容';

  @override
  String get cardContentRequired => '请输入内容';

  @override
  String get cardHint => '提示（可选）';

  @override
  String get cardHintPlaceholder => '输入有助于记忆的提示';

  @override
  String get discardChanges => '放弃更改';

  @override
  String get discardChangesMessage => '有未保存的更改，是否放弃？';

  @override
  String get keepEditing => '继续编辑';

  @override
  String get discard => '放弃';

  @override
  String get startStudy => '开始学习';

  @override
  String get studying => '学习中';

  @override
  String get enterAnswer => '输入答案';

  @override
  String get submit => '提交';

  @override
  String get correct => '正确！';

  @override
  String get incorrect => '错误';

  @override
  String get yourAnswer => '你的答案';

  @override
  String get correctAnswerLabel => '正确答案';

  @override
  String get next => '下一个';

  @override
  String get studyComplete => '学习完成';

  @override
  String get accuracy => '正确率';

  @override
  String get wrongAnswers => '错误题目';

  @override
  String get studyAgain => '再次学习';

  @override
  String get backToHome => '返回首页';

  @override
  String get noCardsToStudy => '没有可学习的卡片';

  @override
  String get studyExitConfirm => '进度将不会保存。确定退出？';

  @override
  String get exit => '退出';
}

/// The translations for Chinese, using the Han script (`zh_Hant`).
class AppLocalizationsZhHant extends AppLocalizationsZh {
  AppLocalizationsZhHant() : super('zh_Hant');

  @override
  String get appTitle => '用心學 - 記憶';

  @override
  String get homeTitle => '我的卡片';

  @override
  String get emptyStateTitle => '還沒有卡片';

  @override
  String get emptyStateSubtitle => '新增第一張卡片開始記憶';

  @override
  String get addCardButton => '新增卡片';

  @override
  String cardStudyCount(int count) {
    return '學習$count次';
  }

  @override
  String get cardContentHint => '輸入要記憶的內容';

  @override
  String get deleteCard => '刪除卡片';

  @override
  String get deleteCardConfirm => '確定要刪除這張卡片嗎？';

  @override
  String get cancel => '取消';

  @override
  String get delete => '刪除';

  @override
  String get save => '儲存';

  @override
  String get addCard => '新增卡片';

  @override
  String get editCard => '編輯卡片';

  @override
  String get cardContent => '內容';

  @override
  String get cardContentRequired => '請輸入內容';

  @override
  String get cardHint => '提示（可選）';

  @override
  String get cardHintPlaceholder => '輸入有助於記憶的提示';

  @override
  String get discardChanges => '放棄更改';

  @override
  String get discardChangesMessage => '有未儲存的更改，是否放棄？';

  @override
  String get keepEditing => '繼續編輯';

  @override
  String get discard => '放棄';

  @override
  String get startStudy => '開始學習';

  @override
  String get studying => '學習中';

  @override
  String get enterAnswer => '輸入答案';

  @override
  String get submit => '提交';

  @override
  String get correct => '正確！';

  @override
  String get incorrect => '錯誤';

  @override
  String get yourAnswer => '你的答案';

  @override
  String get correctAnswerLabel => '正確答案';

  @override
  String get next => '下一個';

  @override
  String get studyComplete => '學習完成';

  @override
  String get accuracy => '正確率';

  @override
  String get wrongAnswers => '錯誤題目';

  @override
  String get studyAgain => '再次學習';

  @override
  String get backToHome => '返回首頁';

  @override
  String get noCardsToStudy => '沒有可學習的卡片';

  @override
  String get studyExitConfirm => '進度將不會儲存。確定退出？';

  @override
  String get exit => '退出';
}
