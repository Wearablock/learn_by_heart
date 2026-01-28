// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'احفظ - تذكر';

  @override
  String get homeTitle => 'بطاقاتي';

  @override
  String get emptyStateTitle => 'لا توجد بطاقات بعد';

  @override
  String get emptyStateSubtitle => 'أضف بطاقتك الأولى للبدء';

  @override
  String get addCardButton => 'إضافة بطاقة';

  @override
  String cardStudyCount(int count) {
    return 'تمت الدراسة $count مرات';
  }

  @override
  String get cardContentHint => 'أدخل النص للحفظ';

  @override
  String get deleteCard => 'حذف البطاقة';

  @override
  String get deleteCardConfirm => 'هل أنت متأكد من حذف هذه البطاقة؟';

  @override
  String get cancel => 'إلغاء';

  @override
  String get delete => 'حذف';

  @override
  String get save => 'حفظ';

  @override
  String get addCard => 'إضافة بطاقة';

  @override
  String get editCard => 'تعديل البطاقة';

  @override
  String get cardContent => 'المحتوى';

  @override
  String get cardContentRequired => 'المحتوى مطلوب';

  @override
  String get cardHint => 'تلميح (اختياري)';

  @override
  String get cardHintPlaceholder => 'أدخل تلميحاً للمساعدة في التذكر';

  @override
  String get discardChanges => 'تجاهل التغييرات';

  @override
  String get discardChangesMessage =>
      'لديك تغييرات غير محفوظة. هل تريد تجاهلها؟';

  @override
  String get keepEditing => 'متابعة التعديل';

  @override
  String get discard => 'تجاهل';

  @override
  String get startStudy => 'بدء الدراسة';

  @override
  String get studying => 'جاري الدراسة';

  @override
  String get enterAnswer => 'أدخل إجابتك';

  @override
  String get submit => 'إرسال';

  @override
  String get correct => 'صحيح!';

  @override
  String get incorrect => 'خطأ';

  @override
  String get yourAnswer => 'إجابتك';

  @override
  String get correctAnswerLabel => 'الإجابة الصحيحة';

  @override
  String get next => 'التالي';

  @override
  String get studyComplete => 'اكتملت الدراسة';

  @override
  String get accuracy => 'الدقة';

  @override
  String get wrongAnswers => 'الإجابات الخاطئة';

  @override
  String get studyAgain => 'دراسة مرة أخرى';

  @override
  String get backToHome => 'العودة للرئيسية';

  @override
  String get noCardsToStudy => 'لا توجد بطاقات للدراسة';

  @override
  String get studyExitConfirm => 'لن يتم حفظ التقدم. هل تريد الخروج؟';

  @override
  String get exit => 'خروج';
}
